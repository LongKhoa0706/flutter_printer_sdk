
import 'package:flutter/material.dart';
import 'package:flutter_printer_sdk/printer_manager.dart';

class ConnectUsbView extends StatefulWidget {
  const ConnectUsbView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ConnectUsbState();
  }
}

class _ConnectUsbState extends State<ConnectUsbView> {
  List<String> usbPath = <String>[];
  final PrinterManager _printerManager = PrinterManager();

  @override
  void initState() {
    super.initState();
    _loadUsbPaths();
  }

  Future<void> _loadUsbPaths() async {
    final list = await _printerManager.getUsbPaths();
    usbPath.clear();
    usbPath.addAll(list.cast<String>());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('USB Devices'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                _loadUsbPaths();
              },
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: usbPath.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 16,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return MaterialButton(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  onPressed: () {
                    Navigator.pop(context, usbPath[index]);
                  },
                  child: Text(usbPath[index]),
                );
              })
        ));
  }
}
