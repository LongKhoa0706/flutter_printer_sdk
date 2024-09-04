import 'package:flutter/material.dart';
import 'bt_search_view.dart';
import 'tspl_demo_view.dart';
import 'pos_demo_view.dart';
import 'package:flutter_printer_sdk/printer_manager.dart';
import 'connect_usb_view.dart';
import 'zpl_demo_view.dart';
import 'dart:io'; // Import the dart:io package to check the platform
import 'pdf_view_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Printer SDK',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DeviceControlPage(),
    );
  }
}

class DeviceControlPage extends StatefulWidget {
  @override
  _DeviceControlPageState createState() => _DeviceControlPageState();
}

class _DeviceControlPageState extends State<DeviceControlPage> {
  String _selectedConnectionType = 'BT'; // Default selected connection type
  String _connectedDeviceName = 'Select device'; // Currently connected device name
  final PrinterManager _printerManager = PrinterManager();
  bool _isConnect = false;
  final TextEditingController _netDeviceController = TextEditingController();

  List<String> connectionTypes = Platform.isAndroid
      ? ['BT', 'NET', 'USB'] // Android: include USB
      : ['BT', 'NET'];       // iOS: exclude USB

  static void showToast(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 1000),
      content: Text(msg),
    ));
  }

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  connectToast(int result) {
    if (result == 0) {
      showToast("connect success", context);
      _isConnect = true;
      setState(() {});
    } else if (result == -1) {
      showToast("connect fail", context);
      _isConnect = false;
      setState(() {});
    } else if (result == -2) {
      showToast("connect interrupt", context);
      _isConnect = false;
      setState(() {});
    }
  }

  Future<void> _checkPermissions() async {
    bool result = await _printerManager.checkPermissions();
    if (result) {
      print("Permission success, startScan");
    } else {
      print("Permission denied");
    }
  }

  void _selectDevice() {
    if (_selectedConnectionType == 'BT') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BtSearchView(),
        ),
      ).then((selectedName) {
        if (selectedName != null) {
          setState(() {
            _connectedDeviceName = selectedName;
          });
        }
      });
    } else if (_selectedConnectionType == 'USB') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConnectUsbView(),
        ),
      ).then((selectedName) {
        if (selectedName != null) {
          setState(() {
            _connectedDeviceName = selectedName;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Printer Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text("Connect method"),
                SizedBox(width: 20.0),
                DropdownButton<String>(
                  value: _selectedConnectionType,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedConnectionType = newValue!;
                      _connectedDeviceName = 'Select device'; // Reset the device name when changing connection type
                    });
                  },
                  items: connectionTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ],
            ),
            SizedBox(height: 16.0),
            if (_selectedConnectionType == 'NET')
              TextField(
                controller: _netDeviceController,
                decoration: InputDecoration(
                  labelText: 'Enter device address',
                ),
                onChanged: (text) {
                  setState(() {
                    //_connectedDeviceName = text;
                  });
                },
              )
            else
              ElevatedButton(
                onPressed: _selectDevice,
                child: Text(_connectedDeviceName),
              ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                if (_connectedDeviceName != 'Select device') {
                  if (_selectedConnectionType == 'BT') {
                    print("connect BT");
                    _printerManager.connectBt(_connectedDeviceName, (result) {
                      connectToast(result);
                    });
                  } else if (_selectedConnectionType == 'USB') {
                    _printerManager.connectUsb(_connectedDeviceName, (result) {
                      connectToast(result);
                    });
                  }
                }

                if (_netDeviceController.text.length > 0) {
                  if (_selectedConnectionType == 'NET') {
                    print("connect NET");
                    _printerManager.connectNet(_netDeviceController.text, (result) {
                      connectToast(result);
                    });
                  }
                }

              },
              child: Text('Connect'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: (_isConnect)
                  ? () {
                setState(() {
                  _printerManager.disconnect();
                  _isConnect = false;
                });
              }
                  : null,
              child: Text('Disconnect'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: (_isConnect)
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TSPLDemoView()),
                );
              }
                  : null,
              child: Text('TSPL Demo'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: (_isConnect)
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ZPLDemoView()),
                );
              }
                  : null,
              child: Text('ZPL Demo'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: (_isConnect)
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => POSDemoView()),
                );
              }
                  : null,
              child: Text('POS Demo'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: (_isConnect)
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PDFViewPage()),
                );
              }
                  : null,
              child: Text('PDF Demo'),
            ),
          ],
        ),
      ),
    );
  }
}
