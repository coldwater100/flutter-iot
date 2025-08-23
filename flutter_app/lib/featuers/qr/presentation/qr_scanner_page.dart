import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../data/qr_scanner_controller.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final scannerController = QRScannerController();
  bool isScanned = false;
  Timer? timeoutTimer;

  @override
  void initState() {
    super.initState();
    scannerController.start();
    timeoutTimer = Timer(const Duration(seconds: 15), () {
      if (!mounted || isScanned) return;
      Fluttertoast.showToast(msg: 'QR 스캔 실패: 시간이 초과되었습니다');
      Navigator.pop(context, null); // null 반환
    });
  }

  @override
  void dispose() {
    timeoutTimer?.cancel();
    try {
      scannerController.stop();
      scannerController.dispose();
    } catch (e) {
      debugPrint("QRScanner dispose error: $e");
    }
    super.dispose();
  }

  void _onQRCodeScanned(String qrText) {
    if (isScanned) return;
    isScanned = true;
    timeoutTimer?.cancel();

    try {
      scannerController.stop();
    } catch (_) {}

    Navigator.pop(context, qrText); // QR 값 반환
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) return;
        try {
          scannerController.stop();
          scannerController.dispose();
        } catch (_) {}
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('QR 코드 스캔')),
        body: MobileScanner(
          controller: scannerController.controller,
          onDetect: (capture) {
            final code = capture.barcodes.firstOrNull?.rawValue;
            if (code != null) {
              _onQRCodeScanned(code);
            }
          },
        ),
      ),
    );
  }
}
