import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:impulse/components/number_input.dart';
import 'package:impulse/components/qr_scanner_wrapper.dart';
import 'package:impulse/components/timer_component.dart';
import 'package:impulse/dataclasses/verifier.dart';
import 'package:impulse/theming/colors.dart';

abstract class VerificationMethod extends StatelessWidget {
  final Verifier verifier;
  final void Function() onFinish;

  const VerificationMethod(
      {super.key, required this.verifier, required this.onFinish});
}

class QRVerification extends VerificationMethod {
  const QRVerification(
      {super.key, required super.verifier, required super.onFinish});

  @override
  Widget build(BuildContext context) {
    assert(verifier.qrCode != null);
    const double width = 200;

    return Container(
      width: width,
      height: width,
      decoration: const BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadiusVeryBig),
        ),
      ),
      padding: const EdgeInsets.all(paddingSmall),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(borderRadiusVeryBig - paddingSmall),
        ),
        child: verifier.isFinishable
            ? Container(
                color: primary,
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: iconSizeBig,
                  ),
                ),
              )
            : QRViewScannerWrapper(
                onResult: (barcode) {
                  // TODO do some qr code verification here
                  verifier.isFinishable = true;
                  onFinish();
                },
              ),
      ),
    );
  }
}

class TimerVerification extends VerificationMethod {
  const TimerVerification(
      {super.key, required super.verifier, required super.onFinish});

  @override
  Widget build(BuildContext context) {
    assert(verifier.duration != null);

    return TimerComponent(
      onFinish: () {
        verifier.isFinishable = true;
        onFinish();
      },
      duration: verifier.duration!,
    );
  }
}

class NumberVerification extends VerificationMethod {
  final int startValue = 0;

  const NumberVerification({
    super.key,
    required super.verifier,
    required super.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    assert(verifier.min != null && verifier.max != null);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NumberInput(
          value: startValue,
          onChanged: (_) {
            verifier.isFinishable = true;
          },
        ),
      ],
    );
  }
}

class CameraVerification extends VerificationMethod {
  const CameraVerification(
      {super.key, required super.verifier, required super.onFinish});

  @override
  Widget build(BuildContext context) {
    return const Text("Camera Verification");
  }
}
