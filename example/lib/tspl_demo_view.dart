import 'package:flutter/material.dart';
import 'package:flutter_printer_sdk/printer_test.dart';
import 'package:flutter_printer_sdk/printer_manager.dart';
import 'dart:io';
class TSPLDemoView extends StatefulWidget {
  @override
  _TSPLDemoViewState createState() => _TSPLDemoViewState();
}

class _TSPLDemoViewState extends State<TSPLDemoView> {

  final PrinterManager _printerManager = PrinterManager();
  String _selectedEncoding = 'GB18030';
  String _selectedCodepage = 'UTF8';

  static void showToast(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 1000),
      content: Text(msg),
    ));
  }

  void _sendEncoding() {
    print('Selected encoding: $_selectedEncoding');
    _printerManager.sendTSPL(PrinterTest().printContentTSPLWithCharSet(_selectedEncoding));
  }

  void _sendCodePage() {
    print('Selected encoding: $_selectedCodepage');
    if (_selectedCodepage == 'UTF8') {
      _printerManager.setCodePage("UTF-8");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TSPL Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                print('PRINT CONTEXT button pressed');
                _printerManager.sendTSPL(PrinterTest().printContentTSPL());
              },
              child: Text('PRINT CONTEXT'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                print('PRINT TEXT button pressed');
                _printerManager.sendTSPL(PrinterTest().printTextTSPL());
              },
              child: Text('PRINT TEXT'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                print('PRINT BARCODE button pressed');
                _printerManager.sendTSPL(PrinterTest().printBarcodeTSPL());
              },
              child: Text('PRINT BARCODE'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                print('PRINT IMAGE button pressed');
                PrinterTest().printPicTSPL().then((value) {
                  _printerManager.sendTSPL(value);
                });
              },
              child: Text('PRINT IMAGE'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                print('PRINT COMPRESSION button pressed');
                PrinterTest().bitmapCompressionTSPL().then((value) {
                  _printerManager.sendTSPL(value);
                });
              },
              child: Text('PRINT COMPRESSION'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                print('PRINT STATUS button pressed');
                _printerManager.labelPrinterStatus(1000).then((value) {
                  switch (value) {
                    case 0:
                      showToast("normal", context);
                      break;
                    case 1:
                      showToast("Head opened", context);
                      break;
                    case 2:
                      showToast("Paper Jam", context);
                      break;
                    case 3:
                      showToast("Paper Jam and head opened", context);
                      break;
                    case 4:
                      showToast("Out of paper", context);
                      break;
                    case 5:
                      showToast("Out of paper and head opened", context);
                      break;
                    case 8:
                      showToast("Out of ribbon", context);
                      break;
                    case 9:
                      showToast("Out of ribbon and head opened", context);
                      break;
                    case 10:
                      showToast("Out of ribbon and paper jam", context);
                      break;
                    case 11:
                      showToast("Out of ribbon, paper jam and head opened", context);
                      break;
                    case 12:
                      showToast("Out of ribbon and out of paper", context);
                      break;
                    case 13:
                      showToast("Out of ribbon, out of paper and head opened", context);
                      break;
                    case 16:
                      showToast("Pause", context);
                      break;
                    case 32:
                      showToast("Printing", context);
                      break;
                    default:
                      showToast("Other error", context);
                      break;
                  }
                });
              },
              child: Text('PRINT STATUS'),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Text('Printer codepage'),
                SizedBox(width:20),
                DropdownButton<String>(
                  value: _selectedCodepage,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCodepage = newValue!;
                    });
                  },
                  items: <String>['UTF8']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _sendCodePage,
                  child: Text('Set'),
                ),
              ],
            ),
            Row(
              children: [
                Text('String encoding'),
                DropdownButton<String>(
                  value: _selectedEncoding,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedEncoding = newValue!;
                    });
                  },
                  items: (Platform.isIOS?<String>['GB18030', 'UTF8']:<String>['GB18030', 'UTF-8'])
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: _sendEncoding,
                  child: Text('TEST'),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
