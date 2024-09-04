import 'package:flutter/services.dart';

class ZPLConst {
  static const String ROTATION_0 = "N";
  static const String ROTATION_90 = "R";
  static const String ROTATION_180 = "I";
  static const String ROTATION_270 = "B";
  static const String FNT_A = 'A';
  static const String FNT_B = 'B';
  static const String FNT_C = 'C';
  static const String FNT_D = 'D';
  static const String FNT_E = 'E';
  static const String FNT_F = 'F';
  static const String FNT_G = 'G';
  static const String FNT_0 = '0';
  static const int CODE_PAGE_UTF8 = 28;
  static const int CODE_PAGE_UTF16 = 29;
  static const int CODE_PAGE_UTF16_2 = 30;
  static const int CODE_PAGE_USA1 = 0;
  static const int CODE_PAGE_USA2 = 1;
  static const int CODE_PAGE_UK = 2;
  static const int CODE_PAGE_NL = 3;
  static const int CODE_PAGE_DK = 4;
  static const int CODE_PAGE_SWEDE = 5;
  static const int CODE_PAGE_GER = 6;
  static const int CODE_PAGE_FR1 = 7;
  static const int CODE_PAGE_FR2 = 8;
  static const int CODE_PAGE_ITA = 9;
  static const int CODE_PAGE_ES = 10;
  static const int CODE_PAGE_JA = 12;
  static const String BCS_CODE11 = "^B1";
  static const String BCS_INTERLEAVED2OF5 = "^B2";
  static const String BCS_CODE39 = "^B3";
  static const String BCS_EAN8 = "^B8";
  static const String BCS_UPCE = "^B9";
  static const String BCS_CODE93 = "^BA";
  static const String BCS_CODE128 = "^BC";
  static const String BCS_EAN13 = "^BE";
  static const String BCS_CODABAR = "^BK";
  static const String BCS_MSI = "^BM";
  static const String BCS_PLESSEY = "^BP";
  static const String BCS_UPC_EAN = "^BS";
  static const String BCS_UPCA = "^BU";
  static const int HRI_TEXT_NONE = 0;
  static const int HRI_TEXT_ABOVE = 1;
  static const int HRI_TEXT_BELOW = 2;
  static const int STS_CONNECT = 1;
  static const int STS_DISCONNECT = 0;

  static const int Dithering= 0;
  static const int Threshold = 1;

  static const String StringEncoding_GB18030 = "GB18030";
  static const String StringEncoding_GB2312 = "GB2312";
  static const String StringEncoding_BIG5 = "BIG5";
  static const String StringEncoding_UTF8 = "UTF8";

}

class ZPLCommand {
  List<Map<String, dynamic>> _list = [];

  /// This method is used at the beginning of the label
  ///
  /// @return ZPLCommand Instance
  ZPLCommand addStart() {
    _list.add({'method': 'addStart'});
    return this;
  }

  /// End of label format. After calling this method, the label is printed.
  ///
  /// @return ZPLCommand Instance
  ZPLCommand addEnd() {
    _list.add({'method': 'addEnd'});
    return this;
  }

  /// text printing
  ///
  /// @param x the starting x value of the text
  /// @param y the starting y value of the text
  /// @param content the text content
  /// @param fontName The font type of the text, the default is FNT_F.
  /// @param rotation Clockwise rotation angle, default ROTATION_0
  /// @param sizeW The effective width of the text, the default is the base size. Please use an integer multiple of the base size.
  /// @param sizeH The effective height of the text. Default is base size. Please use an integer multiple of the base size
  /// @return ZPLCommand Instance
  ZPLCommand addText(int x, int y,String content,{String fontName = ZPLConst.FNT_F, String rotation = ZPLConst.ROTATION_0, int sizeW = 1, int sizeH = 1}) {
    _list.add({
      'method': 'addText',
      'params': {
        'x': x,
        'y': y,
        'fontName': fontName,
        'rotation': rotation,
        'sizeW': sizeW,
        'sizeH': sizeH,
        'content': content,
      }
    });
    return this;
  }

  /// Set custom font. After the machine is powered off, the settings will be invalid
  ///
  /// @param font Font name and suffix of font library, for example: LZHONGHEI.TTF
  /// @param alias Font alias, corresponding to fontName in addText. Range: A to Z and 0 to 9.
  /// @param codePage The code page to be used
  /// @return ZPLCommand Instance
  ZPLCommand setCustomFont(String font, String alias, int codePage) {
    _list.add({
      'method': 'setCustomFont',
      'params': {
        'font': font,
        'alias': alias,
        'codePage': codePage,
      }
    });
    return this;
  }

