import 'dart:async';
import 'dart:convert';

import 'package:attendance_app/utils/constants.dart';
import 'package:attendance_app/utils/models.dart';
import 'package:attendance_app/utils/permissions.dart';
import 'package:ble_peripheral/ble_peripheral.dart';
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
  List<String> _events = [];
  final _eventStreamController = StreamController<String>();
  final ScrollController _eventsScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeBluetooth();
  }

  @override
  void dispose() {
    _eventStreamController.close();
    BlePeripheral.stopAdvertising();
    _clearLog();
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  width: double.infinity,
                  child: ListView.builder(
                    itemBuilder: (context, index) => ListTile(
                      leading: Text(
                        "${index + 1}.",
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      title: Text(
                        _events[index],
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    itemCount: _events.length,
                    controller: _eventsScrollController,
                  ),
                ),
              ),
            )
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
          )
        ],
      ),
    );

    BlePeripheral.setBleCentralAvailabilityCallback(
        (String deviceId, bool isAvailable) {
      _addEvent("OnDeviceAvailabilityChange: $deviceId : $isAvailable");
    });

    // Android only, Called when central connected
    BlePeripheral.setConnectionStateChangeCallback(
        (String deviceId, bool isAvailable) {
      _addEvent("OnConnectionStateChange: $deviceId : $isAvailable");
    });

    // Apple only, Called when central subscribes to a characteristic
    BlePeripheral.setCharacteristicSubscriptionChangeCallback(
        (String deviceId, String characteristicId, bool isSubscribed) {
      _addEvent(
          "OnCharacteristicSubscriptionChange: $deviceId $characteristicId : $isSubscribed");
    });

    // Called when advertisement started/failed
    BlePeripheral.setAdvertingStartedCallback((String? error) {
      if (error != null) {
        _addEvent("AdvertisingFailed: $error");
      } else {
        _addEvent("AdvertingStarted");
      }
    });

    // Called when Central device tries to read a characteristics
    BlePeripheral.setReadRequestCallback(
        (deviceId, characteristicId, offset, value) {
      _addEvent("ReadRequest: $deviceId $characteristicId : $offset : $value");

      if (characteristicId == SERVICE_ID) {
        return ReadRequestResult(value: utf8.encode("id:${USER?.id}"));
      }
      return ReadRequestResult(value: utf8.encode(""));
    });

    // When central tries to write to a characteristic
    BlePeripheral.setWriteRequestCallback(
        (deviceId, characteristicId, offset, value) {
      _addEvent("WriteRequest: $deviceId $characteristicId : $offset : $value");
      if ((characteristicId == SERVICE_ID) && value != null) {
        _addEvent(String.fromCharCodes(value));
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

    // Called when service added successfully
    BlePeripheral.setServiceAddedCallback((String serviceId, String? error) {
      if (error != null) {
        _addEvent("ServiceAddFailed: $error");
      } else {
        _addEvent("ServiceAdded: $serviceId");
      }
    });
  }

  // add the event
  void _addEvent(String event) {
    setState(() {
      _events.add(event);
    });
    print("-----> BLE Event: $event");
    _eventsScrollController
        .jumpTo(_eventsScrollController.position.maxScrollExtent);
  }

  // clear the log
  void _clearLog() {
    setState(() {
      _events.clear();
    });
  }
}
