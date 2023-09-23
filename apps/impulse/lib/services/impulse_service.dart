import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/proto/services/impulse_svc/v1/impulse_svc.pbgrpc.dart';
import 'package:impulse/dataclasses/challange.dart';
import 'package:impulse/services/grpc_client_svc.dart';

class ImpulseService {
  ImpulseServiceClient impulseService =
      GRPCClientService.getImpulseServiceClient;

  Future<List<Challenge>> getChallenges() async {
    GetChallengesRequest request = GetChallengesRequest();

    GetChallengesResponse response = await impulseService.getChallenges(
      request,
      options: CallOptions(
        metadata: GRPCClientService().getImpulseServiceMetaData(),
      ),
    );

    List<Challenge> challenges = response.challenges
        .map((challenge) => Challenge(
              id: challenge.id,
              title: challenge.title,
              description: challenge.description,
              startAt: DateTime.fromMillisecondsSinceEpoch(
                  challenge.startAt.seconds as int),
              endAt: DateTime.fromMillisecondsSinceEpoch(
                  challenge.startAt.seconds as int),
              type: challenge.type,
              category: challenge.category,
              threshold: challenge.threshold as int,
              points: challenge.points as int,
            ))
        .toList();
    return challenges;
  }
}
