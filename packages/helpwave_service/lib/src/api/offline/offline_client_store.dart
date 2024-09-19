import 'package:helpwave_service/src/api/tasks/index.dart';
import 'package:helpwave_service/src/api/tasks/offline_clients/bed_offline_client.dart';
import 'package:helpwave_service/src/api/tasks/offline_clients/patient_offline_client.dart';
import 'package:helpwave_service/src/api/tasks/offline_clients/room_offline_client.dart';
import 'package:helpwave_service/src/api/tasks/offline_clients/task_offline_client.dart';
import 'package:helpwave_service/src/api/tasks/offline_clients/template_offline_client.dart';
import 'package:helpwave_service/src/api/tasks/offline_clients/ward_offline_client.dart';
import 'package:helpwave_service/src/api/user/offline_clients/organization_offline_client.dart';
import 'package:helpwave_service/src/api/user/offline_clients/user_offline_client.dart';
import 'package:helpwave_util/lists.dart';
import '../../../user.dart';

const String profileUrl = "https://helpwave.de/favicon.ico";

final List<Organization> initialOrganizations = [
  Organization(
      id: "organization1",
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
final List<Ward> initialWards = initialOrganizations
    .map((organization) => range(0, 3).map((index) =>
        Ward(id: "${organization.id}${index + 1}", name: "Ward ${index + 1}", organizationId: organization.id)))
    .expand((element) => element)
    .toList();
final List<RoomWithWardId> initialRooms = initialWards
    .map((ward) => range(0, 2)
        .map((index) => RoomWithWardId(id: "${ward.id}${index + 1}", name: "Room ${index + 1}", wardId: ward.id)))
    .expand((element) => element)
    .toList();
final List<BedWithRoomId> initialBeds = initialRooms
    .map((room) => range(0, 4)
        .map((index) => BedWithRoomId(id: "${room.id}${index + 1}", name: "Bed ${index + 1}", roomId: room.id)))
    .expand((element) => element)
    .toList();
final List<PatientWithBedId> initialPatients = initialBeds.indexed
    .map<PatientWithBedId>((e) => PatientWithBedId(
          id: "patient${e.$1}",
          name: "Patient ${e.$1 + 1}",
          notes: "",
          isDischarged: e.$1 % 6 == 0,
          bedId: e.$1 % 2 == 0 ? e.$2.id : null,
        ))
    .toList();
final List<Task> initialTasks = initialPatients
    .map((patient) => range(0, 3).map((index) => Task(
          id: "${patient.id}${index + 1}",
          name: "Task ${index + 1}",
          patientId: patient.id,
          notes: '',
          assigneeId: [initialUsers[0].id, null, initialUsers[2].id][index],
        )))
    .expand((element) => element)
    .toList();
final List<Subtask> initialTaskSubtasks = initialTasks
    .map((task) => range(0, 2).map((index) => Subtask(
          id: "${task.id}${index + 1}",
          name: "Subtask ${index + 1}",
          taskId: task.id,
        )))
    .expand((element) => element)
    .toList();
final List<TaskTemplate> initialTaskTemplates = range(0, 5)
        .map((index) => TaskTemplate(
              id: "template$index",
              name: "template${index + 1}",
              notes: "",
            ))
        .toList() +
    initialWards
        .map((ward) => TaskTemplate(
              id: "wardTemplate${ward.id}",
              name: "Ward ${ward.name} Template",
              notes: "",
              wardId: ward.id,
            ))
        .toList();
final List<Subtask> initialTaskTemplateSubtasks = initialTasks
    .map((task) => range(0, 3).map((index) => Subtask(
          id: "${task.id}${index + 1}",
          name: "Template Subtask ${index + 1}",
          taskId: task.id,
        )))
    .expand((element) => element)
    .toList();

class OfflineClientStore {
  static final OfflineClientStore _instance = OfflineClientStore._internal()..reset();

  OfflineClientStore._internal();

  factory OfflineClientStore() => _instance;

  final OrganizationOfflineService organizationStore = OrganizationOfflineService();
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
    wardStore.wards = initialWards;
    roomStore.rooms = initialRooms;
    bedStore.beds = initialBeds;
    patientStore.patients = initialPatients;
    taskStore.tasks = initialTasks;
    subtaskStore.subtasks = initialTaskSubtasks;
    taskTemplateStore.taskTemplates = initialTaskTemplates;
    taskTemplateSubtaskStore.taskTemplateSubtasks = initialTaskTemplateSubtasks;
  }
}
