import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

/// A Wrapper for the QR code scanner
class QRViewScannerWrapper extends StatefulWidget {
  /// The callback once the Scanner produces a result
  final void Function(Barcode barcode) onResult;

  const QRViewScannerWrapper({Key? key, required this.onResult}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewScannerWrapperState();
}

class _QRViewScannerWrapperState extends State<QRViewScannerWrapper> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      widget.onResult(scanData);
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void reassemble() {
    // Only for proper debug updates
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }
}
