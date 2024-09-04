import 'package:flutter/services.dart';

class TSPLConst {
  static const String CODE_TYPE_128 = "128";
  static const String CODE_TYPE_128M = "128M";
  static const String CODE_TYPE_EAN128 = "EAN128";
  static const String CODE_TYPE_25 = "25";
  static const String CODE_TYPE_25C = "25C";
  static const String CODE_TYPE_39 = "39";
  static const String CODE_TYPE_39C = "39C";
  static const String CODE_TYPE_93 = "93";
  static const String CODE_TYPE_EAN13 = "EAN13";
  static const String CODE_TYPE_EAN13_2 = "EAN13+2";
  static const String CODE_TYPE_EAN13_5 = "EAN13+5";
  static const String CODE_TYPE_EAN8 = "EAN8";
  static const String CODE_TYPE_EAN8_2 = "EAN8+2";
  static const String CODE_TYPE_EAN8_5 = "EAN8+5";
  static const String CODE_TYPE_CODA = "CODA";
  static const String CODE_TYPE_POST = "POST";
  static const String CODE_TYPE_UPCA = "UPCA";
  static const String CODE_TYPE_UPCA_2 = "UPCA+2";
  static const String CODE_TYPE_UPCA_5 = "UPCA+5";
  static const String CODE_TYPE_UPCE = "UPCE";
  static const String CODE_TYPE_UPCE_2 = "UPCE+2";
  static const String CODE_TYPE_UPCE_5 = "UPCE+5";
  static const String CODE_TYPE_CPOST = "CPOST";
  static const String CODE_TYPE_MSI = "MSI";
  static const String CODE_TYPE_MSIC = "MSIC";
  static const String CODE_TYPE_PLESSEY = "PLESSEY";
  static const String CODE_TYPE_ITF14 = "ITF14";
  static const String CODE_TYPE_EAN14 = "EAN14";
  static const String CODE_TYPE_11 = "11";
  static const String CODE_TYPE_TELEPEN = "TELEPEN";
  static const String CODE_TYPE_TELEPENN = "TELEPENN";
  static const String CODE_TYPE_PLANET = "PLANET";
  static const String CODE_TYPE_CODE49 = "CODE49";
  static const String CODE_TYPE_DPI = "DPI";
  static const String CODE_TYPE_DPL = "DPL";
  static const int READABLE_NONE = 0;
  static const int READABLE_LEFT = 1;
  static const int READABLE_CENTER = 2;
  static const int READABLE_RIGHT = 3;
  static const int ROTATION_0 = 0;
  static const int ROTATION_90 = 90;
  static const int ROTATION_180 = 180;
  static const int ROTATION_270 = 270;
  static const int ALIGNMENT_LEFT = 1;
  static const int ALIGNMENT_CENTER = 2;
  static const int ALIGNMENT_RIGHT = 3;
  static const int DIRECTION_FORWARD = 0;
  static const int DIRECTION_REVERSE = 1;
  static const String FNT_8_12 = "1";
  static const String FNT_12_20 = "2";
  static const String FNT_16_24 = "3";
  static const String FNT_24_32 = "4";
  static const String FNT_32_48 = "5";
  static const String FNT_14_19 = "6";
  static const String FNT_14_25 = "7";
  static const String FNT_21_27 = "8";
  static const String FNT_SIMPLIFIED_CHINESE = "TSS24.BF2";
  static const String FNT_TRADITIONAL_CHINESE = "TST24.BF2";
  static const String FNT_KOREAN = "K";
  static const String EC_LEVEL_L = "L";
  static const String EC_LEVEL_M = "M";
  static const String EC_LEVEL_Q = "Q";
  static const String EC_LEVEL_H = "H";
  static const String QRCODE_MODE_AUTO = "A";
  static const String QRCODE_MODE_MANUAL = "M";
  static const String QRCODE_MODEL_M1 = "M1";
  static const String QRCODE_MODEL_M2 = "M2";
  static const int PAGE_437 = 437;
  static const int PAGE_850 = 850;
  static const int PAGE_852 = 852;
  static const int PAGE_860 = 860;
  static const int PAGE_863 = 863;
  static const int PAGE_865 = 865;
  static const int PAGE_1250 = 1250;
  static const int PAGE_1252 = 1252;
  static const int PAGE_1253 = 1253;
  static const int PAGE_1254 = 1254;
  static const int BMP_MODE_OVERWRITE = 0;
  static const int BMP_MODE_OR = 1;
  static const int BMP_MODE_XOR = 2;
  static const int BMP_MODE_OVERWRITE_C = 3;
  static const int BMP_MODE_OR_C = 4;
  static const int BMP_MODE_XOR_C = 5;
  static const int STS_CONNECT = 1;
  static const int STS_DISCONNECT = 0;
  static const int CUTTER_OFF = 0;
  static const int CUTTER_BATCH = -1;

