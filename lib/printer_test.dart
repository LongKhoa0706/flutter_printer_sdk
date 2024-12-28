import 'package:flutter/services.dart';
import 'pos_command.dart';
import 'tspl_command.dart';
import 'zpl_command.dart';
import 'dart:async';
import 'dart:convert';

class PrinterTest {

  /// TSPL Demo
  List<Map<String, dynamic>> printContentTSPL() {
    TSPLCommand command = TSPLCommand();
    command.sizeMm(38.0, 21.0)
        .gapInch(0.0, 0.0)
        .offsetInch(0.0)
        .speed(5.0)
        .density(10)
        .direction(TSPLConst.DIRECTION_FORWARD)
        .reference(20, 0)
        .cls()
        .box(6, 6, 378, 229, 5)
        .box(16, 16, 360, 209, 5)
        .barcode(30, 30, TSPLConst.CODE_TYPE_93, 100, "ABCDEFGH", readable: TSPLConst.READABLE_LEFT, rotation: TSPLConst.ROTATION_0, narrow: 2, wide: 2)
        .qrcode(265, 30, 4, TSPLConst.ROTATION_0, "test qrcode", ecLevel: TSPLConst.EC_LEVEL_H, mode: TSPLConst.QRCODE_MODE_MANUAL)
        .text(200, 144, TSPLConst.FNT_16_24, "Test EN", rotation: TSPLConst.ROTATION_0, xRatio: 1, yRatio: 1)
        .text(38, 165, TSPLConst.FNT_16_24, "HELLO", rotation: TSPLConst.ROTATION_0, xRatio: 1, yRatio: 2)
        .bar(200, 183, 166, 30)
        .bar(334, 145, 30, 30)
        .print(count:1);
    return command.getCommands();
  }

  List<Map<String, dynamic>> printContentTSPLWithCharSet(String charSet) {
    TSPLCommand command = TSPLCommand();
    command.setCharSet(charSet)
        .sizeMm(38.0, 21.0)
        .gapInch(0.0, 0.0)
        .offsetInch(0.0)
        .speed(5.0)
        .density(10)
        .direction(TSPLConst.DIRECTION_FORWARD)
        .reference(20, 0)
        .cls()
        .box(6, 6, 378, 229, 5)
        .box(16, 16, 360, 209, 5)
        .barcode(30, 30, TSPLConst.CODE_TYPE_93, 100, "ABCDEFGH", readable: TSPLConst.READABLE_LEFT, rotation: TSPLConst.ROTATION_0, narrow: 2, wide: 2)
        .qrcode(265, 30, 4, TSPLConst.ROTATION_0, "test qrcode", ecLevel: TSPLConst.EC_LEVEL_H, mode: TSPLConst.QRCODE_MODE_MANUAL)
        .text(200, 144, TSPLConst.FNT_16_24, "Test EN", rotation: TSPLConst.ROTATION_0, xRatio: 1, yRatio: 1)
        .text(38, 165, "ARABIC.TTF", "مرحبًا", rotation: TSPLConst.ROTATION_0, xRatio: 8, yRatio: 8)
        .bar(200, 183, 166, 30)
        .bar(334, 145, 30, 30)
        .print(count:1);
    return command.getCommands();
  }

  List<Map<String, dynamic>> printTextTSPL() {
    TSPLCommand command = TSPLCommand();
    command.sizeMm(38.0, 21.0)
        .gapMm(0.0, 0.0)
        .density(12)
        .reference(0, 0)
        .direction(TSPLConst.DIRECTION_FORWARD)
        .cls()
        .sendData(Uint8List.fromList('send'.codeUnits))
        // .text(10, 60,TSPLConst.FNT_12_20, "FNT_12_20", xRatio:2, yRatio:2)
        // .text(10, 120,TSPLConst.FNT_16_24, "FNT_16_24", xRatio:2, yRatio:2)
        // .text(10, 180,TSPLConst.FNT_24_32, "FNT_24_32", xRatio:2, yRatio:2)
        // .text(10, 240,TSPLConst.FNT_32_48, "FNT_32_48", xRatio:2, yRatio:2)
        // .text(10, 300,TSPLConst.FNT_14_19, "FNT_14_19", xRatio:2, yRatio:2)
        // .text(10, 360,TSPLConst.FNT_14_25, "FNT_14_25", xRatio:2, yRatio:2)
        // .text(10, 400,TSPLConst.FNT_21_27, "FNT_21_27", xRatio:2, yRatio:2)
        .print();
    return command.getCommands();
  }

