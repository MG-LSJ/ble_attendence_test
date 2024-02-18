import 'dart:convert';

import 'package:attendance_app/utils/constants.dart';
import 'package:attendance_app/utils/models.dart';
import 'package:attendance_app/utils/permissions.dart';
import 'package:ble_peripheral/ble_peripheral.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StudentAttedenceButtom extends StatelessWidget {
  const StudentAttedenceButtom({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        if (await checkBluetoothPermissions()) {
          if (await isBluetoothOn(context)) {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (context, state) {
                    return const StudentAttendanceBottomSheet();
                  },
                );
              },
              // isDismissible: false,
              showDragHandle: true,
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "Please give Bluetooth permissions to mark your attendance"),
            ),
          );
        }
      },
      label: const Text("Present"),
      icon: const Icon(Icons.check),
    );
  }
}

class StudentAttendanceBottomSheet extends StatefulWidget {
  const StudentAttendanceBottomSheet({super.key});

  @override
  State<StudentAttendanceBottomSheet> createState() =>
      _StudentAttendanceBottomSheetState();
}

class _StudentAttendanceBottomSheetState
    extends State<StudentAttendanceBottomSheet> {
  @override
  void initState() {
    super.initState();
    _initializeBluetooth();
  }

  @override
  void dispose() {
    BlePeripheral.stopAdvertising();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Mark Attendence in Class',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FilledButton(
              onPressed: _toggleAdvertising,
              style: FilledButton.styleFrom(
                elevation: 0,
                minimumSize: Size(
                  MediaQuery.of(context).size.width * 0.75,
                  60,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              child: _isAdvertising
                  ? CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.surface,
                    )
                  : const Text(
                      "Mark Attendence",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isAdvertising = false;

  void _toggleAdvertising() async {
    if (!_isAdvertising) {
      await BlePeripheral.startAdvertising(
        services: [SERVICE_ID],
        localName: "SA",
      );
      _isAdvertising = true;
    } else {
      await BlePeripheral.stopAdvertising();
      _isAdvertising = false;
    }
    setState(() {});
  }

  void _initializeBluetooth() async {
    await BlePeripheral.initialize();

    var notificationControlDescriptor = BleDescriptor(
      uuid: SERVICE_ID,
      value: Uint8List.fromList([0, 1]),
      permissions: [
        AttributePermissions.readable.index,
        AttributePermissions.writeable.index
      ],
    );

    await BlePeripheral.addService(
      BleService(
        uuid: SERVICE_ID,
        primary: true,
        characteristics: [
          BleCharacteristic(
            uuid: SERVICE_ID,
            properties: [
              CharacteristicProperties.read.index,
              CharacteristicProperties.write.index,
            ],
            permissions: [
              AttributePermissions.readable.index,
              AttributePermissions.writeable.index,
            ],
            value: null,
            descriptors: [notificationControlDescriptor],
          )
        ],
      ),
    );

    BlePeripheral.setAdvertingStartedCallback((String? error) {
      if (error != null) {
        print("AdvertisingFailed: $error");
      } else {
        print("AdvertingStarted");
      }
    });
    BlePeripheral.setReadRequestCallback(
        (deviceId, characteristicId, offset, value) {
      print("ReadRequest: $deviceId $characteristicId : $offset : $value");

      if (characteristicId == SERVICE_ID) {
        return ReadRequestResult(value: utf8.encode("id:${USER?.id}"));
      }
      return ReadRequestResult(value: utf8.encode(""));
    });

    BlePeripheral.setWriteRequestCallback(
        (deviceId, characteristicId, offset, value) {
      print("WriteRequest: $deviceId $characteristicId : $offset : $value");
      if ((characteristicId == SERVICE_ID) && value != null) {
        print(String.fromCharCodes(value));
        if (String.fromCharCodes(value) == "OK") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Attendance Marked"),
            ),
          );
          Navigator.of(context).pop();
        }
      }
      return null;
    });
  }
}