  /// Set Printer Width
  ///
  /// @param width label width (in dots)
  /// @return ZPLCommand Instance
  ZPLCommand setPrinterWidth(int width) {
    _list.add({
      'method': 'setPrinterWidth',
      'params': {'width': width},
    });
    return this;
  }

  /// This method sets the label length
  ///
  /// @param length label length(in dots)
  /// @return ZPLCommand Instance
  ZPLCommand setLabelLength(int length) {
    _list.add({
      'method': 'setLabelLength',
      'params': {'length': length},
    });
    return this;
  }

  /// Area Reverse
  ///
  /// @param x Start x value of the area
  /// @param y Start y value of the area
  /// @param width Area width
  /// @param height Area height
  /// @param radius degree of cornerrounding.Range: 0(no rounding) to 8 (heaviest rounding). Default is 0.
  /// @return ZPLCommand Instance
  ZPLCommand addReverse(int x, int y, int width, int height, {int radius = 0}) {
    _list.add({
      'method': 'addReverse',
      'params': {
        'x': x,
        'y': y,
        'width': width,
        'height': height,
        'radius': radius,
      }
    });
    return this;
  }

  /// The method is used to draw boxes and lines as part of a label format.
  ///
  /// @param x Start x value of the box
  /// @param y Start y value of the box
  /// @param width box width (in dots)
  /// @param height box height (in dots)
  /// @param thickness border thickness (in dots)
  /// @param radius degree of cornerrounding, Range: 0(no rounding) to 8 (heaviest rounding), Default is 0.
  /// @return ZPLCommand Instance
  ZPLCommand addBox(int x, int y, int width, int height, int thickness, {int radius = 0}) {
    _list.add({
      'method': 'addBox',
      'params': {
        'x': x,
        'y': y,
        'width': width,
        'height': height,
        'thickness': thickness,
        'radius': radius,
      }
    });
    return this;
  }

  /// The method is used to draw diagonals.
  ///
  /// @param x Horizontal starting position
  /// @param y Vertical starting position
  /// @param orientation The direction of the diagonal.
  /// @param width The width of the box (range: 1-32000, unit: dot).
  /// @param height The height of the box (range: 1-32000, unit: dot).
  /// @param thickness Boundary thickness (range: 1-32000, unit: dot).
  /// @return ZPLCommand Instance
  ZPLCommand addGraphicDiagonalLine(int x, int y, String orientation, int width, int height, int thickness) {
    _list.add({
      'method': 'addGraphicDiagonalLine',
      'params': {
        'x': x,
        'y': y,
        'orientation': orientation,
        'width': width,
        'height': height,
        'thickness': thickness,
      }
    });
    return this;
  }

  /// The method is used to draw a graphical ellipse.
  ///
  /// @param x Horizontal starting position
  /// @param y Vertical starting position
  /// @param width Ellipse width (range: 3-4095, unit: dot).
  /// @param height Ellipse height (range: 3-4095, unit: dot).
  /// @param thickness Boundary thickness (range: 2-4095, unit: dot).
  /// @return ZPLCommand Instance
  ZPLCommand addGraphicEllipse(int x, int y, int width, int height, int thickness) {
    _list.add({
      'method': 'addGraphicEllipse',
      'params': {
        'x': x,
        'y': y,
        'width': width,
        'height': height,
        'thickness': thickness,
      }
    });
    return this;
  }

  /// The method is used to command produces a circle on the printed label.
  ///
  /// @param x Horizontal starting position
  /// @param y Vertical starting position
  /// @param diameter Round diameter(range:3-4095,unit:dot).
  /// @param thickness Boundary thickness(range:1-4095,unit:dot).
  /// @return ZPLCommand Instance
  ZPLCommand addGraphicCircle(int x, int y, int diameter, int thickness) {
    _list.add({
      'method': 'addGraphicCircle',
      'params': {
        'x': x,
        'y': y,
        'diameter': diameter,
        'thickness': thickness,
      }
    });
    return this;
  }

  /// The method is used to prints 1D barcodes.
  ///
  /// @param x Start x value of the barcode
  /// @param y Start y value of the barcode
  /// @param codeType Code type
  /// @param data content
  /// @param ratio Barcode direction,Default is ROTATION_0
  /// @param textPosition Interpretation line position, Default is HRI_TEXT_BELOW.
  /// @param width module width (in dots),Default is 2.
  /// @param height bar code height (in dots), Default is 50.
  /// @return ZPLCommand Instance
  ZPLCommand addBarcode(int x, int y, String codeType,String data, {String ratio = ZPLConst.ROTATION_0, int textPosition = ZPLConst.HRI_TEXT_BELOW, int width = 2, int height = 50}) {
    _list.add({
      'method': 'addBarcode',
      'params': {
        'x': x,
        'y': y,
        'codeType': codeType,
        'ratio': ratio,
        'textPosition': textPosition,
        'data': data,
        'width': width,
        'height': height,
      }
    });
    return this;
  }

