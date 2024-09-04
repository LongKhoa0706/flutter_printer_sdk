import 'package:flutter/services.dart';

class POSConst {
  static const int ALIGNMENT_LEFT = 0;
  static const int ALIGNMENT_CENTER = 1;
  static const int ALIGNMENT_RIGHT = 2;
  static const int FNT_DEFAULT = 0;
  static const int FNT_FONTB = 1;
  static const int FNT_BOLD = 8;
  static const int FNT_REVERSE = 16;
  static const int FNT_UNDERLINE = 128;
  static const int FNT_UNDERLINE2 = 256;
  static const int TXT_1WIDTH = 0;
  static const int TXT_2WIDTH = 16;
  static const int TXT_3WIDTH = 32;
  static const int TXT_4WIDTH = 48;
  static const int TXT_5WIDTH = 64;
  static const int TXT_6WIDTH = 80;
  static const int TXT_7WIDTH = 96;
  static const int TXT_8WIDTH = 112;
  static const int TXT_1HEIGHT = 0;
  static const int TXT_2HEIGHT = 1;
  static const int TXT_3HEIGHT = 2;
  static const int TXT_4HEIGHT = 3;
  static const int TXT_5HEIGHT = 4;
  static const int TXT_6HEIGHT = 5;
  static const int TXT_7HEIGHT = 6;
  static const int TXT_8HEIGHT = 7;
  static const int BMP_NORMAL = 0;
  static const int BMP_WIDTH_DOUBLE = 1;
  static const int BMP_HEIGHT_DOUBLE = 2;
  static const int BMP_WIDTH_HEIGHT_DOUBLE = 3;
  static const int BCS_UPCA = 65;
  static const int BCS_UPCE = 66;
  static const int BCS_EAN8 = 68;
  static const int BCS_EAN13 = 67;
  static const int BCS_JAN8 = 68;
  static const int BCS_JAN13 = 67;
  static const int BCS_ITF = 70;
  static const int BCS_Codabar = 71;
  static const int BCS_Code39 = 69;
  static const int BCS_Code93 = 72;
  static const int BCS_Code128 = 73;
  static const int HRI_TEXT_NONE = 0;
  static const int HRI_TEXT_ABOVE = 1;
  static const int HRI_TEXT_BELOW = 2;
  static const int HRI_TEXT_BOTH = 3;
  static const int QRCODE_EC_LEVEL_L = 48;
  static const int QRCODE_EC_LEVEL_M = 49;
  static const int QRCODE_EC_LEVEL_Q = 50;
  static const int QRCODE_EC_LEVEL_H = 51;
  static const int CUT_ALL = 0;
  static const int CUT_HALF = 1;
  static const int DEVICE_58 = 1;
  static const int DEVICE_80 = 2;
  static const int DEVICE_76 = 3;
  static const int PIN_TWO = 0;
  static const int PIN_FIVE = 1;
  static const int STS_UNKNOWN = -1;
  static const int STS_NORMAL = 0;
  static const int STS_COVEROPEN = 16;
  static const int STS_PRESS_FEED = 8;
  static const int STS_PAPEREMPTY = 32;
  static const int STS_COVEROPEN_PAPEREMPTY = 36;
  static const int STS_PRINTER_ERR = 64;
  static const int STS_CASH_OPEN = 0;
  static const int STS_CASH_CLOSE = 1;
  static const int STS_TYPE_PRINT = 1;
  static const int STS_TYPE_OFFLINE = 2;
  static const int STS_TYPE_ERR = 3;
  static const int STS_TYPE_PAPER = 4;
  static const int CONNECT_SUCCESS = 1;
  static const int CONNECT_FAIL = 2;
  static const int SEND_FAIL = 3;
  static const int CONNECT_INTERRUPT = 4;
  static const int USB_ATTACHED = 5;
  static const int USB_DETACHED = 6;
  static const int BLUETOOTH_INTERRUPT = 7;
  static const int DIRECTION_LEFT_TOP = 0;
  static const int DIRECTION_LEFT_BOTTOM = 1;
  static const int DIRECTION_RIGHT_BOTTOM = 2;
  static const int DIRECTION_RIGHT_TOP = 3;
  static const int SINGLE_DENSITY_8 = 0;
  static const int DOUBLE_DENSITY_8 = 1;
  static const int SINGLE_DENSITY_24 = 32;
  static const int DOUBLE_DENSITY_24 = 33;
  static const int SPACE_DEFAULT = -1;
  static const int CODE_PAGE_PC437 = 0;
  static const int CODE_PAGE_KATAKANA = 1;
  static const int CODE_PAGE_PC850 = 2;
  static const int CODE_PAGE_PC860 = 3;
  static const int CODE_PAGE_PC863 = 4;
  static const int CODE_PAGE_PC865 = 5;
  static const int CODE_PAGE_WEST_EUROPE = 6;
  static const int CODE_PAGE_GREEK = 7;
  static const int CODE_PAGE_HEBREW = 8;
  static const int CODE_PAGE_EAST_EUROPE = 9;
  static const int CODE_PAGE_IRAN = 10;
  static const int CODE_PAGE_WPC1252 = 16;
  static const int CODE_PAGE_PC866 = 17;
  static const int CODE_PAGE_PC852 = 18;
  static const int CODE_PAGE_PC858 = 19;
  static const int FONT_STANDARD = 0;
  static const int FONT_COMPRESS = 1;
  static const int STS_CONNECT = 1;
  static const int STS_DISCONNECT = 0;
}