  static const int Dithering= 0;
  static const int Threshold = 1;

  static const String StringEncoding_GB18030 = "GB18030";
  static const String StringEncoding_GB2312 = "GB2312";
  static const String StringEncoding_BIG5 = "BIG5";
  static const String StringEncoding_UTF8 = "UTF8";
}

class TSPLCommand {
  List<Map<String, dynamic>> _list = [];

  /// This method defines the label width and length
  ///
  /// @param width Label width (inch/mm)
  /// @param height Label height (inch/ mm)
  /// @return TSPLCommand Instance
  TSPLCommand sizeInch(int width, int height) {
    _list.add({
      'method': 'sizeInch',
      'params': {
        'width': width,
        'height': height,
      }
    });
    return this;
  }

  /// This method defines the label width and length
  ///
  /// @param width Label width (inch/mm)
  /// @param height Label height (inch/ mm)
  /// @return TSPLCommand Instance
  TSPLCommand sizeMm(double width, double height) {
    _list.add({
      'method': 'sizeMm',
      'params': {
        'width': width,
        'height': height,
      }
    });
    return this;
  }

  /// This method defines the gap distance between two labels
  ///
  /// @param m The gap distance between two labels
  /// @param n The offset distance of the gap
  /// @return TSPLCommand Instance
  TSPLCommand gapInch(double m, double n) {
    _list.add({
      'method': 'gapInch',
      'params': {
        'm': m,
        'n': n,
      }
    });
    return this;
  }

  /// This method defines the gap distance between two labels
  ///
  /// @param m The gap distance between two labels
  /// @param n The offset distance of the gap
  /// @return TSPLCommand Instance
  TSPLCommand gapMm(double m, double n) {
    _list.add({
      'method': 'gapMm',
      'params': {
        'm': m,
        'n': n,
      }
    });
    return this;
  }

  /// This method defines the print speed
  ///
  /// @param speed Printing speed in inch per second
  /// @return TSPLCommand Instance
  TSPLCommand speed(double speed) {
    _list.add({
      'method': 'speed',
      'params': {
        'speed': speed,
      }
    });
    return this;
  }

  /// This method sets the printing darkness.
  ///
  /// @param density Darkness level, 0~15
  /// @return TSPLCommand Instance
  TSPLCommand density(int density) {
    _list.add({
      'method': 'density',
      'params': {
        'density': density,
      }
    });
    return this;
  }

  /// This method clears the image buffer.
  ///
  /// @return TSPLCommand Instance
  TSPLCommand cls() {
    _list.add({
      'method': 'cls',
    });
    return this;
  }

  /// This command defines the selective, extra label feeding length each form feed takes, which, especially in peel-off mode and cutter mode, is used to adjust label stop position,
  /// so as for label to register at proper places for the intended purposes. The printer back tracks the extra feeding length before the next run of printing.
  ///
  /// @param offset The offset distance (inch or mm) -1 ≤ offset ≤ 1 (inch)
  /// @return TSPLCommand Instance
  TSPLCommand offsetInch(double offset) {
    _list.add({
      'method': 'offsetInch',
      'params': {
        'offset': offset,
      }
    });
    return this;
  }

  /// This command defines the selective, extra label feeding length each form feed takes, which, especially in peel-off mode and cutter mode, is used to adjust label stop position,
  /// so as for label to register at proper places for the intended purposes. The printer back tracks the extra feeding length before the next run of printing.
  ///
  /// @param offset The offset distance (inch or mm) -1 ≤ offset ≤ 1 (inch)
  /// @return TSPLCommand Instance
  TSPLCommand offsetMm(double offset) {
    _list.add({
      'method': 'offsetMm',
      'params': {
        'offset': offset,
      }
    });
    return this;
  }

