import 'package:helpwave_proto_dart/proto/services/impulse_svc/v1/impulse_svc.pbenum.dart';

enum VerificationMethodType { qr, timer, number, picture }

class Verifier {
  VerificationMethodType methode;
  String? qrCode;
  Duration? duration;
  int? min;
  int? max;
  bool isFinishable;
  bool wasFinished = false;

  Verifier({
    required this.methode,
    this.qrCode,
    this.duration,
    this.min,
    this.max,
    this.isFinishable = false,
  });
}

class Challenge {
  String id;
  String title;
  String description;
  DateTime startAt;
  DateTime endAt;
  ChallengeCategory category;
  ChallengeType type;
  int threshold;
  int points;
  List<Verifier> verifiers = [];

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.startAt,
    required this.endAt,
    required this.type,
    required this.category,
    required this.threshold,
    required this.points,
    required this.verifiers,
  });
}
