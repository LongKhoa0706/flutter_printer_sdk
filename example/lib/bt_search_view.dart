import 'package:flutter/material.dart';
import 'package:flutter_printer_sdk/printer_manager.dart';

class BtSearchView extends StatefulWidget {
  @override
  _BtSearchViewState createState() => _BtSearchViewState();
}

class _BtSearchViewState extends State<BtSearchView> {
  final PrinterManager _printerManager = PrinterManager();
  List<Map> _devices = [];
  String _address = "";

  @override
  void initState() {
    super.initState();
    _printerManager.startScan();
    _printerManager.searchCallback = (Map arguments){
      if (!isExist(arguments)) _devices.add(arguments);
      setState(() {
      });
    };
  }

  bool isExist(Map args) {
    for (Map value in _devices) {
      if (value.keys.first == args.keys.first) {
        return true;
      }
    }

    return false;
  }

  Future<void> _startScan() async {
    _devices.clear();
    _printerManager.startScan();
  }

  Future<void> _connectToDevice() async {
    Navigator.pop(context, _address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _startScan,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _devices.length,
        itemBuilder: (context, index) {
          String? address = _devices[index].keys.first;
          String name = _devices[index].values.first;
          return ListTile(
            title: Text(name),
            subtitle: Text(address!),
            onTap: () {
              _address = address;
              _connectToDevice();
            },
          );
        },
      ),
    );
  }
}
