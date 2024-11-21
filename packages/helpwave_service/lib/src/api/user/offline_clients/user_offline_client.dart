import 'package:grpc/grpc.dart';
import 'package:helpwave_service/src/api/offline/offline_client_store.dart';
import 'package:helpwave_service/src/api/offline/util.dart';
import 'package:helpwave_service/src/api/user/index.dart';
import 'package:helpwave_proto_dart/services/user_svc/v1/user_svc.pbgrpc.dart';

class UserUpdate {
  final String id;

  UserUpdate({required this.id});
}

class UserOfflineService {
  List<User> users = [];

  User? find(String id) {
    int index = users.indexWhere((user) => user.id == id);
    if (index == -1) {
      return null;
    }
    return users[index];
  }

  List<User> findUsers() {
    return users;
  }

  void create(User user) {
    users.add(user);
  }

  void update(UserUpdate user) {
    bool found = false;

    users = users.map((u) {
      if (u.id == user.id) {
        found = true;
        return u.copyWith();
      }
      return u;
    }).toList();

    if (!found) {
      throw Exception('UpdateUser: Could not find user with id ${user.id}');
    }
  }

  void delete(String userId) {
    users.removeWhere((u) => u.id == userId);
  }
}

class UserOfflineClient extends UserServiceClient {
  UserOfflineClient(super.channel);

  @override
  ResponseFuture<ReadPublicProfileResponse> readPublicProfile(ReadPublicProfileRequest request,
      {CallOptions? options}) {
    final user = OfflineClientStore().userStore.find(request.id);
    if (user == null) {
      return MockResponseFuture.error(Exception('ReadPublicProfile: Could not find user with id ${request.id}'));
    }
    final response = ReadPublicProfileResponse()
      ..id = user.id
      ..name = user.name
      ..nickname = user.nickName
      ..avatarUrl = user.profileUrl.toString();
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<ReadSelfResponse> readSelf(ReadSelfRequest request, {CallOptions? options}) {
    final user = OfflineClientStore().userStore.users[0];

    final organizations = OfflineClientStore()
        .organizationStore
        .findOrganizations()
        .map((org) => ReadSelfOrganization(id: org.id))
        .toList();

    final response = ReadSelfResponse()
      ..id = user.id
      ..name = user.name
      ..nickname = user.nickName
      ..avatarUrl = user.profileUrl.toString()
      ..organizations.addAll(organizations);

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<CreateUserResponse> createUser(CreateUserRequest request, {CallOptions? options}) {
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: request.name,
      nickName: request.nickname,
      email: request.email,
      profileUrl: Uri.parse('https://helpwave.de/favicon.ico'),
    );

    OfflineClientStore().userStore.create(newUser);

    final response = CreateUserResponse()..id = newUser.id;
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<UpdateUserResponse> updateUser(UpdateUserRequest request, {CallOptions? options}) {
    final update = UserUpdate(id: request.id);

    try {
      OfflineClientStore().userStore.update(update);
      final response = UpdateUserResponse();
      return MockResponseFuture.value(response);
    } catch (e) {
      return MockResponseFuture.error(e);
    }
  }
}
