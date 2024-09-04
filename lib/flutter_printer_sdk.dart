
import 'flutter_printer_sdk_platform_interface.dart';

class FlutterPrinterSdk {
  Future<String?> getPlatformVersion() {
    return FlutterPrinterSdkPlatform.instance.getPlatformVersion();
  }
}
