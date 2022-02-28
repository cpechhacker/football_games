import 'dart:async';
import 'package:flutter/material.dart';
import 'BleDeviceSelectionWidget.dart';
import 'package:icon_badge/icon_badge.dart';

import "dart:typed_data"; // für Darstellung von floats to bytes , ...

enum GameEventType { bluetoothReceived, timer }

class BleListen extends StatefulWidget {
  @override
  _BleListen createState() => _BleListen();
}

class _BleListen extends State {

  List sensorData = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => _initializeBleDevices());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('Bluetooth Werte auslesen'),

      ),

      body: Container(
        child: Center(

          // Todo: Modularize this Select random Colors widget
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              IconBadge(
                icon: Icon(Icons.account_circle_rounded),
                itemCount: bleDevices.length,
                badgeColor: Colors.red,
                itemColor: Colors.white,
                hideZero: true,
                // onTap: () {
                //   print('test');
                // },
              ),


              Text("Sensor Data: $sensorData"),

            ],
          ),
        ),
      ),
    );
  }



  void _initializeBleDevices() {
    print("Available devices: ${bleDevices.length}");

    bleDevices.forEach(
            (device) => device.tx.value.listen((value) => _onEvent(GameEventType.bluetoothReceived, device, value)));
  }

  void _onEvent(GameEventType type, BleDevice device, List<int> bluetoothData) {
    //print("#####################");
    print("Sensor Data:");
    print(bluetoothData);
    Uint8List intBytes = Uint8List.fromList(bluetoothData.toList());
    List<double> floatList = intBytes.buffer.asFloat32List();
    print(floatList);
    }


}