  /// This method defines the printout direction and mirror image. This will be stored in the printer memory.
  ///
  /// @param direction Printout direction
  /// @param isMirror mirror image(true or false),Default value:false
  /// @return TSPLCommand Instance
  TSPLCommand direction(int direction, {bool isMirror = false}) {
    _list.add({
      'method': 'direction',
      'params': {
        'direction': direction,
        'isMirror': isMirror,
      }
    });
    return this;
  }

  /// This method feeds label with the specified length. The length is specified by dot.
  ///
  /// @param length Length,unit: dot
  /// @return TSPLCommand Instance
  TSPLCommand feed(int length) {
    _list.add({
      'method': 'feed',
      'params': {
        'length': length,
      }
    });
    return this;
  }

  /// This method defines the reference point of the label.
  /// The reference (origin) point varies with the print direction.
  ///
  /// @param x Horizontal coordinate (in dots)
  /// @param y Vertical coordinate (in dots)
  /// @return TSPLCommand Instance
  TSPLCommand reference(int x, int y) {
    _list.add({
      'method': 'reference',
      'params': {
        'x': x,
        'y': y,
      }
    });
    return this;
  }

  /// This method draws a bar on the label format.
  ///
  /// @param x The upper left corner x-coordinate (in dots)
  /// @param y The upper left corner y-coordinate (in dots)
  /// @param width width Bar width (in dots)
  /// @param height height Bar height (in dots)
  /// @return TSPLCommand Instance
  TSPLCommand bar(int x, int y, int width, int height) {
    _list.add({
      'method': 'bar',
      'params': {
        'x': x,
        'y': y,
        'width': width,
        'height': height,
      }
    });
    return this;
  }

