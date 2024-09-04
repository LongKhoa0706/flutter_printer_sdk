import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;

class PrinterManager {
  static const MethodChannel _channel =
  MethodChannel('flutter_printer_sdk_plugin');

  // Private constructor to prevent external instantiation
  PrinterManager._internal() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  // Singleton instance
  static final PrinterManager _instance = PrinterManager._internal();

  // Factory constructor to return the same instance
  factory PrinterManager() {
    return _instance;
  }

  Function(int result)? _onConnectRet;

  Function? searchCallback;

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'connectRet':
        int result = call.arguments['result'];
        if (_onConnectRet != null) {
          _onConnectRet!(result);
        }
        break;
      case 'searchBt':
        searchCallback?.call(call.arguments);
        break;
      default:
        print('Unknown method ${call.method}');
    }
  }

  Future<void> sendESC(List<Map<String, dynamic>> data) async {
    try {
      Map<String, Object> args = Map();
      args['data'] = data;
      await _channel.invokeMethod('sendESC', args);
    } on PlatformException catch (e) {
      print("Failed to sendESC: '${e.message}'.");
      throw e;
    }
  }

  Future<void> sendTSPL(List<Map<String, dynamic>> data) async {
    try {
      Map<String, Object> args = Map();
      args['data'] = data;
      await _channel.invokeMethod('sendTSPL', args);
    } on PlatformException catch (e) {
      print("Failed to sendTSPL: '${e.message}'.");
      throw e;
    }
  }

  Future<void> sendZPL(List<Map<String, dynamic>> data) async {
    try {
      Map<String, Object> args = Map();
      args['data'] = data;
      await _channel.invokeMethod('sendZPL', args);
    } on PlatformException catch (e) {
      print("Failed to sendZPL: '${e.message}'.");
      throw e;
    }
  }

  Future<bool> checkPermissions() async {
    try {
      final bool result =
      await _channel.invokeMethod('checkPermissions');
      return result;
    } on PlatformException catch (e) {
      print("Failed to check permissions: '${e.message}'.");
      return false;
    }
  }

  Future<List> getUsbPaths() async {
    final result = await _channel.invokeMethod('getUsbPaths');
    return result;
  }

  Future<void> startScan() async {
    try {
      await _channel.invokeMethod('startScan');
    } on PlatformException catch (e) {
      print("Failed to start scan: '${e.message}'.");
    }
  }

  Future<void> disconnect() async {
    try {
      await _channel.invokeMethod('disconnect');
    } on PlatformException catch (e) {
      print("Failed to disconnect: '${e.message}'.");
    }
  }

  Future<int> posPrinterStatus() async {
    try {
      final int result = await _channel.invokeMethod('posPrinterStatus');
      return result;
    } on PlatformException catch (e) {
      print("Failed to posPrinterStatus: '${e.message}'.");
      return -1;
    }
  }

  Future<String> getSerialNumber() async {
    try {
      final String result = await _channel.invokeMethod('getSerialNumber');
      return result;
    } on PlatformException catch (e) {
      print("Failed to getSerialNumber: '${e.message}'.");
      return "";
    }
  }

  Future<int> checkIsConnect() async {
    try {
      final int result = await _channel.invokeMethod('checkIsConnect');
      return result;
    } on PlatformException catch (e) {
      print("Failed to checkIsConnect: '${e.message}'.");
      return 0;
    }
  }

  Future<void> openCashBox() async {
    try {
      await _channel.invokeMethod('openCashBox');
    } on PlatformException catch (e) {
      print("Failed to openCashBox: '${e.message}'.");
    }
  }

  Future<int> cashBoxCheck() async {
    try {
      final int result = await _channel.invokeMethod('cashBoxCheck');
      return result;
    } on PlatformException catch (e) {
      print("Failed to cashBoxCheck: '${e.message}'.");
      return -1;
    }
  }

  Future<int> labelPrinterStatus(int timeout) async {
    try {
      final int result = await _channel.invokeMethod('labelPrinterStatus',{"timeout": timeout});
      return result;
    } on PlatformException catch (e) {
      print("Failed to labelPrinterStatus: '${e.message}'.");
      return -1;
    }
  }

  Future<void> connectBt(String address, Function(int result) callback) async {
    try {
      _onConnectRet = callback;
      await _channel.invokeMethod('connectBt', {"address": address});
    } on PlatformException catch (e) {
      print("Failed to connect Bluetooth: '${e.message}'.");
      throw e;
    }
  }

  Future<void> connectUsb(String path, Function(int result) callback) async {
    try {
      _onConnectRet = callback;
      await _channel.invokeMethod('connectUsb', {"path": path});
    } on PlatformException catch (e) {
      print("Failed to connect Usb: '${e.message}'.");
      throw e;
    }
  }

  Future<void> connectNet(String path, Function(int result) callback) async {
    try {
      _onConnectRet = callback;
      await _channel.invokeMethod('connectNet', {"address": path});
    } on PlatformException catch (e) {
      print("Failed to connect Usb: '${e.message}'.");
      throw e;
    }
  }

  Future<void> setBluetooth(String name,String pin) async {
    try {
      await _channel.invokeMethod('setBluetooth', {"name": name,"pin":pin});
    } on PlatformException catch (e) {
      print("Failed to csetBluetooth: '${e.message}'.");
      throw e;
    }
  }

   Future<String?> saveDataAsPDF(Uint8List data, String fileName,int width,int height,bool isShow) async {
    try {
      final result = await _channel.invokeMethod('saveDataAsPDF', {
        'data': data,
        'fileName': fileName,
        'width': width,
        'height': height,
        'isShow': isShow,
      });
      return result;
    } on PlatformException catch (e) {
      print('Failed to save data as PDF: ${e.message}');
      return null;
    }
  }

  Future<void> printPDF(String path,int x,int y,int pageWidth) async {
    try {
      await _channel.invokeMethod('printPDF', {
        "path": path,
        "x": x,
        "y": y,
        "pageWidth": pageWidth,
      });
    } on PlatformException catch (e) {
      print("Failed to printPDF: '${e.message}'.");
      throw e;
    }
  }

  /// TSPL set CodePage
  Future<void> setCodePage(String codepage) async {
    try {
      await _channel.invokeMethod('setCodePage', {"codepage": codepage});
    } on PlatformException catch (e) {
      print("Failed to setCodePage: '${e.message}'.");
      throw e;
    }
  }

  /// POS set Codepage
  Future<void> selectCodePage(int codepage) async {
    try {
      await _channel.invokeMethod('selectCodePage', {"page": codepage});
    } on PlatformException catch (e) {
      print("Failed to selectCodePage: '${e.message}'.");
      throw e;
    }
  }

}