  List<Map<String, dynamic>> printBarcodeTSPL() {
    TSPLCommand command = TSPLCommand();
    command.sizeMm(38.0, 21.0)
        .gapMm(0.0, 2.0)
        .cls()
        .barcode(60, 50, TSPLConst.CODE_TYPE_128, 108, "abcdef12345")
        .print();
    return command.getCommands();
  }

  Future<List<Map<String, dynamic>>> printPicTSPL(Uint8List fileUnit8List) async{
    TSPLCommand command = TSPLCommand();

    command.sizeMm(38.0, 21.0)
        // .density(10).
      // .offsetMm(15)
        .gapMm(3.0, 10.0)
        .density(10)
        .reference(25, 0)
        .direction(TSPLConst.DIRECTION_FORWARD)
        .cls()
        .bitmap(10, 5, TSPLConst.BMP_MODE_OVERWRITE, 300, fileUnit8List)
        .print(count: 1);
    return command.getCommands();
  }

  Future<List<Map<String, dynamic>>> bitmapCompressionTSPL() async{
    TSPLCommand command = TSPLCommand();
    final ByteData data = await rootBundle.load("assets/images/nv_test.bmp");
    Uint8List fileUnit8List = data.buffer
        .asUint8List(data.offsetInBytes, data.lengthInBytes);
    command.sizeMm(76.0, 40.0)
        .gapMm(2.0, 0.0)
        .cls()
        .bitmapCompression(0, 0, TSPLConst.BMP_MODE_OVERWRITE_C, 240, fileUnit8List)
        .print(count: 1);
    return command.getCommands();
  }

  /// POS Demo
  List<Map<String, dynamic>> printTextPOS() {
    POSCommand command = POSCommand();
    command.initializePrinter()
        .printString("Welcome to the printer,this is print test content!\n")
        .sendData(Uint8List.fromList('printText Demo\n'.codeUnits))
        .printText(
        "Width 1 Height 1\n",
        alignment:POSConst.ALIGNMENT_CENTER,
        attribute:POSConst.FNT_BOLD | POSConst.FNT_UNDERLINE,
        textSize:POSConst.TXT_1WIDTH | POSConst.TXT_1HEIGHT)
        .printText(
        "Width 2 Height 2\n",
        alignment:POSConst.ALIGNMENT_CENTER,
        attribute:POSConst.FNT_BOLD | POSConst.FNT_UNDERLINE,
        textSize:POSConst.TXT_2WIDTH | POSConst.TXT_2HEIGHT)
        .printText(
        "Width 3 Height 3\n",
        alignment:POSConst.ALIGNMENT_CENTER,
        attribute:POSConst.FNT_BOLD | POSConst.FNT_UNDERLINE,
        textSize:POSConst.TXT_3WIDTH | POSConst.TXT_3HEIGHT)
        .cutHalfAndFeed(1);
    return command.getCommands();
  }

  List<Map<String, dynamic>> printContentPOSWithCharSet(String charSet) {
    POSCommand command = POSCommand();
    command.initializePrinter()
        .setCharSet(charSet)
        .printString("مرحبًا")
        .printString("\n")
        .printText(
        "printText Demo\n",
        alignment:POSConst.ALIGNMENT_CENTER,
        attribute:POSConst.FNT_BOLD | POSConst.FNT_UNDERLINE,
        textSize:POSConst.TXT_1WIDTH | POSConst.TXT_2HEIGHT)
        .cutHalfAndFeed(1);
    return command.getCommands();
  }

