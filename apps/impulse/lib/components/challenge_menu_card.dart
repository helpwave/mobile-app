import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:impulse/components/verification_method.dart';
import 'package:impulse/dataclasses/verifier.dart';
import 'package:impulse/theming/colors.dart';

/// A [Card] showing the [Challenge] and a [Verifier] for it
class ChallengeMenuCard extends StatefulWidget {
  /// A [Text] showing the progress of the current [Challenge]
  ///
  /// e.g. 2/3
  final String progressText;

  /// The [title] of the [Challenge]
  final String title;

  /// The [description] of the [Challenge]
  final String description;

  /// The [verifier] of the [Challenge]
  ///
  /// Used to determine the [VerificationMethod] by the [VerificationMethodType]
  final Verifier verifier;

  /// The callback once this [Challenge]'s completion is verified by the [verifier]
  final void Function() onFinish;

  const ChallengeMenuCard({
    super.key,
    required this.progressText,
    required this.title,
    required this.description,
    required this.verifier,
    required this.onFinish,
  });

  @override
  State<StatefulWidget> createState() => _ChallengeMenuCardState();
}

class _ChallengeMenuCardState extends State<ChallengeMenuCard> {
  /// Maps the [verifier] to the corresponding [Widget]
  VerificationMethod getVerificationMethod() {
    Verifier currentVerifier = widget.verifier;
    switch (widget.verifier.methode) {
      case VerificationMethodType.qr:
        return QRVerification(
          verifier: currentVerifier,
          onFinish: () {
            setState(() {});
          },
        );
      case VerificationMethodType.timer:
        return TimerVerification(
          verifier: currentVerifier,
          onFinish: () {
            setState(() {});
          },
        );
      case VerificationMethodType.number:
        return NumberVerification(
          key: GlobalKey(),
          verifier: currentVerifier,
          onFinish: widget.onFinish,
        );
      case VerificationMethodType.picture:
        return CameraVerification(
          verifier: currentVerifier,
          onFinish: widget.onFinish,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    const double width = 215;

    return Card(
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const SizedBox(height: distanceMedium),
            Text(
              widget.progressText,
              textAlign: TextAlign.center,
              style: const TextStyle(color: primary, fontWeight: FontWeight.w700, fontSize: 30),
            ),
            const SizedBox(height: distanceSmall),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: primary, fontWeight: FontWeight.w700, fontSize: 22),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: distanceMedium),
              child: Text(
                widget.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              ),
            ),
            Flexible(flex: 1, child: Container()),
            getVerificationMethod(),
            Flexible(
              flex: 4,
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.all(paddingMedium),
              child: ElevatedButton(
                onPressed: widget.verifier.isFinishable ? widget.onFinish : null,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return disabled;
                    }
                    return primary;
                  }),
                  fixedSize: const MaterialStatePropertyAll(
                    Size.fromWidth(width),
                  ),
                ),
                child: const Text(
                  "Nächster Schritt",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