class POSCommand {
  List<Map<String, dynamic>> _list = [];

  /// This function is used for text-printing
  ///
  /// @param text Printed text string
  /// @return POSCommand Instance
  POSCommand printString(String text) {
    _list.add({
      'method': 'printString',
      'params': {
        'text': text,
      }
    });
    return this;
  }

  /// This function is used for format-specific text printing
  ///
  /// @param text  Printed text string
  /// @param alignment The alignment of the text, and the default is ALIGNMENT_LEFT
  /// @param attribute This value is text attributes. It sets text attributes to print. default is FNT_DEFAULT
  /// @param textSize The font size of the printed text font,default is TXT_1WIDTH|TXT_1HEIGHT
  /// @return POSCommand Instance
  POSCommand printText(String text, {int alignment = POSConst.ALIGNMENT_LEFT, int attribute = POSConst.FNT_DEFAULT, int textSize = POSConst.TXT_1WIDTH | POSConst.TXT_1HEIGHT}) {
    _list.add({
      'method': 'printText',
      'params': {
        'text': text,
        'alignment': alignment,
        'attribute': attribute,
        'textSize': textSize,
      }
    });
    return this;
  }

  /// This function is used for printing image files
  ///
  /// @param bitmap base64 string bmp
  /// @param width Print the picture width
  /// @param alignment The alignment mode of the pictures
  /// @param mode
  /// @return POSCommand Instance
  POSCommand printBase64Bitmap(String bitmap,int width, {int alignment = POSConst.ALIGNMENT_LEFT,int mode = POSConst.BMP_NORMAL}) {
    _list.add({
      'method': 'printBase64Bitmap',
      'params': {
        'bitmap': bitmap,
        'alignment': alignment,
        'width': width,
        'mode': mode,
      }
    });
    return this;
  }

  /// This function is used for printing image files
  ///
  /// @param bitmap Uint8List type bmp
  /// @param width Print the picture width
  /// @param alignment The alignment mode of the pictures
  /// @param mode
  /// @return POSCommand Instance
  POSCommand printBitmap(Uint8List bitmap,int width, {int alignment = POSConst.ALIGNMENT_LEFT,int mode = POSConst.BMP_NORMAL}) {
    _list.add({
      'method': 'printBitmap',
      'params': {
        'bitmap': bitmap,
        'alignment': alignment,
        'width': width,
        'mode': mode,
      }
    });
    return this;
  }

  /// This function is used for supporting barcode printing
  ///
  /// @param data Barcode string to be printed
  /// @param codeType Barcode type
  /// @param width This values barcode width in Dot Units, range [2, 6], Default is 3
  /// @param height Barcode height, range [1,255].Default is 162
  /// @param alignment It sets barcode alignment, Default is ALIGNMENT_CENTER
  /// @param textPosition This value is printing position of barcode HRI letters(barcode data).Default is HRI_TEXT_BELOW
  /// @return POSCommand Instance
  POSCommand printBarCode(String data, int codeType, {int width = 3, int height = 162, int alignment = POSConst.ALIGNMENT_LEFT, int textPosition = POSConst.HRI_TEXT_BELOW}) {
    _list.add({
      'method': 'printBarCode',
      'params': {
        'data': data,
        'codeType': codeType,
        'width': width,
        'height': height,
        'alignment': alignment,
        'textPosition': textPosition,
      }
    });
    return this;
  }

  /// This function is used for sending feeding command to printer.
  ///
  /// @param lineCount This value is the number of lines for line feeding. Default is 1
  /// @return POSCommand Instance
  POSCommand feedLine({int lineCount = 1}) {
    _list.add({
      'method': 'feedLine',
      'params': {
        'lineCount': lineCount,
      }
    });
    return this;
  }