  List<Map<String, dynamic>> printBarcodePOS() {
    POSCommand command = POSCommand();
    command.initializePrinter()
        .printString("UPC-A\n")
        .printBarCode("123456789012", POSConst.BCS_UPCA)
        .printString("UPC-E\n")
        .printBarCode('042100005264', POSConst.BCS_UPCE, width: 2, height: 70, alignment: POSConst.ALIGNMENT_LEFT)
        .printString("JAN8\n")
        .printBarCode('12345678', POSConst.BCS_JAN8, width: 2, height: 70, alignment: POSConst.ALIGNMENT_CENTER)
        .printString("JAN13\n")
        .printBarCode('123456791234', POSConst.BCS_JAN13, width: 2, height: 70, alignment: POSConst.ALIGNMENT_RIGHT)
        .printString("CODE39\n")
        .printBarCode('ABCDEFGHI', POSConst.BCS_Code39, width: 2, height: 70, alignment: POSConst.ALIGNMENT_CENTER, textPosition: POSConst.HRI_TEXT_BOTH)
        .printString("ITF\n")
        .printBarCode('123456789012', POSConst.BCS_ITF, height: 70)
        .printString("CODABAR\n")
        .printBarCode('A37859B', POSConst.BCS_Codabar, height: 70)
        .printString("CODE93\n")
        .printBarCode('123456789', POSConst.BCS_Code93, height: 70)
        .printString("CODE128\n")
        .printBarCode('No.123456', POSConst.BCS_Code128, width: 2, height: 70, alignment: POSConst.ALIGNMENT_LEFT)
        .feedLine()
        .cutHalfAndFeed(1);
    return command.getCommands();
  }

  List<Map<String, dynamic>> printQRCodePOS() {
    POSCommand command = POSCommand();
    command.initializePrinter()
        .printQRCode("Welcome to Printer Technology to create advantages Quality to win in the future")
        .feedLine()
        .cutHalfAndFeed(1);
    return command.getCommands();
  }

  Future<List<Map<String, dynamic>>> printPicPOS() async {
    final ByteData data = await rootBundle.load("assets/images/nv_test.bmp");
    Uint8List fileUnit8List = data.buffer
        .asUint8List(data.offsetInBytes, data.lengthInBytes);
    final String base64Image = base64Encode(data.buffer.asUint8List());

    final POSCommand command = POSCommand()
      ..initializePrinter()
      //..printBase64Bitmap(base64Image,384, alignment: POSConst.ALIGNMENT_CENTER)
      ..printBitmap(fileUnit8List, 384, alignment: POSConst.ALIGNMENT_CENTER)
      ..feedLine()
      ..cutHalfAndFeed(1);
    return command.getCommands();
  }

  Future<List<Map<String, dynamic>>> printCustomImage(Uint8List fileUnit8List ) async {
    // final String base64Image = base64Encode(data.buffer.asUint8List());

    final POSCommand command = POSCommand()
      ..initializePrinter()
    //..printBase64Bitmap(base64Image,384, alignment: POSConst.ALIGNMENT_CENTER)
      ..printBitmap(fileUnit8List, 500, alignment: POSConst.ALIGNMENT_CENTER)
      ..feedLine()
      ..cutHalfAndFeed(1);
    return command.getCommands();
  }


  Future<List<Map<String, dynamic>>> selectBitmapModel() async {
    final ByteData data = await rootBundle.load("assets/images/nv_test.bmp");
    Uint8List fileUnit8List = data.buffer
        .asUint8List(data.offsetInBytes, data.lengthInBytes);
    final POSCommand command = POSCommand()
      ..selectBitmapModel(POSConst.SINGLE_DENSITY_8, 100, fileUnit8List);
    return command.getCommands();
  }

  Future<List<Map<String, dynamic>>> nvDownloadPOS() async {
    final ByteData data1 = await rootBundle.load("assets/images/nv_test.bmp");
    Uint8List fileUnit8List1 = data1.buffer
        .asUint8List(data1.offsetInBytes, data1.lengthInBytes);
    final ByteData data2 = await rootBundle.load("assets/images/image.png");
    Uint8List fileUnit8List2 = data2.buffer
        .asUint8List(data2.offsetInBytes, data2.lengthInBytes);
    final POSCommand command = POSCommand()
      ..downloadNVImages([fileUnit8List1,fileUnit8List2], 240);
    return command.getCommands();
  }

  List<Map<String, dynamic>> nvPrintPOS() {
    final POSCommand command = POSCommand()
      ..initializePrinter()
      ..printNVImage(1, POSConst.BMP_NORMAL)
      ..printNVImage(2, POSConst.BMP_NORMAL)
      ..feedLine()
      ..cutHalfAndFeed(1);
    return command.getCommands();
  }

