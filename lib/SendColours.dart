import 'package:flutter/material.dart';
import 'BleDeviceSelectionWidget.dart';
import 'SelectColours.dart';
import 'dart:math';

Random _random = Random();

class SendColours extends StatefulWidget {
  @override
  _SendColours createState() => _SendColours();
}

class _SendColours extends State<SendColours> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
        children: [
          ElevatedButton(
            onPressed: _sendRandomColourFromList, child: Text("Send Color to All Devices"),
            ),

          RaisedButton(
            onPressed: _do_something, child: Text("Mach noch irgendwas"),
          )
          ]
        )
      )
    );


  }

  void _do_something() {

  }

  void _sendRandomColourFromList({Color? color, int waitingTimeInt: 1}) {
    //var waitingTimeInt = sliderVal.toInt();
    Color color = _randomColor();

    _sendBleDataToAllDevices(red: color.red, green: color.green, blue: color.blue, wait: waitingTimeInt);
  }


  Color _randomColor() {
    print(currentColors);
    int randColorId = _random.nextInt(currentColors.length);
    randColor = currentColors[randColorId];

    print("Random colour is:");
    print(randColor);

    // To Do: Farbe von Button "Wähle mögliche Farbe" soll Farbe von LED anzeigen
    setState(() {
      randColor = randColor;
    });


    return randColor;
  }

  void _sendBleDataToAllDevices({int red: 250, int green: 30, int blue: 50, int wait: 1}) {  // double wait: 1
    print("Schleife2!");
    print(bleDevices.length);

    for (int i = 0; i < bleDevices.length; i++) {
      _sendBleDataToDevice(i, red: red, green: green, blue: blue, wait: wait); //
    }
    print("Schleife2 ferig!");

    // bleDevices.forEach((device) {
    //   // _sendBleDataToDevice(i, red: red, green: green, blue: blue, wait: wait); //
    //   // Do something for alle devices.
    // });
  }

// Todo let waiting time be a double -> problems with device.rx.write
  void _sendBleDataToDevice(int deviceNumber, {int red: 250, int green: 30, int blue: 50, int wait: 1}) {
    print("Now here");
    var data = [red, green, blue, wait];
    print("Colors send:");
    print(data);

    if (deviceNumber <= bleDevices.length) {
      var device = bleDevices[deviceNumber];
      try {
        device.rx.write(data, withoutResponse: true);
      } catch (e) {
        print("CP: Could not send color to device: $e");
      }
    } else {
      print("This device ($deviceNumber) doesn't exist.");
    }
  }

}