  /// This function is used for supporting QRCode barcode printing.
  ///
  /// @param content QRCode data to print
  /// @param moduleSize Module size. Range[1, 16], Default is 8
  /// @param ecLevel Error Correction Level, Default is QRCODE_EC_LEVEL_L
  /// @param alignment It sets QRCode alignment, Default is ALIGNMENT_CENTER
  /// @return POSCommand Instance
  POSCommand printQRCode(String content,{int moduleSize = 8, int ecLevel = POSConst.QRCODE_EC_LEVEL_L, int alignment = POSConst.ALIGNMENT_CENTER}) {
    _list.add({
      'method': 'printQRCode',
      'params': {
        'content': content,
        'moduleSize': moduleSize,
        'ecLevel': ecLevel,
        'alignment': alignment,
      }
    });
    return this;
  }

  /// This method is used for cutting the paper
  ///
  /// @param model Cut paper mode, Default is CUT_HALF.
  /// @return POSCommand Instance
  POSCommand cutPaper({int model = POSConst.CUT_HALF}) {
    _list.add({
      'method': 'cutPaper',
      'params': {
        'model': model,
      }
    });
    return this;
  }

  /// This method is used for cutting the paper
  ///
  /// @param distance Feed distance
  /// @return POSCommand Instance
  POSCommand cutHalfAndFeed(int distance) {
    _list.add({
      'method': 'cutHalfAndFeed',
      'params': {
        'distance': distance,
      }
    });
    return this;
  }

  /// Open a cash drawer
  ///
  /// @param pinNum Pin number to generate pulse
  /// @param onTime Start tiime to generate pulse. onTime*2ms, range [0,255], Default is 30
  /// @param offTime Stop time to generate pulse. offTime*2ms, range [0,255], Default is 255
  /// @return POSCommand Instance
  POSCommand openCashBox(int pinNum, {int onTime = 30, int offTime = 255}) {
    var params = {
      'pinNum': pinNum,
    };
    if (onTime != null && offTime != null) {
      params['onTime'] = onTime;
      params['offTime'] = offTime;
    }
    _list.add({
      'method': 'openCashBox',
      'params': params,
    });
    return this;
  }

  /// Set character encoding,Default is “gbk”
  ///
  /// @param charSet Character set name
  /// @return POSCommand Instance
  POSCommand setCharSet(String charSet) {
    _list.add({
      'method': 'setCharSet',
      'params': {
        'charSet': charSet,
      }
    });
    return this;
  }

  /// This function is used for set the font style
  ///
  /// @param attribute This value is text attributes. It sets text attributes to print. default is FNT_DEFAULT
  /// @param textSize The font size of the printed text font,default is TXT_1WIDTH|TXT_1HEIGHT
  /// @return POSCommand Instance
  POSCommand setTextStyle(int attribute, int textSize) {
    _list.add({
      'method': 'setTextStyle',
      'params': {
        'attribute': attribute,
        'textSize': textSize,
      }
    });
    return this;
  }

  /// This method is used for set up the alignment of the text
  ///
  /// @param alignment The alignment of the text, and the default is ALIGNMENT_LEFT
  /// @return POSCommand Instance
  POSCommand setAlignment(int alignment) {
    _list.add({
      'method': 'setAlignment',
      'params': {
        'alignment': alignment,
      }
    });
    return this;
  }

  /// Set up the print area in page mode
  ///
  /// @param width Width of printing area
  /// @param height Height of printing area
  /// @param x The x-coordinate of the starting position,Default is 0
  /// @param y The y-coordinate of the starting position,Default is 0.
  /// @return POSCommand Instance
  POSCommand setPrintArea(int width, int height, {int x = 0, int y = 0}) {
    var params = {
      'width': width,
      'height': height,
    };
    if (x != null && y != null) {
      params['x'] = x;
      params['y'] = y;
    }
    _list.add({
      'method': 'setPrintArea',
      'params': params,
    });
    return this;
  }

  /// Change to page mode or standard mode
  ///
  /// @param isOpen Enable or Disable page mode. (TRUE, FALSE)
  /// @return POSCommand Instance
  POSCommand setPageModel(bool isOpen) {
    _list.add({
      'method': 'setPageModel',
      'params': {
        'isOpen': isOpen,
      }
    });
    return this;
  }

  /// Print and return to standard mode in page mode.
  ///
  /// @return POSCommand Instance
  POSCommand printPageModelData() {
    _list.add({
      'method': 'printPageModelData',
    });
    return this;
  }

  /// Select print direction in page mode.
  ///
  /// @param direction Print direction
  /// @return POSCommand Instance
  POSCommand setPrintDirection(int direction) {
    _list.add({
      'method': 'setPrintDirection',
      'params': {
        'direction': direction,
      }
    });
    return this;
  }