  /// This method draws rectangles on the label.
  ///
  /// @param x Specify x-coordinate of upper left corner (in dots)
  /// @param y Specify y-coordinate of upper left corner (in dots)
  /// @param width width rectangles width (in dots)
  /// @param height height rectangles height (in dots)
  /// @param thickness line thickness Line thickness (in dots)
  /// @return TSPLCommand Instance
  TSPLCommand box(int x, int y, int width, int height, int thickness) {
    _list.add({
      'method': 'box',
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

  /// This method feeds the label in reverse. The length is specified by dot.
  ///
  /// @param length Length unit: dot
  /// @return TSPLCommand Instance
  TSPLCommand backFeed(int length) {
    _list.add({
      'method': 'backFeed',
      'params': {
        'length': length,
      }
    });
    return this;
  }

  /// This method feeds label to the beginning of next label.
  ///
  /// @return TSPLCommand Instance
  TSPLCommand formFeed() {
    _list.add({
      'method': 'formFeed',
    });
    return this;
  }

  /// This method will feed label until the internal sensor has determined the origin. Size and gap of the label should be defined before using this method.
  ///
  /// @return TSPLCommand Instance
  TSPLCommand home() {
    _list.add({
      'method': 'home',
    });
    return this;
  }

  /// This method prints the label format currently stored in the image buffer.
  ///
  /// @param count Specifies how many sets of labels will be printed. Default value:1.
  /// @return TSPLCommand Instance
  TSPLCommand print({int count = 1}) {
    if (count != null) {
      _list.add({
        'method': 'print',
        'params': {'count': count},
      });
    } else {
      _list.add({'method': 'print'});
    }
    return this;
  }

  /// This method defines the code page of international character set.
  ///
  /// @param page Name or number of code page.
  /// @return TSPLCommand Instance
  TSPLCommand codePage(String page) {
    _list.add({
      'method': 'codePage',
      'params': {'page': page},
    });
    return this;
  }

  /// This method controls the sound frequency of the beeper. There are 10 levels of sounds. The timing control can be set by the "interval" parameter.
  ///
  /// @param count Sound level:0~9
  /// @param interval Sound interval: 1~4095.(in ms)
  /// @return TSPLCommand Instance
  TSPLCommand sound(int count, int interval) {
    _list.add({
      'method': 'sound',
      'params': {
        'count': count,
        'interval': interval,
      }
    });
    return this;
  }

  /// Limit the maximum length of the fixed clearance correction execution
  ///
  /// @param length The maximum length for sensor detecting
  /// @return TSPLCommand Instance
  TSPLCommand limitFeedInch(int length) {
    _list.add({
      'method': 'limitFeedInch',
      'params': {'length': length},
    });
    return this;
  }

  /// Limit the maximum length of the fixed clearance correction execution
  ///
  /// @param length The maximum length for sensor detecting
  /// @return TSPLCommand Instance
  TSPLCommand limitFeedMm(int length) {
    _list.add({
      'method': 'limitFeedMm',
      'params': {'length': length},
    });
    return this;
  }

  /// This method prints 1D barcodes
  ///
  /// @param x Specify the x-coordinate bar code on the label
  /// @param y Specify the y-coordinate bar code on the label
  /// @param codeType
  /// @param height Bar code height (in dots)
  /// @param content Content of barcode
  /// @param readable human readable , Default value:READABLE_LEFT
  /// @param rotation Default value:ROTATION_0
  /// @param narrow Width of narrow element (in dots), Default value:2
  /// @param wide Width of wide element (in dots),Default value:2
  /// @return TSPLCommand Instance
  TSPLCommand barcode(int x, int y, String codeType, int height,String content, {int readable = TSPLConst.READABLE_LEFT, int rotation = TSPLConst.ROTATION_0, int narrow = 2, int wide = 2}) {
    _list.add({
      'method': 'barcode',
      'params': {
        'x': x,
        'y': y,
        'codeType': codeType,
        'height': height,
        'readable': readable,
        'rotation': rotation,
        'narrow': narrow,
        'wide': wide,
        'content': content,
      }
    });
    return this;
  }

  /// This method draws bitmap images
  ///
  /// @param x Specify the x-coordinate
  /// @param y Specify the y-coordinate
  /// @param mode Graphic modes listed below
  /// @param width Print width of picture
  /// @param bitmap base64 string bmp
  /// @return TSPLCommand Instance
  TSPLCommand base64bitmap(int x, int y, int mode, int width, String bitmap) {
    _list.add({
      'method': 'base64bitmap',
      'params': {
        'x': x,
        'y': y,
        'mode': mode,
        'width': width,
        'bitmap': bitmap,
      }
    });
    return this;
  }

  /// This method draws bitmap images
  ///
  /// @param x Specify the x-coordinate
  /// @param y Specify the y-coordinate
  /// @param mode Graphic modes listed below
  /// @param width Print width of picture
  /// @param bitmap Uint8List type
  /// @return TSPLCommand Instance
  TSPLCommand bitmap(int x, int y, int mode, int width, Uint8List bitmap) {
    _list.add({
      'method': 'bitmap',
      'params': {
        'x': x,
        'y': y,
        'mode': mode,
        'width': width,
        'bitmap': bitmap,
      }
    });
    return this;
  }

  /// Transferring images to printers through compression, only applicable to some models
  ///
  /// @param x Specify the x-coordinate
  /// @param y Specify the y-coordinate
  /// @param mode Graphic modes listed below
  /// @param width Print width of picture
  /// @param bitmap Uint8List type
  /// @return TSPLCommand Instance
  TSPLCommand bitmapCompression(int x, int y, int mode, int width, Uint8List bitmap) {
    _list.add({
      'method': 'bitmapCompression',
      'params': {
        'x': x,
        'y': y,
        'mode': mode,
        'width': width,
        'bitmap': bitmap,
      }
    });
    return this;
  }

  /// This method prints QR code
  ///
  /// @param x The upper left corner x-coordinate of the QR code
  /// @param y The upper left corner x-coordinate of the QR code
  /// @param cellWidth size:1~10
  /// @param rotation Clockwise rotation angle, Default value:ROTATION_0
  /// @param data QRCode data content.
  /// @param ecLevel Error correction recovery level
  /// @param mode Auto / manual encode
  /// @param model
  /// @param mask S0~S8, default is S7
  /// @return TSPLCommand Instance
  TSPLCommand qrcode(int x, int y, int cellWidth, int rotation, String data, {String ecLevel = TSPLConst.EC_LEVEL_L, String mode = TSPLConst.QRCODE_MODE_AUTO, String model = TSPLConst.QRCODE_MODEL_M1, String mask = "S7"}) {
    _list.add({
      'method': 'qrcode',
      'params': {
        'x': x,
        'y': y,
        'ecLevel': ecLevel,
        'cellWidth': cellWidth,
        'mode': mode,
        'rotation': rotation,
        'model': model,
        'mask': mask,
        'data': data,
      }
    });
    return this;
  }

  /// This method prints text on label
  ///
  /// @param x The x-coordinate of the text
  /// @param y The y-coordinate of the text
  /// @param font
  /// @param content Content of text string
  /// @param rotation Clockwise rotation angle, Default value:ROTATION_0
  /// @param xRatio
  /// @param yRatio
  /// @return TSPLCommand Instance
  TSPLCommand text(int x, int y, String font, String content, {int rotation = TSPLConst.ROTATION_0, int xRatio = 1, int yRatio = 1}) {
    _list.add({
      'method': 'text',
      'params': {
        'x': x,
        'y': y,
        'font': font,
        'rotation': rotation,
        'xRatio': xRatio,
        'yRatio': yRatio,
        'content': content,
      }
    });
    return this;
  }

  /// This method clears a specified region in the image buffer.
  ///
  /// @param x The x-coordinate of the starting point (in dots)
  /// @param y The y-coordinate of the starting point (in dots)
  /// @param width The region width in x-axis direction (in dots)
  /// @param height The region height in y-axis direction (in dots)
  /// @return TSPLCommand Instance
  TSPLCommand erase(int x, int y, int width, int height) {
    _list.add({
      'method': 'erase',
      'params': {
        'x': x,
        'y': y,
        'width': width,
        'height': height,
      }
    });
    return this;
  }

  /// This method reverses a region in image buffer.
  ///
  /// @param The x-coordinate of the starting point (in dots)
  /// @param The y-coordinate of the starting point (in dots)
  /// @param X-axis region width (in dots)
  /// @param Y-axis region height (in dots)
  /// @return TSPLCommand Instance
  TSPLCommand reverse(int x, int y, int width, int height) {
    _list.add({
      'method': 'reverse',
      'params': {
        'x': x,
        'y': y,
        'width': width,
        'height': height,
      }
    });
    return this;
  }

  /// This command activates the cutter to immediately cut the labels without back feeding the label.
  ///
  /// @return TSPLCommand Instance
  TSPLCommand cut() {
    _list.add({'method': 'cut'});
    return this;
  }

  /// This method is used to enable/disable the self-peeling function.
  /// The default setting for this function is false. When this function is set true, the printer stops after each label printing, and does not print the next label until the peeled label is taken away.
  /// This setting will be saved in printer memory when turning off the power.
  ///
  /// @param isOpen
  /// true:Enable the self-peeling function
  /// false:Disable the self-peeing function
  /// @return TSPLCommand Instance
  TSPLCommand setPeel(bool isOpen) {
    _list.add({
      'method': 'setPeel',
      'params': {'isOpen': isOpen},
    });
    return this;
  }

  /// This method is used to enable/disable feeding of labels to gap/black mark position for tearing off.
  /// This setting will be saved in printer memory when turning off the power
  ///
  /// @param isOpen
  /// true:The label gap will stop at the tear off position after print.
  /// false:The label gap will NOT stop at the tear off position after print.
  /// The beginning of label will be aligned to print head.
  /// @return TSPLCommand Instance
  TSPLCommand setTear(bool isOpen) {
    _list.add({
      'method': 'setTear',
      'params': {'isOpen': isOpen},
    });
    return this;
  }

  /// This method sets the height of the black line and the user-defined extra label feeding length each form feed takes.
  ///
  /// @param m The height of black line either in inch
  /// @param n The extra label feeding length 0 ≤ n ≤ label length
  /// @return TSPLCommand Instance
  TSPLCommand blineInch(double m, double n) {
    _list.add({
      'method': 'blineInch',
      'params': {
        'm': m,
        'n': n,
      }
    });
    return this;
  }

  /// This method sets the height of the black line and the user-defined extra label feeding length each form feed takes.
  ///
  /// @param m The height of black line either in mm
  /// @param n The extra label feeding length 0 ≤ n ≤ label length
  /// @return TSPLCommand Instance
  TSPLCommand blineMm(double m, double n) {
    _list.add({
      'method': 'blineMm',
      'params': {
        'm': m,
        'n': n,
      }
    });
    return this;
  }

  /// Set character encoding,Default is “gbk”
  ///
  /// @param charSet Character set name.
  /// @return TSPLCommand Instance
  TSPLCommand setCharSet(String charSet) {
    _list.add({
      'method': 'setCharSet',
      'params': {'charSet': charSet},
    });
    return this;
  }

  /// This function is used to send data to the printer
  ///
  /// @param data Byte array to be sent
  /// @return TSPLCommand Instance
  TSPLCommand sendData(Uint8List data) {
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
