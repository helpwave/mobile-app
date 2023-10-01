enum VerificationMethodType { qr, timer, number, picture }

class Verifier {
  String challengeId;
  VerificationMethodType methode;
  String? qrCode;
  Duration? duration;
  int? min;
  int? max;
  bool isFinishable;
  bool wasFinished = false;

  Verifier({
    required this.challengeId,
    required this.methode,
    this.qrCode,
    this.duration,
    this.min,
    this.max,
    this.isFinishable = false,
  });
}
