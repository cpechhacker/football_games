import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '/HomeWidget.dart';
import 'VolumeControl.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var title = 'BLE RGB Lamp';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return HomeWidget();   // return HomeWidget();
            }
            return HomeWidget(); // BluetoothOffScreen(state: state);  // CP: HomeWidget();
          }),

    );
  }
}


// Shown if bluetooth is turned off.
class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        title: Text("Bluetooth Off"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              // style: Theme.of(context).primaryTextTheme.subhead.copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}