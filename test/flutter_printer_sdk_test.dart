import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_printer_sdk/flutter_printer_sdk.dart';
import 'package:flutter_printer_sdk/flutter_printer_sdk_platform_interface.dart';
import 'package:flutter_printer_sdk/flutter_printer_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterPrinterSdkPlatform
    with MockPlatformInterfaceMixin
    implements FlutterPrinterSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterPrinterSdkPlatform initialPlatform = FlutterPrinterSdkPlatform.instance;

  test('$MethodChannelFlutterPrinterSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterPrinterSdk>());
  });

  test('getPlatformVersion', () async {
    FlutterPrinterSdk flutterPrinterSdkPlugin = FlutterPrinterSdk();
    MockFlutterPrinterSdkPlatform fakePlatform = MockFlutterPrinterSdkPlatform();
    FlutterPrinterSdkPlatform.instance = fakePlatform;

    expect(await flutterPrinterSdkPlugin.getPlatformVersion(), '42');
  });
}
