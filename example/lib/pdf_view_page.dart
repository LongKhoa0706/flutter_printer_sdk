import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:flutter_printer_sdk/printer_manager.dart';
import 'package:pdfx/pdfx.dart';
import 'package:internet_file/internet_file.dart';
import 'package:flutter_printer_sdk/pos_command.dart';
import 'package:flutter_printer_sdk/tspl_command.dart';
import 'package:flutter_printer_sdk/zpl_command.dart';

class PDFViewPage extends StatefulWidget {
  @override
  _PDFViewPageState createState() => _PDFViewPageState();
}

class _PDFViewPageState extends State<PDFViewPage> {

  String _selectedCommand = 'TSPL';

  final pdfController = PdfController(
    document: PdfDocument.openAsset('assets/label_test.pdf'),
  );

  @override
  void initState() {
    super.initState();
  }

  Future<void> _printPDF() async {
    final document = await PdfDocument.openAsset('assets/label_test.pdf');

    for (int i = 1; i <= document.pagesCount; i++) {
      final page = document.getPage(i);
      page.then((value) {
        final pageImage = value.render(width: 800, height: 1200).then((pdfPageImage) {
          final bytes = pdfPageImage!.bytes;

          if (_selectedCommand == 'TSPL') {
            final TSPLCommand command = TSPLCommand()
              ..sizeMm(76.0, 100.0)
              ..cls()
              ..bitmap(0, 0, TSPLConst.BMP_MODE_OVERWRITE, 384, bytes)
              ..print(count: 1);
            PrinterManager().sendTSPL(command.getCommands());
          } else if (_selectedCommand == 'TSPL(zlib)') {
            final TSPLCommand command = TSPLCommand()
              ..sizeMm(76.0, 100.0)
              ..cls()
              ..bitmapCompression(0, 0, TSPLConst.BMP_MODE_OVERWRITE_C, 384, bytes)
              ..print(count: 1);
            PrinterManager().sendTSPL(command.getCommands());
          } else if (_selectedCommand == 'ZPL') {
            final ZPLCommand command = ZPLCommand()
              ..addStart()
              ..printBitmap(0,50,bytes, 384)
              ..addEnd();
            PrinterManager().sendZPL(command.getCommands());
          } else if (_selectedCommand == 'POS') {
            final POSCommand command = POSCommand()
              ..initializePrinter()
              ..printBitmap(bytes, 800, alignment: POSConst.ALIGNMENT_CENTER)
              ..feedLine()
              ..cutHalfAndFeed(1);
            PrinterManager().sendESC(command.getCommands());
          }

        });
      });
    }
  }

  void _selectCommand(String command) {
    setState(() {
      _selectedCommand = command;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _selectCommand,
            itemBuilder: (BuildContext context) {
              return {'TSPL','TSPL(zlib)',  'ZPL', 'POS'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _selectedCommand,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.print),
            onPressed: _printPDF,
          ),
        ]
      ),
      body: PdfView(
        controller: pdfController,
      ),
    );
  }
}


