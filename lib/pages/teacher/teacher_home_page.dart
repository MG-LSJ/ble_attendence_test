import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:attendance_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  final ScrollController _idScrollController = ScrollController();
  List<String> _detectedIds = [];
  List<BluetoothDevice> discoveredDevices = [];
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Dash"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: scanButtonClick,
                child: const Text("Start Scanning"),
              ),
              const Text(
                "Detected IDs: ",
                style: TextStyle(fontSize: 20),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                height: MediaQuery.of(context).size.height * 0.5,
                child: ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      _detectedIds[index],
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  itemCount: _detectedIds.length,
                  controller: _idScrollController,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void scanButtonClick() {
    if (_isScanning) {
      stopScanning();
    } else {
      startScanning();
    }
  }

  void startScanning() async {
    FlutterBluePlus.onScanResults.listen(
      (List<ScanResult> results) async {
        if (results.isNotEmpty) {
          for (ScanResult result in results) {
            print(
                'Device found: ${result.device.remoteId}: ${result.advertisementData.advName} found');
            if (!discoveredDevices.contains(result.device)) {
              discoveredDevices.add(result.device);
              await connectToDevice(result.device);
            }
          }
        }
      },
      onError: (e) => print(e),
    );

    await FlutterBluePlus.startScan(
      withServices: [Guid(SERVICE_ID)],
    );
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();

    // Discover services
    List<BluetoothService> services = await device.discoverServices();

    for (BluetoothService service in services) {
      if (service.uuid.toString() == SERVICE_ID) {
        // Discover characteristics
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.uuid.toString() == SERVICE_ID) {
            // Read the characteristic value
            List<int> value = await characteristic.read();
            print('Value: ${utf8.decode(value)}');
            _detectedIds.add(utf8.decode(value));
            setState(() {});
            _idScrollController.jumpTo(
              _idScrollController.position.maxScrollExtent,
            );
          }
        }
      }
    }
    // Once connected, you can perform operations on the device.
    await device.disconnect();
  }

  void stopScanning() async {
    await FlutterBluePlus.stopScan();
  }
}
