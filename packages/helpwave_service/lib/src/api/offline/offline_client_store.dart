import 'package:helpwave_service/src/api/tasks/offline_clients/bed_offline_client.dart';
import 'package:helpwave_service/src/api/tasks/offline_clients/patient_offline_client.dart';
import 'package:helpwave_service/src/api/tasks/offline_clients/room_offline_client.dart';
import 'package:helpwave_service/src/api/tasks/offline_clients/task_offline_client.dart';
import 'package:helpwave_service/src/api/tasks/offline_clients/template_offline_client.dart';
import 'package:helpwave_service/src/api/tasks/offline_clients/ward_offline_client.dart';
import 'package:helpwave_service/src/api/user/offline_clients/organization_offline_client.dart';
import 'package:helpwave_service/src/api/user/offline_clients/user_offline_client.dart';
import '../../../user.dart';

const String profileUrl = "https://helpwave.de/favicon.ico";

final List<Organization> initialOrganizations = [
  Organization(
      id: "organization1",
      shortName: "Test",
      longName: "Test Organization",
      avatarURL: profileUrl,
      email: "test@helpwave.de",
      isPersonal: false,
      isVerified: true),
  Organization(
      id: "organization2",
      shortName: "MK",
      longName: "Musterklinikum",
      avatarURL: profileUrl,
      email: "test@helpwave.de",
      isPersonal: false,
      isVerified: true),
];
final List<User> initialUsers = [
  User(
    id: "user1",
    name: "Testine Test",
    nickName: "Testine",
    email: "test@helpwave.de",
    profileUrl: Uri.parse(profileUrl),
  ),
  User(
    id: "user2",
    name: "Peter Pete",
    nickName: "Peter",
    email: "test@helpwave.de",
    profileUrl: Uri.parse(profileUrl),
  ),
  User(
    id: "user3",
    name: "John Doe",
    nickName: "John",
    email: "test@helpwave.de",
    profileUrl: Uri.parse(profileUrl),
  ),
  User(
    id: "user4",
    name: "Walter White",
    nickName: "Walter",
    email: "test@helpwave.de",
    profileUrl: Uri.parse(profileUrl),
  ),
  User(
    id: "user5",
    name: "Peter Parker",
    nickName: "Parker",
    email: "test@helpwave.de",
    profileUrl: Uri.parse(profileUrl),
  ),
];

class OfflineClientStore {
  static final OfflineClientStore _instance = OfflineClientStore._internal();

  OfflineClientStore._internal();

  factory OfflineClientStore() => _instance;

  final OrganizationOfflineClientStore organizationStore = OrganizationOfflineClientStore();
  final UserOfflineService userStore = UserOfflineService();

  final WardOfflineService wardStore = WardOfflineService();
  final RoomOfflineService roomStore = RoomOfflineService();
  final BedOfflineService bedStore = BedOfflineService();
  final PatientOfflineService patientStore = PatientOfflineService();
  final TaskOfflineService taskStore = TaskOfflineService();
  final SubtaskOfflineService subtaskStore = SubtaskOfflineService();
  final TaskTemplateOfflineService taskTemplateStore = TaskTemplateOfflineService();
  final TaskTemplateSubtaskOfflineService taskTemplateSubtaskStore = TaskTemplateSubtaskOfflineService();

  void reset() {
    organizationStore.organizations = initialOrganizations;
    userStore.users = initialUsers;

  }
}
