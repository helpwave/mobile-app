import 'package:fixnum/src/int64.dart';
import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/proto/services/impulse_svc/v1/impulse_svc.pbgrpc.dart';
import 'package:impulse/dataclasses/challange.dart';
import 'package:impulse/dataclasses/reward.dart';
import 'package:impulse/dataclasses/team.dart';
import 'package:impulse/dataclasses/user.dart';
import 'package:impulse/services/grpc_client_svc.dart';

class ImpulseService {
  ImpulseServiceClient impulseService =
      GRPCClientService.getImpulseServiceClient;

  Future<User> createUser(User user) async {
    CreateUserRequest request = CreateUserRequest();
    request.username = user.username;
    request.birthday = user.birthday.toIso8601String();
    request.pal = user.pal;
    // TODO update
    request.gender = user.gender.toString();

    CreateUserResponse response = await impulseService.createUser(
      request,
      options: CallOptions(
        metadata: GRPCClientService().getImpulseServiceMetaData(),
      ),
    );

    user.id = response.userId;

    return user;
  }

  Future<User> updateUser(User user) async {
    UpdateUserRequest request = UpdateUserRequest();
    request.birthday = user.birthday.toIso8601String();
    request.pal = user.pal;
    // TODO update
    request.gender = user.gender.toString();
    request.userId = user.id;
    request.teamId = user.teamId;

    await impulseService.updateUser(
      request,
      options: CallOptions(
        metadata: GRPCClientService().getImpulseServiceMetaData(),
      ),
    );

    return user;
  }

  Future<List<Challenge>> getActiveChallenges() async {
    GetActiveChallengesRequest request = GetActiveChallengesRequest();

    GetActiveChallengesResponse response =
        await impulseService.getActiveChallenges(
      request,
      options: CallOptions(
        metadata: GRPCClientService().getImpulseServiceMetaData(),
      ),
    );

    List<Challenge> challenges = response.challenges
        .map((challenge) => Challenge(
              id: challenge.challengeId,
              title: challenge.title,
              description: challenge.description,
              startAt: DateTime.parse(challenge.startAt),
              endAt: DateTime.parse(challenge.startAt),
              type: challenge.type,
              category: challenge.category,
              threshold: challenge.threshold as int,
              points: challenge.points as int,
              verifiers: [],
            ))
        .toList();
    return challenges;
  }

  Future<String> trackChallenge(String userId, String challengeId, int score) async {
    TrackChallengeRequest request = TrackChallengeRequest();
    request.userId = userId;
    request.challengeId = challengeId;
    request.score = score as Int64;
    request.doneAt = DateTime.now().toIso8601String();

    TrackChallengeResponse response =
    await impulseService.trackChallenge(
      request,
      options: CallOptions(
        metadata: GRPCClientService().getImpulseServiceMetaData(),
      ),
    );

    return response.challengeId;
  }

  Future<List<Reward>> getReward() async {
    GetRewardsRequest request = GetRewardsRequest();

    GetRewardsResponse response = await impulseService.getRewards(
      request,
      options: CallOptions(
        metadata: GRPCClientService().getImpulseServiceMetaData(),
      ),
    );

    List<Reward> rewards = response.rewards
        .map((reward) => Reward(
              title: reward.title,
              description: reward.description,
              points: reward.points as int,
              id: reward.rewardId,
            ))
        .toList();

    return rewards;
  }

  Future<List<Reward>> getRewards() async {
    GetAllRewardsRequest request = GetAllRewardsRequest();

    GetAllRewardsResponse response = await impulseService.getAllRewards(
      request,
      options: CallOptions(
        metadata: GRPCClientService().getImpulseServiceMetaData(),
      ),
    );

    List<Reward> rewards = response.rewards
        .map((reward) => Reward(
              title: reward.title,
              description: reward.description,
              points: reward.points as int,
              id: reward.rewardId,
            ))
        .toList();

    return rewards;
  }

  Future<int> getScore(String userId) async {
    GetScoreRequest request = GetScoreRequest();
    request.userId = userId;

    GetScoreResponse response = await impulseService.getScore(
      request,
      options: CallOptions(
        metadata: GRPCClientService().getImpulseServiceMetaData(),
      ),
    );

    return response.score as int;
  }

  Future<List<Team>> getTeams() async {
    GetAllTeamsRequest request = GetAllTeamsRequest();

    GetAllTeamsResponse response = await impulseService.getAllTeams(
      request,
      options: CallOptions(
        metadata: GRPCClientService().getImpulseServiceMetaData(),
      ),
    );

    List<Team> rewards = response.teams
        .map((team) => Team(
              name: team.name,
              description: team.description,
              image: team.image,
              id: team.teamId,
            ))
        .toList();

    return rewards;
  }
}
