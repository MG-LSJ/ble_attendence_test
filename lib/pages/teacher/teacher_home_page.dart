import 'dart:async';
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
  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;
  late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;

  @override
  void initState() {
    super.initState();

    _scanResultsSubscription = FlutterBluePlus.onScanResults.listen(
      (results) {
        if (results.isNotEmpty) {
          _scanResults = results;
          setState(() {});
        }
      },
      onError: (e) => print(e),
    );

    _isScanningSubscription = FlutterBluePlus.isScanning.listen(
      (isScanning) {
        _isScanning = isScanning;
        setState(() {});
      },
      onError: (e) => print(e),
    );
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    _adapterStateSubscription.cancel();

    super.dispose();
  }

  Future _startScan() async {
    try {
      _systemDevices = await FlutterBluePlus.systemDevices;
      await FlutterBluePlus.startScan(
        continuousUpdates: true,
        oneByOne: true,
        withServices: [Guid(SERVICE_ID)],
        removeIfGone: const Duration(seconds: 1),
        androidScanMode: AndroidScanMode.lowLatency,
      );
    } catch (e) {
      print(e);
    }
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
                onPressed: _startScanning,
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

  void _startScanning() async {
    // first, check if bluetooth is supported by your hardware
    // Note: The platform is initialized on the first call to any FlutterBluePlus method.
    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return;
    }

    // handle bluetooth on & off
    // note: for iOS the initial state is typically BluetoothAdapterState.unknown
    // note: if you have permissions issues you will get stuck at BluetoothAdapterState.unauthorized
    var subscription =
        FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      print(state);
      if (state == BluetoothAdapterState.on) {
        // usually start scanning, connecting, etc
      } else {
        // show an error to the user, etc
      }
    });

    // turn on bluetooth ourself if we can
    // for iOS, the user controls bluetooth enable/disable
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }

    // cancel to prevent duplicate listeners
    subscription.cancel();
  }
}
