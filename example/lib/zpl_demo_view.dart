import 'package:flutter/material.dart';
import 'package:flutter_printer_sdk/printer_test.dart';
import 'package:flutter_printer_sdk/printer_manager.dart';

class ZPLDemoView extends StatefulWidget {
  @override
  _ZPLDemoViewState createState() => _ZPLDemoViewState();
}

class _ZPLDemoViewState extends State<ZPLDemoView> {

  final PrinterManager _printerManager = PrinterManager();

  static void showToast(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 1000),
      content: Text(msg),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ZPL Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                print('PRINT TEXT button pressed');
                _printerManager.sendZPL(PrinterTest().printTextZPL());
              },
              child: Text('PRINT TEXT'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                print('CUSTOM FONTS button pressed');
                _printerManager.sendZPL(PrinterTest().printCustomFontsZPL());
              },
              child: Text('CUSTOM FONTS'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                print('PRINT SAMPLE button pressed');
                PrinterTest().printSampleZPL().then((value) {
                  _printerManager.sendZPL(value);
                });
              },
              child: Text('PRINT SAMPLE'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                print('PRINT Barcode1 button pressed');
                _printerManager.sendZPL(PrinterTest().printBarcode1ZPL());
              },
              child: Text('PRINT Barcode1'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                print('PRINT Barcode2 button pressed');
                _printerManager.sendZPL(PrinterTest().printBarcode2ZPL());
              },
              child: Text('PRINT Barcode2'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                print('PRINT Geometry button pressed');
                _printerManager.sendZPL(PrinterTest().printGeometryZPL());
              },
              child: Text('PRINT Geometry'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                print('PRINT IMAGE button pressed');
                PrinterTest().printImageZPL().then((value) {
                  _printerManager.sendZPL(value);
                });
              },
              child: Text('PRINT IMAGE'),
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
          ],
        ),
      ),
    );
  }
}
