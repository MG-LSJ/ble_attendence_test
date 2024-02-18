import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> checkBluetoothPermissions() async {
  if (Platform.isAndroid) {
    // var permission = await Permission.location.request();
    var bleScan = await Permission.bluetoothScan.request();
    var bleConnect = await Permission.bluetoothConnect.request();
    var bleAdvertise = await Permission.bluetoothAdvertise.request();
    // var locationWhenInUse = await Permission.locationWhenInUse.request();

    // print('location permission: ${permission.isGranted}');
    print('bleScan permission: ${bleScan.isGranted}');
    print('bleConnect permission: ${bleConnect.isGranted}');
    print('bleAdvertise permission: ${bleAdvertise.isGranted}');
    // print('location locationWhenInUse: ${locationWhenInUse.isGranted}');
    return bleScan.isGranted && bleConnect.isGranted && bleAdvertise.isGranted;
  }
  return false;
}

Future<bool> isBluetoothOn(BuildContext context) async {
  var status = await Permission.bluetooth.serviceStatus.isEnabled;

  var RETURN_VALUE = status;

  print('bluetooth status: $status');
  if (RETURN_VALUE) {
    return RETURN_VALUE;
  } else {
    if (!context.mounted) return false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Bluetooth is off'),
        content: const Text('App needs bluetooth to work! Please turn it on.'),
        actions: [
          TextButton(
            onPressed: () {
              // dismiss the dialog
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await AppSettings.openAppSettings(
                type: AppSettingsType.bluetooth,
              );
            },
            child: const Text('Open Settings'),
          ),
          TextButton(
            onPressed: () async {
              if (await Permission.bluetooth.serviceStatus.isEnabled) {
                Navigator.of(context).pop();
                RETURN_VALUE = true;
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Please turn on bluetooth to mark your attendance'),
                  ),
                );
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  return RETURN_VALUE;
}