  /// ZPL Demo
  List<Map<String, dynamic>> printTextZPL() {
    final ZPLCommand command = ZPLCommand()
      ..addStart()
      ..setLabelLength(400)
      ..addText(10, 0, "fontA", fontName: ZPLConst.FNT_A, rotation: ZPLConst.ROTATION_0, sizeW: 9, sizeH: 5)
      ..addText(10, 20, "fontB", fontName: ZPLConst.FNT_B, rotation: ZPLConst.ROTATION_0, sizeW: 11, sizeH: 7)
      ..addText(10, 40, "fontC", fontName: ZPLConst.FNT_C, rotation: ZPLConst.ROTATION_0, sizeW: 18, sizeH: 10)
      ..addText(10, 60, "fontD", fontName: ZPLConst.FNT_D, rotation: ZPLConst.ROTATION_0, sizeW: 18, sizeH: 10)
      ..addText(10, 90, "fontF", fontName: ZPLConst.FNT_F, rotation: ZPLConst.ROTATION_0, sizeW: 26, sizeH: 13)
      ..addText(10, 130, "fontE")
      ..addText(10, 160, "fontG", fontName: ZPLConst.FNT_G, rotation: ZPLConst.ROTATION_0, sizeW: 60, sizeH: 40)
      ..addText(10, 220, "font0", fontName: ZPLConst.FNT_0, rotation: ZPLConst.ROTATION_0, sizeW: 15, sizeH: 12)
      ..addText(350, 250, "E0", fontName: ZPLConst.FNT_E, rotation: ZPLConst.ROTATION_0, sizeW: 28, sizeH: 15)
      ..addText(250, 250, "E90", fontName: ZPLConst.FNT_E, rotation: ZPLConst.ROTATION_90, sizeW: 28, sizeH: 15)
      ..addText(250, 350, "E180", fontName: ZPLConst.FNT_E, rotation: ZPLConst.ROTATION_180, sizeW: 28, sizeH: 15)
      ..addText(350, 350, "E270", fontName: ZPLConst.FNT_E, rotation: ZPLConst.ROTATION_270, sizeW: 28, sizeH: 15)
      ..addEnd();
    return command.getCommands();
  }


  List<Map<String, dynamic>> printCustomFontsZPL() {
    final ZPLCommand command = ZPLCommand()
      ..setCharSet("UTF-8")
      ..addStart()
      ..setCustomFont("LZHONGHEI.TTF", '1', ZPLConst.CODE_PAGE_UTF8)
      ..addText(0, 0, "custom Font", fontName: '1', sizeW: 24, sizeH: 24)
      ..addText(100, 100, "customFont 90", fontName: '1', rotation: ZPLConst.ROTATION_90, sizeW: 24, sizeH: 24)
      ..addEnd();
    return command.getCommands();
  }

  List<Map<String, dynamic>> printBarcode1ZPL() {
    final ZPLCommand command = ZPLCommand()
      ..addStart()
      ..setPrinterWidth(500)
      ..addText(0, 0, "Code11")
      ..addBarcode(0, 30, ZPLConst.BCS_CODE11, "123456", ratio: ZPLConst.ROTATION_0, textPosition: ZPLConst.HRI_TEXT_BELOW, width: 2, height: 50)
      ..addText(0, 120, "BarCode25", fontName: ZPLConst.FNT_D)
      ..addBarcode(0, 150, ZPLConst.BCS_INTERLEAVED2OF5, "123456", ratio: ZPLConst.ROTATION_0, textPosition: ZPLConst.HRI_TEXT_BELOW, width: 2, height: 50)
      ..addText(0, 240, "Code39")
      ..addBarcode(0, 270, ZPLConst.BCS_CODE39, "123ABC", ratio: ZPLConst.ROTATION_0, textPosition: ZPLConst.HRI_TEXT_BELOW, width: 2, height: 50)
      ..addText(0, 360, "EAN8")
      ..addBarcode(0, 390, ZPLConst.BCS_EAN8, "1234567", ratio: ZPLConst.ROTATION_0, textPosition: ZPLConst.HRI_TEXT_BELOW, width: 2, height: 50)
      ..addText(260, 0, "code128")
      ..addBarcode(260, 30, ZPLConst.BCS_CODE128, "123456", ratio: ZPLConst.ROTATION_0, textPosition: ZPLConst.HRI_TEXT_BELOW, width: 2, height: 50)
      ..addText(240, 120, "CODE93")
      ..addBarcode(200, 150, ZPLConst.BCS_CODE93, "12345ABCDE", ratio: ZPLConst.ROTATION_0, textPosition: ZPLConst.HRI_TEXT_BELOW, width: 2, height: 50)
      ..addText(300, 240, "UPCE")
      ..addBarcode(300, 270, ZPLConst.BCS_UPCE, "1230000045", ratio: ZPLConst.ROTATION_0, textPosition: ZPLConst.HRI_TEXT_BELOW, width: 2, height: 50)
      ..addText(250, 360, "EAN13")
      ..addBarcode(250, 390, ZPLConst.BCS_EAN13, "12345678", ratio: ZPLConst.ROTATION_0, textPosition: ZPLConst.HRI_TEXT_BELOW, width: 2, height: 50)
      ..addEnd();
    return command.getCommands();
  }

