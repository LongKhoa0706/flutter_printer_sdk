import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_printer_sdk_method_channel.dart';

abstract class FlutterPrinterSdkPlatform extends PlatformInterface {
  /// Constructs a FlutterPrinterSdkPlatform.
  FlutterPrinterSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPrinterSdkPlatform _instance = MethodChannelFlutterPrinterSdk();

  /// The default instance of [FlutterPrinterSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterPrinterSdk].
  static FlutterPrinterSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterPrinterSdkPlatform] when
  /// they register themselves.
  static set instance(FlutterPrinterSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
