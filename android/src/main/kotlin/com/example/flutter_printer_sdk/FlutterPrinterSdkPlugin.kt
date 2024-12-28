package com.example.flutter_printer_sdk

/// use andiord aar
import android.Manifest
import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Base64
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import net.posprinter.IDeviceConnection
import net.posprinter.IPOSListener
import net.posprinter.POSConnect
import net.posprinter.POSConst
import net.posprinter.POSPrinter
import net.posprinter.TSPLPrinter
import net.posprinter.ZPLPrinter
import net.posprinter.posprinterface.IDataCallback
import io.flutter.plugin.common.MethodChannel.Result
import java.nio.charset.Charset
import  net.posprinter.TSPLConst
import net.posprinter.model.AlgorithmType

import android.os.Handler
import android.os.Looper


class FlutterPrinterSdkPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private lateinit var context: Context
  private var activity: Activity? = null
  private var bluetoothAdapter: BluetoothAdapter? = null

  private var connect: IDeviceConnection? = null
  private val TAG = "PrintersdkPlugin"

  private val PERMISSION_REQUEST_CODE = 1
  private var permissionResult: Result? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_printer_sdk_plugin")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
    bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
    POSConnect.init(context)
    val filter = IntentFilter(BluetoothDevice.ACTION_FOUND)
    context.registerReceiver(receiver, filter)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "checkPermissions" -> checkPermissions(result)
      "startScan" -> startScan(result)
      "connectBt" -> connectBt(call,result)
      "sendESC" -> sendESC(call,result)
      "disconnect" -> disconnect(result)
      "posPrinterStatus" -> posPrinterStatus(result)
      "getUsbPaths" -> getUsbPaths(result)
      "getUsbDevice" -> getUsbDevice(result)
      "sendTSPL" -> sendTSPL(call,result)
      "getSerialNumber" -> getSerialNumber(result)
      "checkIsConnect" -> checkIsConnect(result)
      "openCashBox" -> openCashBox(result)
      "labelPrinterStatus" -> labelPrinterStatus(call,result)
      "connectUsb" -> connectUsb(call,result)
      "setBluetooth" -> setBluetooth(call,result)
      "cashBoxCheck" -> cashBoxCheck(result)
      "sendZPL" -> sendZPL(call,result)
      "connectNet" -> connectNet(call,result)
      "setCodePage" -> setCodePage(call,result)
      "selectCodePage" -> selectCodePage(call,result)
      else -> result.notImplemented()
    }
  }

  private fun setCodePage(call: MethodCall, result: Result) {
    val codepage = (call.argument("codepage") as String?)!!
    TSPLPrinter(connect).codePage(codepage)
    result.success(null)
  }

  private fun selectCodePage(call: MethodCall, result: Result) {
    val codepage = (call.argument("page") as Int?)!!
    POSPrinter(connect).initializePrinter().selectCodePage(codepage)
    result.success(null)
  }

  private fun cashBoxCheck(result: Result) {
    val printer = POSPrinter(connect)
    printer.cashBoxCheck {
      result.success(it)
    }
  }

  private fun setBluetooth(call: MethodCall, result: Result) {
    val name = (call.argument("name") as String?)!!
    val pin = (call.argument("pin") as String?)!!
    Log.i(TAG, "name:$name,pin;$pin")
    POSPrinter(connect).setBluetooth(name,pin)
    result.success(null)
  }

  private fun connectUsb(call: MethodCall, result: Result) {
    val path = (call.argument("path") as String?)!!
    Log.i(TAG, "path:$path")
    connect?.close()
    connect = POSConnect.createDevice(POSConnect.DEVICE_TYPE_USB)
    connect!!.connect(path, connectListener)
    result.success(null)
  }

  private fun getUsbPaths(result: Result) {
    val usbs = POSConnect.getUsbDevices(POSConnect.getAppCtx())
    usbs.forEach {
      Log.i("LLLLLL", it)
    };
    result.success(usbs)
  }

  private fun getUsbDevice(result: Result) {
    val usbDevices = POSConnect.getUsbDevice(POSConnect.getAppCtx())

    val deviceList = usbDevices.map { device ->
      mapOf(
        "name" to device.productName,
        "vendor_id" to device.vendorId,
        "product_id" to device.productId,
        "device_name" to device.deviceName
      )
    }
    result.success(deviceList)
  }

  private fun disconnect(result: Result) {
    connect?.close()
    connect = null
    result.success(null)
  }

  private fun openCashBox(result: Result) {
    POSPrinter(connect).openCashBox(POSConst.PIN_TWO)
    result.success(null)
  }

  private fun getSerialNumber(result: Result) {
    val printer = POSPrinter(connect)
    printer.getSerialNumber {
      result.success(String(it, Charset.defaultCharset()))
    }
  }

  private fun checkIsConnect(result: Result) {
    val printer = POSPrinter(connect)
    printer.isConnect {
      result.success(it)
    }
  }

  private fun posPrinterStatus(result: Result) {
    val printer = POSPrinter(connect)
    printer.printerStatus {
      result.success(it)
    }
  }

  private fun labelPrinterStatus(call: MethodCall, result: Result) {
    val timeout = (call.argument("timeout") as Int?)!!
    TSPLPrinter(connect).printerStatus(timeout) {
      result.success(it)
    }
  }

  private fun sendTSPL(call: MethodCall, result: Result) {
    val data = call.argument<List<Map<String, Any>>>("data")
    val printer = TSPLPrinter(connect)

    data?.forEach { command ->
      val method = command["method"] as String
      val params = command["params"] as? Map<String, Any>

      when (method) {
        "sizeInch" -> {
          val width = params?.get("width") as Int
          val height = params?.get("height") as Int
          printer.sizeInch(width.toDouble(), height.toDouble())
        }
        "sizeMm" -> {
          val width = (params?.get("width") as Number).toDouble()
          val height = (params?.get("height") as Number).toDouble()
          printer.sizeMm(width, height)
        }
        "gapInch" -> {
          val m = (params?.get("m") as Number).toDouble()
          val n = (params?.get("n") as Number).toDouble()
          printer.gapInch(m, n)
        }
        "gapMm" -> {
          val m = (params?.get("m") as Number).toDouble()
          val n = (params?.get("n") as Number).toDouble()
          printer.gapMm(m, n)
        }
        "speed" -> {
          val speed = (params?.get("speed") as Number).toDouble()
          printer.speed(speed)
        }
        "density" -> {
          val density = params?.get("density") as Int
          printer.density(density)
        }
        "cls" -> printer.cls()
        "offsetInch" -> {
          val offset = (params?.get("offset") as Number).toDouble()
          printer.offsetInch(offset)
        }
        "offsetMm" -> {
          val offset = (params?.get("offset") as Number).toDouble()
          printer.offsetMm(offset)
        }
        "direction" -> {
          val direction = params?.get("direction") as Int
          val isMirror = params?.get("isMirror") as? Boolean ?: false
          printer.direction(direction, isMirror)
        }
        "feed" -> {
          val length = params?.get("length") as Int
          printer.feed(length)
        }
        "reference" -> {
          val x = params?.get("x") as Int
          val y = params?.get("y") as Int
          printer.reference(x, y)
        }
        "bar" -> {
          val x = params?.get("x") as Int
          val y = params?.get("y") as Int
          val width = params?.get("width") as Int
          val height = params?.get("height") as Int
          printer.bar(x, y, width, height)
        }
        "box" -> {
          val x = params?.get("x") as Int
          val y = params?.get("y") as Int
          val width = params?.get("width") as Int
          val height = params?.get("height") as Int
          val thickness = params?.get("thickness") as Int
          printer.box(x, y, width, height, thickness)
        }
        "backFeed" -> {
          val length = params?.get("length") as Int
          printer.backFeed(length)
        }
        "formFeed" -> printer.formFeed()
        "home" -> printer.home()
        "print" -> {
          val count = params?.get("count") as? Int ?: 1
          printer.print(count)
        }
        "codePage" -> {
          val page = params?.get("page") as String
          printer.codePage(page)
        }
        "sound" -> {
          val count = params?.get("count") as Int
          val interval = params?.get("interval") as Int
          printer.sound(count, interval)
        }
        "limitFeedInch" -> {
          val length = params?.get("length") as Int
          printer.limitFeedInch(length)
        }
        "limitFeedMm" -> {
          val length = params?.get("length") as Int
          printer.limitFeedMm(length)
        }
        "barcode" -> {
          val x = params?.get("x") as Int
          val y = params?.get("y") as Int
          val codeType = params?.get("codeType") as String
          val height = params?.get("height") as Int
          val readable = params?.get("readable") as Int
          val rotation = params?.get("rotation") as Int
          val narrow = params?.get("narrow") as Int
          val wide = params?.get("wide") as Int
          val content = params?.get("content") as String
          printer.barcode(x,y,codeType,height,readable,rotation,narrow,wide,content)
        }
        "base64bitmap" -> {
          val x = params?.get("x") as Int
          val y = params?.get("y") as Int
          val mode = params?.get("mode") as Int
          val width = params?.get("width") as Int

          val bitmapBase64 = params?.get("bitmap") as? String
          if (bitmapBase64 != null) {
            val bytes: ByteArray = Base64.decode(bitmapBase64, Base64.DEFAULT)
            val bmp = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
            printer.bitmap(x,y,mode,width,bmp, AlgorithmType.Threshold)
          }
        }
        "bitmap" -> {
          val x = params?.get("x") as Int
          val y = params?.get("y") as Int
          val mode = params?.get("mode") as Int
          val width = params?.get("width") as Int

          val bytes: ByteArray =params?.get("bitmap") as? ByteArray?:ByteArray(0)
          val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
          printer.bitmap(x,y,mode,width,bitmap, AlgorithmType.Threshold)
        }
        "bitmapCompression" -> {
          val x = params?.get("x") as Int
          val y = params?.get("y") as Int
          val mode = params?.get("mode") as Int
          val width = params?.get("width") as Int

          val bytes: ByteArray =params?.get("bitmap") as? ByteArray?:ByteArray(0)
          val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
          printer.bitmapCompression(x,y,mode,width,bitmap, AlgorithmType.Threshold)
        }
        "qrcode" -> {
          val x = params?.get("x") as Int
          val y = params?.get("y") as Int
          val cellWidth = params?.get("cellWidth") as Int
          val rotation = params?.get("rotation") as Int
          val data = params?.get("data") as String
          val ecLevel = params?.get("ecLevel") as String? ?: TSPLConst.EC_LEVEL_L
          val mode = params?.get("mode") as String? ?: TSPLConst.QRCODE_MODE_AUTO
          val model = params?.get("model") as String? ?: TSPLConst.QRCODE_MODEL_M1
          val mask = params?.get("mask") as String? ?: "S7"
          printer.qrcode(x,y,ecLevel,cellWidth,mode,rotation,model,mask,data)
        }
        "text" -> {
          val x = params?.get("x") as Int
          val y = params?.get("y") as Int
          val font = params?.get("font") as String
          val content = params?.get("content") as String
          val rotation = params?.get("rotation") as Int? ?: TSPLConst.ROTATION_0
          val xRatio = params?.get("xRatio") as Int? ?: 1
          val yRatio = params?.get("yRatio") as Int? ?: 1
          printer.text(x,y,font,rotation,xRatio,yRatio,content)
        }
        "erase" -> {
          val x = params?.get("x") as Int
          val y = params?.get("y") as Int
          val width = params?.get("width") as Int
          val height = params?.get("height") as Int
          printer.erase(x, y, width, height)
        }
        "reverse" -> {
          val x = params?.get("x") as Int
          val y = params?.get("y") as Int
          val width = params?.get("width") as Int
          val height = params?.get("height") as Int
          printer.reverse(x, y, width, height)
        }
        "cut" -> printer.cut()
        "setPeel" -> {
          val isOpen = params?.get("isOpen") as Boolean
          printer.setPeel(isOpen)
        }
        "setTear" -> {
          val isOpen = params?.get("isOpen") as Boolean
          printer.setTear(isOpen)
        }
        "blineInch" -> {
          val m = (params?.get("m") as Number).toDouble()
          val n = (params?.get("n") as Number).toDouble()
          printer.blineInch(m, n)
        }
        "blineMm" -> {
          val m = (params?.get("m") as Number).toDouble()
          val n = (params?.get("n") as Number).toDouble()
          printer.blineMm(m, n)
        }
        "setCharSet" -> {
          val charSet = params?.get("charSet") as String
          printer.setCharSet(charSet)
        }
        "sendData" -> {
          val data: ByteArray =params?.get("data") as? ByteArray?:ByteArray(0)
          POSPrinter(connect).sendData(data)
        }
        // You can add more methods here if needed
      }
    }
  }

  private fun sendESC(call: MethodCall, result: Result) {
    val data = call.argument<List<Map<String, Any>>>("data")
    val printer = POSPrinter(connect).initializePrinter()

    data?.forEach { command ->
      val method = command["method"] as String
      val params = command["params"] as? Map<String, Any>

      when (method) {
        "printString" -> {
          val text = params?.get("text") as? String
          printer.printString(text ?: "")
        }
        "printText" -> {
          val text = params?.get("text") as? String
          val alignment = params?.get("alignment") as? Int ?: POSConst.ALIGNMENT_LEFT
          val attribute = params?.get("attribute") as? Int ?: POSConst.FNT_DEFAULT
          val textSize = params?.get("textSize") as? Int ?: (POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT)
          if (text != null) {
            printer.printText(text, alignment, attribute, textSize)
          }
        }
        "printBase64Bitmap" -> {
          val bitmapBase64 = params?.get("bitmap") as? String
          val alignment = params?.get("alignment") as? Int ?: POSConst.ALIGNMENT_CENTER
          val mode = params?.get("mode") as? Int ?: POSConst.BMP_NORMAL
          val width = params?.get("width") as? Int ?: 384
          if (bitmapBase64 != null) {
            val bytes: ByteArray = Base64.decode(bitmapBase64, Base64.DEFAULT)
            val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
            printer.printBitmap(bitmap, alignment, width, mode)
          }
        }
        "printBitmap" -> {
          val alignment = params?.get("alignment") as? Int ?: POSConst.ALIGNMENT_CENTER
          val mode = params?.get("mode") as? Int ?: POSConst.BMP_NORMAL
          val width = params?.get("width") as? Int ?: 384
          val bytes: ByteArray =params?.get("bitmap") as? ByteArray?:ByteArray(0)
          val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
          printer.printBitmap(bitmap, alignment, width, mode)
        }
        "printBarCode" -> {
          val data = params?.get("data") as? String
          val codeType = params?.get("codeType") as? Int
          val width = params?.get("width") as? Int
          val height = params?.get("height") as? Int
          val alignment = params?.get("alignment") as? Int
          val textPosition = params?.get("textPosition") as? Int

          when {
            width != null && height != null && alignment != null && textPosition != null -> {
              printer.printBarCode(data ?: "", codeType ?: 0, width, height, alignment, textPosition)
            }
            width != null && height != null && alignment != null -> {
              printer.printBarCode(data ?: "", codeType ?: 0, width, height, alignment)
            }
            else -> {
              printer.printBarCode(data ?: "", codeType ?: 0)
            }
          }
        }
        "feedLine" -> {
          val lineCount = params?.get("lineCount") as? Int ?: 1
          printer.feedLine(lineCount)
        }
        "printQRCode" -> {
          val content = params?.get("content") as? String
          val moduleSize = params?.get("moduleSize") as? Int ?: 8
          val ecLevel = params?.get("ecLevel") as? Int ?: POSConst.QRCODE_EC_LEVEL_L
          val alignment = params?.get("alignment") as? Int ?: POSConst.ALIGNMENT_CENTER
          if (content != null) {
            printer.printQRCode(content, moduleSize, ecLevel, alignment)
          }
        }
        "cutHalfAndFeed" -> {
          val lines = params?.get("lines") as? Int
          printer.cutHalfAndFeed(lines ?: 1)
        }
        "cutPaper" -> {
          val model = params?.get("model") as? Int ?: POSConst.CUT_HALF
          printer.cutPaper(model)
        }
        "openCashBox" -> {
          val pinNum = params?.get("pinNum") as? Int
          val onTime = params?.get("onTime") as? Int ?: 30
          val offTime = params?.get("offTime") as? Int ?: 255
          if (pinNum != null) {
            printer.openCashBox(pinNum, onTime, offTime)
          }
        }
        "setCharSet" -> {
          val charSet = params?.get("charSet") as? String
          if (charSet != null) {
            printer.setCharSet(charSet)
          }
        }
        "setTextStyle" -> {
          val attribute = params?.get("attribute") as? Int ?: POSConst.FNT_DEFAULT
          val textSize = params?.get("textSize") as? Int ?: (POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT)
          printer.setTextStyle(attribute, textSize)
        }
        "setAlignment" -> {
          val alignment = params?.get("alignment") as? Int ?: POSConst.ALIGNMENT_LEFT
          printer.setAlignment(alignment)
        }
        "setPrintArea" -> {
          val width = params?.get("width") as? Int
          val height = params?.get("height") as? Int
          val x = params?.get("x") as? Int ?: 0
          val y = params?.get("y") as? Int ?: 0
          if (width != null && height != null) {
            printer.setPrintArea(width, height, x, y)
          }
        }
        "setPageModel" -> {
          val isOpen = params?.get("isOpen") as? Boolean ?: false
          printer.setPageModel(isOpen)
        }
        "printPageModelData" -> {
          printer.printPageModelData()
        }
        "setPrintDirection" -> {
          val direction = params?.get("direction") as? Int
          if (direction != null) {
            printer.setPrintDirection(direction)
          }
        }
        "setAbsoluteHorizontal" -> {
          val position = params?.get("position") as? Int
          if (position != null) {
            printer.setAbsoluteHorizontal(position)
          }
        }
        "setRelativeHorizontal" -> {
          val position = params?.get("position") as? Int
          if (position != null) {
            printer.setRelativeHorizontal(position)
          }
        }
        "setAbsoluteVertical" -> {
          val position = params?.get("position") as? Int
          if (position != null) {
            printer.setAbsoluteVertical(position)
          }
        }
        "setRelativeVertical" -> {
          val position = params?.get("position") as? Int
          if (position != null) {
            printer.setRelativeVertical(position)
          }
        }
        "downloadNVImage" -> {
          val bitmaps = params?.get("bitmaps") as? List<ByteArray>
          val imageWidth = params?.get("imageWidth") as? Int
          if (bitmaps != null && imageWidth != null) {
            val bitmapList: MutableList<Bitmap> = mutableListOf()
            for (bitmap in bitmaps) {
              val bmp = BitmapFactory.decodeByteArray(bitmap, 0, bitmap.size)
              bitmapList.add(bmp)
            }
            printer.downloadNVImage(bitmapList,imageWidth)
          }
        }
        "printNVImage" -> {
          val index = params?.get("index") as? Int
          val model = params?.get("model") as? Int
          if (index != null && model != null) {
            printer.printNVImage(index, model)
          }
        }
        "initializePrinter" -> {
          printer.initializePrinter()
        }
        "selectBitmapModel" -> {
          val model = params?.get("model") as? Int
          val width = params?.get("width") as? Int

          val bytes: ByteArray =params?.get("bitmap") as? ByteArray?:ByteArray(0)
          val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
          if (model != null && width != null && bitmap != null) {
            printer.selectBitmapModel(model,width,bitmap)
          }
        }
        "feedDot" -> {
          val n = params?.get("n") as? Int
          if (n != null) {
            printer.feedDot(n)
          }
        }
        "setLineSpacing" -> {
          val space = params?.get("space") as? Int
          if (space != null) {
            printer.setLineSpacing(space)
          }
        }
        "setTurnUpsideDownMode" -> {
          val on = params?.get("on") as? Boolean ?: false
          printer.setTurnUpsideDownMode(on)
        }
        "selectCodePage" -> {
          val page = params?.get("page") as? Int
          if (page != null) {
            printer.selectCodePage(page)
          }
        }
        "selectCharacterFont" -> {
          val font = params?.get("font") as? Int
          if (font != null) {
            printer.selectCharacterFont(font)
          }
        }
        "printPDF417" -> {
          val pdfData = params?.get("pdfData") as? String
          val cellWidth = params?.get("cellWidth") as? Int ?: 2
          val cellHeightRatio = params?.get("cellHeightRatio") as? Int ?: 2
          val numberOfColumns = params?.get("numberOfColumns") as? Int ?: 8
          val numberOfRows = params?.get("numberOfRows") as? Int ?: 3
          val eclType = params?.get("eclType") as? Int ?: 1
          val eclValue = params?.get("eclValue") as? Int ?: 1
          val alignment = params?.get("alignment") as? Int ?: POSConst.ALIGNMENT_LEFT
          if (pdfData != null) {
            printer.printPDF417(pdfData, cellWidth, cellHeightRatio, numberOfColumns, numberOfRows, eclType, eclValue, alignment)
          }
        }
        "sendData" -> {
          val data: ByteArray =params?.get("data") as? ByteArray?:ByteArray(0)
          POSPrinter(connect).sendData(data)
        }
      }
    }
  }

  private fun sendZPL(call: MethodCall, result: Result) {
    val data = call.argument<List<Map<String, Any>>>("data")
    val printer = ZPLPrinter(connect)

    data?.forEach { command ->
      val method = command["method"] as String
      val params = command["params"] as? Map<String, Any>

      when (method) {
        "addStart" -> printer.addStart()
        "addEnd" -> printer.addEnd()
        "addText" -> {
          val x = params?.get("x") as Int
          val y = params?.get("y") as Int
          val content = params?.get("content") as String
          val fontName = (params?.get("fontName") as String)[0] // char type
          val rotation = params?.get("rotation") as String
          val sizeW = params?.get("sizeW") as Int
          val sizeH = params?.get("sizeH") as Int
          printer.addText(x,y,fontName,rotation,sizeW,sizeH,content)
        }
        "setCustomFont" -> {
          val font = params?.get("font") as String
          val alias = (params?.get("alias") as String)[0]
          val codePage = params?.get("codePage") as Int
          printer.setCustomFont(font, alias, codePage)
        }
        "setPrinterWidth" -> {
          val width = params?.get("width") as Int
          printer.setPrinterWidth(width)
        }
        "setLabelLength" -> {
          val length = params?.get("length") as Int
          printer.setLabelLength(length)
        }
        "addReverse" -> {
          val x = params?.get("x") as Int
          val y = params?.get("y") as Int
          val width = params?.get("width") as Int
          val height = params?.get("height") as Int
          val radius = params?.get("radius") as? Int ?: 0
          printer.addReverse(x, y, width, height, radius)
        }
        "addBox" -> {
          val x = params?.get("x") as Int
          val y = params?.get("y") as Int
          val width = params?.get("width") as Int
          val height = params?.get("height") as Int
          val thickness = params?.get("thickness") as Int
          val radius = params?.get("radius") as? Int ?: 0
          printer.addBox(x, y, width, height, thickness, radius)
        }
        "addGraphicDiagonalLine" -> {
          val x = params?.get("x") as Int
          val y = params?.get("y") as Int
          val orientation = (params?.get("orientation") as String)[0]
          val width = params?.get("width") as Int
          val height = params?.get("height") as Int
          val thickness = params?.get("thickness") as Int
          printer.addGraphicDiagonalLine(x, y, orientation, width, height, thickness)
        }
        "addGraphicEllipse" -> {
          val x = params?.get("x") as Int
          val y = params?.get("y") as Int
          val width = params?.get("width") as Int
          val height = params?.get("height") as Int
          val thickness = params?.get("thickness") as Int
          printer.addGraphicEllipse(x, y, width, height, thickness)
        }
        "addGraphicCircle" -> {
          val x = params?.get("x") as Int
          val y = params?.get("y") as Int
          val diameter = params?.get("diameter") as Int
          val thickness = params?.get("thickness") as Int
          printer.addGraphicCircle(x, y, diameter, thickness)
        }
        "addBarcode" -> {
          val x = params?.get("x") as Int
          val y = params?.get("y") as Int
          val codeType = params?.get("codeType") as String
          val data = params?.get("data") as String
          val ratio = params?.get("ratio") as String
          val textPosition = (params?.get("textPosition") as Int).toByte() // 转换为 Byte 类型
          val width = params?.get("width") as Int
          val height = params?.get("height") as Int
          printer.addBarcode(x, y, codeType, ratio, textPosition, data, width, height)
        }
        "addQRCode" -> {
          val x = params?.get("x") as Int
          val y = params?.get("y") as Int
          val data = params?.get("data") as String
          val size = params?.get("size") as Int
          printer.addQRCode(x, y, size, data)
        }
        "printBitmap" -> {
          val x = params?.get("x") as Int
          val y = params?.get("y") as Int

          val bytes: ByteArray =params?.get("bitmap") as? ByteArray?:ByteArray(0)
          val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)

          val width = params?.get("width") as Int
          printer.printBitmap(x, y, bitmap, width, AlgorithmType.Threshold)
        }
        "printBmpCompress" -> {
          val x = params?.get("x") as Int
          val y = params?.get("y") as Int
          val bytes: ByteArray =params?.get("bitmap") as? ByteArray?:ByteArray(0)
          val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
          val width = params?.get("width") as Int
          printer.printBmpCompress(x, y, bitmap, width, AlgorithmType.Threshold)
        }
        "downloadBitmap" -> {
          val width = params?.get("width") as Int
          val bmpName = params?.get("bmpName") as String
          val bytes: ByteArray =params?.get("bitmap") as? ByteArray?:ByteArray(0)
          val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
          printer.downloadBitmap(width, bmpName, bitmap)
        }
        "useDownloadBitmap" -> {
          val x = params?.get("x") as Int
          val y = params?.get("y") as Int
          val bmpName = params?.get("bmpName") as String
          val mx = params?.get("mx") as Int
          val my = params?.get("my") as Int
          printer.addBitmap(x, y, bmpName, mx, my)
        }
        "addPrintCount" -> {
          val count = params?.get("count") as Int
          printer.addPrintCount(count)
        }
        "setPrintSpeed" -> {
          val speed = params?.get("speed") as Int
          printer.setPrintSpeed(speed)
        }
        "setPrintOrientation" -> {
          val orientation = params?.get("orientation") as String
          printer.setPrintOrientation(orientation)
        }
        "setPrintDensity" -> {
          val density = params?.get("density") as Int
          printer.setPrintDensity(density)
        }
        "setCharSet" -> {
          val charSet = params?.get("charSet") as String
          printer.setCharSet(charSet)
        }
        else -> {
          // Handle unknown methods if necessary
        }
      }
    }
  }



  private fun connectBt(call: MethodCall, result: Result) {
    val address = (call.argument("address") as String?)!!
    Log.i(TAG, "address:$address")
    connect?.close()
    connect = POSConnect.createDevice(POSConnect.DEVICE_TYPE_BLUETOOTH)
    connect!!.connect(address, connectListener)
    result.success(null)
  }

  private fun connectNet(call: MethodCall, result: Result) {
    val address = (call.argument("address") as String?)!!
    Log.i(TAG, "address:$address")
    connect?.close()
    connect = POSConnect.createDevice(POSConnect.DEVICE_TYPE_ETHERNET)
    connect!!.connect(address, connectListener)
    result.success(null)
  }

  private val connectListener = IPOSListener { code, msg ->
    when (code) {
      POSConnect.CONNECT_SUCCESS -> {
        Log.i(TAG, "connect success")
        channel.invokeMethod(
          "connectRet",
          mapOf("result" to 0)
        )
      }
      POSConnect.CONNECT_FAIL -> {
        Log.i(TAG, "connect fail")
        channel.invokeMethod(
          "connectRet",
          mapOf("result" to -1)
        )
        connect = null
      }
      POSConnect.CONNECT_INTERRUPT -> {
        Log.i(TAG, "connect interrupt")
        channel.invokeMethod(
          "connectRet",
          mapOf("result" to -2)
        )
        connect = null
      }
    }
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addRequestPermissionsResultListener { requestCode, permissions, grantResults ->
      if (requestCode == PERMISSION_REQUEST_CODE) {
        if (grantResults.isNotEmpty() && grantResults.all { it == PackageManager.PERMISSION_GRANTED }) {
          // All permissions are granted
          permissionResult?.success(true)
          Log.i(TAG, "All permissions are granted")
        } else {
          // Permissions are denied
          permissionResult?.error("Permissions denied", "Required permissions are not granted", null)
        }
        permissionResult = null
        true
      } else {
        false
      }
    }
  }

  private fun checkPermissions(result: Result) {
    activity?.let {
      if (ContextCompat.checkSelfPermission(it, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
        permissionResult = result // Store the result to use later in the callback
        val permissions: Array<String> = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
          arrayOf(
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.BLUETOOTH_SCAN,
            Manifest.permission.BLUETOOTH_CONNECT,
            Manifest.permission.BLUETOOTH_ADVERTISE
          )
        } else {
          arrayOf(
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION
          )
        }

        ActivityCompat.requestPermissions(it, permissions, PERMISSION_REQUEST_CODE)
      } else {
        result.success(true)
      }
    } ?: run {
      result.error("Activity not available", "Cannot check permissions without activity", null)
    }
  }

  private fun startScan(result: Result) {
    bluetoothAdapter?.let {
      val filter = IntentFilter(BluetoothDevice.ACTION_FOUND)
      context.registerReceiver(receiver, filter)
      if (it.isDiscovering) {
        it.cancelDiscovery()
        Handler(Looper.getMainLooper()).postDelayed({
          it.startDiscovery()
          result.success(null)
        }, 300)
      } else {
        it.startDiscovery()
        result.success(null)
      }
    } ?: run {
      result.error("Bluetooth not supported", "This device does not support Bluetooth", null)
    }
  }

  private val receiver = object : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
      if (BluetoothDevice.ACTION_FOUND == intent.action) {
        val device: BluetoothDevice? = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
        device?.name?.let { name ->
          device?.address?.let { address ->
            channel.invokeMethod(
              "searchBt",
              mapOf(address to name)
            )
          }
        }
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }
}
