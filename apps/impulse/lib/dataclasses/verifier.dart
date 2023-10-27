import 'dart:async';
import 'package:impulse/dataclasses/challenge.dart';

/// The different types of Verification of a [Challenge]
enum VerificationMethodType { qr, timer, number, picture }

/// A dataclass containing all information needed for a specific Verifier
class Verifier {
  /// The identifier for the [Challenge] this [Verifier] belongs to
  String challengeId;

  /// The methode used for verification
  VerificationMethodType methode;

  /// The string for the QR-Code
  String? qrCode;

  /// The [Duration] for the [Timer]
  Duration? duration;

  /// The minimum value for a [NumberInput]
  int? min;

  /// The maximum value for a [NumberInput]
  int? max;

  /// If the verification can be completed in this state of the [Verifier]
  bool isFinishable;

  /// If the verification was already finished
  ///
  /// This allows for skipping a finished [Verifier]
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
