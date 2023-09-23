import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/proto/services/impulse_svc/v1/impulse_svc.pbgrpc.dart';
import 'package:impulse/dataclasses/challange.dart';
import 'package:impulse/services/grpc_client_svc.dart';

class ImpulseService {
  ImpulseServiceClient impulseService =
      GRPCClientService.getImpulseServiceClient;

  Future<List<Challenge>> getActiveChallenges() async {
    GetActiveChallengesRequest request = GetActiveChallengesRequest();

    GetActiveChallengesResponse response = await impulseService.getActiveChallenges(
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
            ))
        .toList();
    return challenges;
  }
}
