import 'dart:math';
import 'package:flutter/material.dart';
import 'BleDeviceSelectionWidget.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

List<Color> currentColors = [Color.fromRGBO(255, 0, 0, 0.4)];
Color randColor = Color.fromRGBO(255, 0, 0, 0.4);
Random _random = Random();

Widget buildColours(BuildContext context) {
  return RaisedButton(
    elevation: 3.0,
    onPressed: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select random colors'),
            content: SingleChildScrollView(
              child: MultipleChoiceBlockPicker(
                  pickerColors: currentColors,
                  onColorsChanged: changeColors,
                  availableColors: [

                    Color.fromRGBO(0, 0, 0, 0.4),
                    Color.fromRGBO(255, 255, 255, 0.4),
                    Color.fromRGBO(255, 0, 0, 0.4),
                    Color.fromRGBO(0, 255, 0, 0.4),
                    Color.fromRGBO(0, 0, 255, 0.4),
                    Color.fromRGBO(255, 136, 0, 1),
                    Color.fromRGBO(0, 255, 255, 0.4),
                    Color.fromRGBO(255, 255, 0, 0.4),
                    Color.fromRGBO(255, 0, 255, 0.4)
                  ]),
            ),
          );
        },
      );
    },
    child: const Text('Wähle mögliche Farben'),
    color: randColor, // currentColors[0],
    textColor: useWhiteForeground(currentColors[0]) ? const Color(0xffffffff) : const Color(0xff000000),

  );
}

Widget sendColours() {
  return RaisedButton(
    child: Text("Send Color to All Devices"),
    onPressed: _sendRandomColourFromList,
    color: Colors.white,
    textColor: Colors.blue,
    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
    splashColor: Colors.grey,
  );
}

// ToDo: set Sate for  randColor -> Ziel: Auch in App soll die aktuelle Farbe angezeigt werden. Und die Farbe sollte bei Event (Touch) auch geändert werden
void changeColors(List<Color> colors) {
  print(currentColors);
}

void _sendRandomColourFromList() {
}

// void _sendRandomColourFromList({Color color, int waitingTimeInt: 1}) {
//   //var waitingTimeInt = sliderVal.toInt();
//   Color color = _randomColor();
//   _sendBleDataToAllDevices(red: color.red, green: color.green, blue: color.blue, wait: waitingTimeInt);
// }

Color _randomColor() {
  print(currentColors);
  int randColorId = _random.nextInt(currentColors.length);
  randColor = currentColors[randColorId];

  return randColor;
}

void _sendBleDataToAllDevices({int red: 250, int green: 30, int blue: 50, int wait: 1}) {  // double wait: 1
  for (int i = 0; i < bleDevices.length; i++) {
    _sendBleDataToDevice(i, red: red, green: green, blue: blue, wait: wait); //
  }

  bleDevices.forEach((device) {
    // _sendBleDataToDevice(i, red: red, green: green, blue: blue, wait: wait); //
    // Do something for alle devices.
  });
}

// Todo let waiting time be a double -> problems with device.rx.write
void _sendBleDataToDevice(int deviceNumber, {int red: 250, int green: 30, int blue: 50, int wait: 1}) {
  var data = [red, green, blue, wait];

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