  List<Map<String, dynamic>> printBarcode2ZPL() {
    final ZPLCommand command = ZPLCommand()
      ..addStart()
      ..addText(0, 0, "CODABAR")
      ..addBarcode(0, 30, ZPLConst.BCS_CODABAR, "A123456D", ratio: ZPLConst.ROTATION_0, textPosition: ZPLConst.HRI_TEXT_BELOW, width: 2, height: 50)
      ..addText(0, 120, "MSI")
      ..addBarcode(0, 150, ZPLConst.BCS_MSI, "123456", ratio: ZPLConst.ROTATION_0, textPosition: ZPLConst.HRI_TEXT_BELOW, width: 2, height: 50)
      ..addText(0, 240, "PLESSEY")
      ..addBarcode(0, 270, ZPLConst.BCS_PLESSEY, "12345", ratio: ZPLConst.ROTATION_0, textPosition: ZPLConst.HRI_TEXT_BELOW, width: 2, height: 50)
      ..addText(0, 360, "UPCA")
      ..addBarcode(0, 390, ZPLConst.BCS_UPCA, "07000002198", ratio: ZPLConst.ROTATION_0, textPosition: ZPLConst.HRI_TEXT_BELOW, width: 2, height: 50)
      ..addEnd();
    return command.getCommands();
  }

  Future<List<Map<String, dynamic>>> printSampleZPL() async {

    final ByteData data = await rootBundle.load("assets/images/nv_test.bmp");
    Uint8List fileUnit8List = data.buffer
        .asUint8List(data.offsetInBytes, data.lengthInBytes);

    final ZPLCommand command = ZPLCommand()
      ..addStart()
      ..addBox(10, 10, 378, 239, 5)
      ..addBox(20, 20, 360, 219, 5)
      ..addQRCode(30, 30, "https://www.google.com/")
      ..addText(40, 130, "Reverse")
      ..addReverse(32, 122, 150, 40, radius:2)
      ..downloadBitmap(110, "SAMPLE.GRF", fileUnit8List)
      ..useDownloadBitmap(180, 30, "SAMPLE.GRF")
      ..addBox(30, 180, 330, 2, 2)
      ..addText(40, 190, "Hello World")
      ..addPrintCount(2)
      ..addEnd();
    return command.getCommands();
  }

  Future<List<Map<String, dynamic>>> printImageZPL() async {
    final ByteData data = await rootBundle.load("assets/images/nv_test.bmp");
    Uint8List fileUnit8List = data.buffer
        .asUint8List(data.offsetInBytes, data.lengthInBytes);

    final ZPLCommand command = ZPLCommand()
      ..addStart()
      ..printBitmap(0,50,fileUnit8List, 384)
      ..addEnd();
    return command.getCommands();
  }

  List<Map<String, dynamic>> printGeometryZPL() {
    final ZPLCommand command = ZPLCommand()
      ..addStart()
      ..addBox(100, 100, 200, 150, 10)
      ..addGraphicDiagonalLine(50, 50, 'R', 400, 200, 5)
      ..addGraphicDiagonalLine(50, 50, 'L', 400, 200, 5)
      ..addGraphicEllipse(150, 150, 200, 100, 2)
      ..addGraphicCircle(150, 150, 200, 1)
      ..addEnd();
    return command.getCommands();
  }

}