  /// Add 2D barcode
  ///
  /// @param x Start x value of the qrcode
  /// @param y Start y value of the qrcode
  /// @param data content
  /// @param size magnification factor. Values:1 to 10, default is 3.
  /// @return ZPLCommand Instance
  ZPLCommand addQRCode(int x, int y, String data,{int size = 3}) {
    _list.add({
      'method': 'addQRCode',
      'params': {
        'x': x,
        'y': y,
        'size': size,
        'data': data,
      }
    });
    return this;
  }

  /// Print pictures
  ///
  /// @param x Horizontal starting position
  /// @param y Vertical starting position
  /// @param bitmap Bitmap data as Uint8List
  /// @param width Print width of picture
  /// @return ZPLCommand Instance
  ZPLCommand printBitmap(int x, int y, Uint8List bitmap, int width) {
    _list.add({
      'method': 'printBitmap',
      'params': {
        'x': x,
        'y': y,
        'bitmap': bitmap,
        'width': width,
      }
    });
    return this;
  }

  ZPLCommand printBmpCompress(int x, int y, Uint8List bitmap, int width) {
    _list.add({
      'method': 'printBmpCompress',
      'params': {
        'x': x,
        'y': y,
        'bitmap': bitmap,
        'width': width,
      }
    });
    return this;
  }

  /// The method is used to downloads a graphic image.
  ///
  /// @param width Print width of picture
  /// @param bmpName image name and extension, The number or character whose name is 1 to 8.
  /// @param bitmap Bitmap data as Uint8List
  /// @return ZPLCommand Instance
  ZPLCommand downloadBitmap(int width, String bmpName, Uint8List bitmap) {
    _list.add({
      'method': 'downloadBitmap',
      'params': {
        'width': width,
        'bmpName': bmpName,
        'bitmap': bitmap,
      }
    });
    return this;
  }

  /// The method is used to print bitmap
  ///
  /// @param x Start x value of the bitmap
  /// @param y Start y value of the bitmap
  /// @param bmpName Bitmap name and extension name
  /// @param mx magnification factor on the x-axis,The default value is 1, and the range is 1~10.
  /// @param my magnification factor on the y-axis,The default value is 1, and the range is 1~10.
  /// @return ZPLCommand Instance
  ZPLCommand useDownloadBitmap(int x, int y, String bmpName, {int mx = 1, int my = 1}) {
    _list.add({
      'method': 'useDownloadBitmap',
      'params': {
        'x': x,
        'y': y,
        'bmpName': bmpName,
        'mx': mx,
        'my': my,
      }
    });
    return this;
  }

  /// The method controls the number of labels to print
  ///
  /// @param count total quantity of labels to print
  /// @return ZPLCommand Instance
  ZPLCommand addPrintCount(int count) {
    _list.add({
      'method': 'addPrintCount',
      'params': {'count': count},
    });
    return this;
  }

  /// TThis method is used to set the printing speed
  ///
  /// @param speed print speed. Unit is inches/sec
  /// @return ZPLCommand Instance
  ZPLCommand setPrintSpeed(int speed) {
    _list.add({
      'method': 'setPrintSpeed',
      'params': {'speed': speed},
    });
    return this;
  }

  /// The method inverts the label format 180 degrees.The label appears to be printed upside down
  ///
  /// @param orientation Print Orientation
  /// @return ZPLCommand Instance
  ZPLCommand setPrintOrientation(String orientation) {
    _list.add({
      'method': 'setPrintOrientation',
      'params': {'orientation': orientation},
    });
    return this;
  }

  /// The method is used to set the darkness of printing.
  ///
  /// @param density desired darkness(range: 0-30)
  /// @return ZPLCommand Instance
  ZPLCommand setPrintDensity(int density) {
    _list.add({
      'method': 'setPrintDensity',
      'params': {'density': density},
    });
    return this;
  }

  /// This method sets the character set
  ///
  /// @param charSet Character set (e.g., "UTF-8")
  /// @return ZPLCommand Instance
  ZPLCommand setCharSet(String charSet) {
    _list.add({
      'method': 'setCharSet',
      'params': {'charSet': charSet},
    });
    return this;
  }

  /// This method sends data to the printer
  ///
  /// @param data Data to be sent as Uint8List
  /// @return ZPLCommand Instance
  ZPLCommand sendData(Uint8List data) {
    _list.add({
      'method': 'sendData',
      'params': {
        'data': data,
      }
    });
    return this;
  }

  List<Map<String, dynamic>> getCommands() {
    return _list;
  }
}