  /// Set absolute horizontal print position . (X axis)
  ///
  /// @param position Starting position.
  /// @return POSCommand Instance
  POSCommand setAbsoluteHorizontal(int position) {
    _list.add({
      'method': 'setAbsoluteHorizontal',
      'params': {
        'position': position,
      }
    });
    return this;
  }

  /// Set relative horizontal print position. (X axis)
  ///
  /// @param position Starting position.
  /// @return POSCommand Instance
  POSCommand setRelativeHorizontal(int position) {
    _list.add({
      'method': 'setRelativeHorizontal',
      'params': {
        'position': position,
      }
    });
    return this;
  }

  /// Set absolute vertical print position in page mode. (Y axis)
  ///
  /// @param position Starting position
  /// @return POSCommand Instance
  POSCommand setAbsoluteVertical(int position) {
    _list.add({
      'method': 'setAbsoluteVertical',
      'params': {
        'position': position,
      }
    });
    return this;
  }

  /// Set relative vertical print position in page mode. (Y axis)
  ///
  /// @param position Starting position
  /// @return POSCommand Instance
  POSCommand setRelativeVertical(int position) {
    _list.add({
      'method': 'setRelativeVertical',
      'params': {
        'position': position,
      }
    });
    return this;
  }

  /// This function is used for save the NV images in flash
  ///
  /// @param bitmaps The bitmap list
  /// @param imageWidth This value is image width.
  /// @return POSCommand Instance
  POSCommand downloadNVImages(List<Uint8List> bitmaps, int imageWidth) {
    _list.add({
      'method': 'downloadNVImage',
      'params': {
        'bitmaps': bitmaps,
        'imageWidth': imageWidth,
      }
    });
    return this;
  }

  /// This function is used to support the Bitmap Image printing stored in Flash Memory.
  ///
  /// @param index It sets the index image stored in Flash Memory to print,range[1,255]
  /// @param model Print model
  /// @return POSCommand Instance
  POSCommand printNVImage(int index, int model) {
    _list.add({
      'method': 'printNVImage',
      'params': {
        'index': index,
        'model': model,
      }
    });
    return this;
  }

  /// Initialize Printer, This function clears the print buffer data.
  ///
  /// @return POSCommand Instance
  POSCommand initializePrinter() {
    _list.add({
      'method': 'initializePrinter',
    });
    return this;
  }

  /// Select bitmap model
  ///
  /// @param model Bitmap model
  /// @param width Print the picture width.
  /// @param bitmap Uint8List type Bitmap
  /// @return POSCommand Instance
  POSCommand selectBitmapModel(int model, int width, Uint8List bitmap) {
    _list.add({
      'method': 'selectBitmapModel',
      'params': {
        'model': model,
        'width': width,
        'bitmap': bitmap,
      }
    });
    return this;
  }

  /// Print buffer data and run n points
  ///
  /// @param The paper distance, in horizontal or vertical moving units. The default is point
  /// @return POSCommand Instance
  POSCommand feedDot(int n) {
    _list.add({
      'method': 'feedDot',
      'params': {
        'n': n,
      }
    });
    return this;
  }

  /// Set line-height
  ///
  /// @param space Line-height,If you want to restore to the default height, use SPACE_DEFAULT
  /// @return POSCommand Instance
  POSCommand setLineSpacing(int space) {
    _list.add({
      'method': 'setLineSpacing',
      'params': {
        'space': space,
      }
    });
    return this;
  }

  /// Select / cancel the inverted printing mode
  ///
  /// @param on True indicates selection, false indicates cancel
  /// @return POSCommand Instance
  POSCommand setTurnUpsideDownMode(bool on) {
    _list.add({
      'method': 'setTurnUpsideDownMode',
      'params': {
        'on': on,
      }
    });
    return this;
  }

  /// Select character code page
  ///
  /// @param page Code page
  /// @return POSCommand Instance
  POSCommand selectCodePage(int page) {
    _list.add({
      'method': 'selectCodePage',
      'params': {
        'page': page,
      }
    });
    return this;
  }

  /// Select font
  ///
  /// @param font Font type
  /// @return POSCommand Instance
  POSCommand selectCharacterFont(int font) {
    _list.add({
      'method': 'selectCharacterFont',
      'params': {
        'font': font,
      }
    });
    return this;
  }

  /// Set the right spacing of characters
  ///
  /// @param space Right spacing distance is space*hor_motion_unit
  /// @return POSCommand Instance
  POSCommand setCharRightSpace(int space) {
    _list.add({
      'method': 'setCharRightSpace',
      'params': {
        'space': space,
      }
    });
    return this;
  }

  /// This function is used to send data to the printer
  ///
  /// @param data Byte array to be sent
  /// @return POSCommand Instance
  POSCommand sendData(Uint8List data) {
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
