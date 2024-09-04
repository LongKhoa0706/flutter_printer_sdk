import 'package:flutter/material.dart';
import 'package:flutter_printer_sdk/printer_test.dart';
import 'package:flutter_printer_sdk/printer_manager.dart';
import 'package:flutter_printer_sdk/pos_command.dart';

class POSDemoView extends StatefulWidget {
  @override
  _POSDemoViewState createState() => _POSDemoViewState();
}

class _POSDemoViewState extends State<POSDemoView> {

  final PrinterManager _printerManager = PrinterManager();
  TextEditingController _bluetoothNameController = TextEditingController();
  TextEditingController _bluetoothPinController = TextEditingController();

  final List<String> _buttonLabels = [
    'PRINT TEXT',
    'PRINT BARCODE',
    'PRINT QRCODE',
    'PRINT IMAGE',
    'OPEN CASH DRAWER',
    'CHECKCONNECT',
    'PRINT STATUS',
    'SET BLUETOOTH',
    'QUERY SN',
    // 'BITMAP MODEL',
    'CASH DRAWER CHECK',
    'NV Download',
    'NV PRINT'
  ];

  @override
  void initState() {
    super.initState();
  }

  static void showToast(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 1000),
      content: Text(msg),
    ));
  }

  void _printText() {
    print('PRINT TEXT functionality');
    _printerManager.sendESC(PrinterTest().printTextPOS());
  }

  void _printBarcode() {
    print('PRINT BARCODE functionality');
    _printerManager.sendESC(PrinterTest().printBarcodePOS());
  }

  void _printQRCode() {
    print('PRINT QRCODE functionality');
    _printerManager.sendESC(PrinterTest().printQRCodePOS());
  }

  void _printImage() {
    print('PRINT IMAGE functionality');
    PrinterTest().printPicPOS().then((value) {
      _printerManager.sendESC(value);
    });
  }

  void _openCashDrawer() {
    print('OPEN CASH DRAWER functionality');
    _printerManager.openCashBox();
  }

  void _checkConnect() {
    print('CHECKCONNECT functionality');
    _printerManager.checkIsConnect().then((value) {
      showToast((value > 0)?"Connect":"Disconnect", context);
    });
  }

  void _cashDrawerCheck(BuildContext context) {
    _printerManager.cashBoxCheck().then((value) {
      switch (value) {
        case POSConst.STS_CASH_OPEN:
          showToast("cash drawer open", context);
          break;
        case POSConst.STS_CASH_CLOSE:
          showToast("cash drawer close", context);
          break;
        default:
          showToast("Unknown cash drawer status", context);
          break;
      }
    });
  }

  void _nvDownload() {
    PrinterTest().nvDownloadPOS().then((value) {
      _printerManager.sendESC(value);
    });
  }

  void _nvPrint() {
    _printerManager.sendESC(PrinterTest().nvPrintPOS());
  }

  void _printStatus(BuildContext context) {
    print('PRINT STATUS functionality');
    _printerManager.posPrinterStatus().then((value) {
      switch (value) {
        case POSConst.STS_NORMAL:
          showToast("printer normal", context);
          break;
        case POSConst.STS_COVEROPEN:
          showToast("printer front cover open", context);
          break;
        case POSConst.STS_PAPEREMPTY:
          showToast("printer out of paper", context);
          break;
        case POSConst.STS_COVEROPEN_PAPEREMPTY:
          showToast("printer front cover open and out of paper", context);
          break;
        case POSConst.STS_PRESS_FEED:
          showToast("Feed button pressed", context);
          break;
        case POSConst.STS_PRINTER_ERR:
          showToast("printer error", context);
          break;
        default:
          showToast("Unknown printer status", context);
          break;
      }
    });
  }

  void _setBluetooth() {
    _bluetoothNameController.text = "printer001";
    _bluetoothPinController.text = "0000";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modify Bluetooth info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text('Name:'),
                  Expanded(
                    child: TextField(
                      controller: _bluetoothNameController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Pin:'),
                  Expanded(
                    child: TextField(
                      controller: _bluetoothPinController,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String bluetoothName = _bluetoothNameController.text;
                String bluetoothPin = _bluetoothPinController.text;
                _printerManager.setBluetooth(bluetoothName, bluetoothPin);
                Navigator.of(context).pop();
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void _querySN(BuildContext context) {
    print('QUERY SN functionality');
    _printerManager.getSerialNumber().then((value) {
      showToast("SN:$value", context);
    });
  }

  void _bitmapModel() {
    print('BITMAP MODEL functionality');
    PrinterTest().selectBitmapModel().then((value) {
      _printerManager.sendESC(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('POS Demo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two buttons per row
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 4, // Adjust the height of the buttons
                ),
                itemCount: _buttonLabels.length,
                itemBuilder: (BuildContext context, int index) {
                  return ElevatedButton(
                    onPressed: () {
                      // Placeholder for each button's action
                      print('${_buttonLabels[index]} button pressed');

                      if (_buttonLabels[index] == 'PRINT TEXT') {
                        _printText();
                      } else if (_buttonLabels[index] == 'PRINT BARCODE') {
                        _printBarcode();
                      } else if (_buttonLabels[index] == 'PRINT QRCODE') {
                        _printQRCode();
                      } else if (_buttonLabels[index] == 'PRINT IMAGE') {
                        _printImage();
                      } else if (_buttonLabels[index] == 'OPEN CASH DRAWER') {
                        _openCashDrawer();
                      } else if (_buttonLabels[index] == 'CHECKCONNECT') {
                        _checkConnect();
                      } else if (_buttonLabels[index] == 'PRINT STATUS') {
                        _printStatus(context);
                      } else if (_buttonLabels[index] == 'SET BLUETOOTH') {
                        _setBluetooth();
                      } else if (_buttonLabels[index] == 'QUERY SN') {
                        _querySN(context);
                      } else if (_buttonLabels[index] == 'BITMAP MODEL') {
                        _bitmapModel();
                      } else if (_buttonLabels[index] == 'CASH DRAWER CHECK') {
                        _cashDrawerCheck(context);
                      } else if (_buttonLabels[index] == 'NV Download') {
                        _nvDownload();
                      } else if (_buttonLabels[index] == 'NV PRINT') {
                        _nvPrint();
                      }
                    },
                    child: Text(_buttonLabels[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

}


