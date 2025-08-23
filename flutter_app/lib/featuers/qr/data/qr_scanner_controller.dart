import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerController {
  final MobileScannerController controller = MobileScannerController();

  void start() {
    controller.start();
  }

  void stop() {
    controller.stop();
  }

  void dispose() {
    controller.dispose();
  }
}
