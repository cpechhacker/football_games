/*Dieses Spiel soll Touch Events erkennen und die Events zählen. Für jedes Event steht nur ein begrenzter Countdown zur Verfügung.
ToDo: Dieser Countdown sollte variable sein.
* */

//ToDO: Make this code more modular / reusable widgets

import 'dart:async';
import 'package:flutter/material.dart';
import 'BleDeviceSelectionWidget.dart';
import 'dart:math';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:icon_badge/icon_badge.dart';

enum GameEventType { bluetoothReceived, timer }

class TouchDetectCountdown extends StatefulWidget {
  @override
  _TouchDetectCountdown createState() => _TouchDetectCountdown();
}

class _TouchDetectCountdown extends State {

  List<Color> currentColors = [Color.fromRGBO(255, 0, 0, 0.4)];
  Color randColor = Color.fromRGBO(255, 0, 0, 0.4);
  Random _random = Random();

  int eventCounter = -1; // starte bei -1 damit BLE initialisiert werden kann

  double StopwatchCounterInitial = 10;
  double StopwatchDecreaseTime = 1;

  bool? checkboxValue = false;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: StopWatchTimer.getMilliSecFromSecond(7) // ToDo: Make this statement dynamic
  ); // Create instance.

  @override
  void initState() {
    // super.initState();
    Future.delayed(Duration.zero, () => _initializeBleDevices());

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('Touch Detect Countdown'),

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

              RaisedButton(
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
                                Color.fromRGBO(255, 0, 255, 0.4),
                                Color.fromRGBO(155, 103, 60, 0.4),
                              ]),
                        ),
                      );
                    },
                  );
                },
                child: const Text('Wähle mögliche Farben'),
                color: randColor, // currentColors[0],
                textColor: useWhiteForeground(currentColors[0]) ? const Color(0xffffffff) : const Color(0xff000000),

              ),

              ElevatedButton(
                onPressed: _sendRandomColourFromList, child: Text("Send Color to All Devices"),
              ),

              CheckboxListTile(
                title: Text("Betrachte Button - Press als Event!"),
                value: checkboxValue,
                onChanged: (newValue) {
                  setState(() {
                    checkboxValue = newValue;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
              ),


              Slider(
                min: 0.0,
                max: 30.0,
                value: StopwatchCounterInitial,
                divisions: 30,
                activeColor: Colors.green,
                inactiveColor: Colors.green[100],
                label: '${StopwatchCounterInitial.round()}',
                onChanged: (value) {
                  setState(() {
                    StopwatchCounterInitial = value;
                  });
                },
              ),

              Text("Anzahl Events: $eventCounter"),


              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  // initialData: _stopWatchTimer.rawTime.value,
                  builder: (context, snap) {
                    final value = snap.data!;
                    final displayTime =
                    StopWatchTimer.getDisplayTime(value, hours: false);
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            displayTime,
                            style: const TextStyle(
                                fontSize: 40,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ElevatedButton(
                            onPressed: _resetGame,
                            child: const Text(
                              'Reset',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
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

  // ToDo: Bereits wenn ich diesen Screen aufmache, wird _onEvent aufgerufen und die Stoppuhr gesetzt. Warum? wegen _initializeBleDevices ?
  void _onEvent(GameEventType type, BleDevice device, List<int> bluetoothData) {
    print("Event detected! \n Send new colour");
    print(bluetoothData);

    var col_selected = _randomColor();
    // setState(() {
    //   randColor = col_selected;
    // });

    if(eventCounter > 0 && _stopWatchTimer.isRunning == false) {
      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
      _sendBleDataToAllDevices(red: 255, green: 150, blue: 0, wait: 5);
    } else {
      setState(() {
        eventCounter++;
        print("Event Counter: $eventCounter");
      });


      // _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
      _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);

      // ToDo: Event Time sollte sich jedes Mal um Faktor StopwatchDecreaseTime verkürzen -> Problem mit _stopWatchTimer.setPresetTime
      // int PresetTime = ( StopwatchCounterInitial * 1000 - (StopwatchDecreaseTime * eventCounter * 1000)).round();
      int PresetTime = (StopwatchCounterInitial * 1000).round();
      print("Event Time: $PresetTime");
      _stopWatchTimer.setPresetTime(mSec: PresetTime);  //  Can be not set preset time because of timer is not reset. please reset timer.

      // ToDO: Einbauen PresetTime in wait. Allerdings muss auch Python Code umgeschrieben werden, und Acht geben auf Bytes:
      _sendBleDataToAllDevices(red: col_selected.red, green: col_selected.green, blue: col_selected.blue, wait: 3);
    }


  }

  void changeColors(List<Color> colors) {
    print("Aktuelle Farben:");
    print(currentColors);
  }

  void _sendRandomColourFromList({Color? color, int waitingTimeInt: 1}) {
    Color color = _randomColor();

    _sendBleDataToAllDevices(red: color.red, green: color.green, blue: color.blue, wait: waitingTimeInt);
  }


  Color _randomColor() {
    print(currentColors);
    int randColorId = _random.nextInt(currentColors.length);
    randColor = currentColors[randColorId];

    print("Random colour is:");
    print(randColor);

    // setState(() {
    //   randColor = randColor;
    // });

    return randColor;
  }

  void _sendBleDataToAllDevices({int red: 250, int green: 30, int blue: 50, int wait: 1}) {  // double wait: 1

    for (int i = 0; i < bleDevices.length; i++) {
      _sendBleDataToDevice(i, red: red, green: green, blue: blue, wait: wait); //
    }


    // bleDevices.forEach((device) {
    //   // _sendBleDataToDevice(i, red: red, green: green, blue: blue, wait: wait); //
    //   // Do something for alle devices.
    // });
  }

// Todo let waiting time be a double -> problems with device.rx.write
  void _sendBleDataToDevice(int deviceNumber, {int red: 250, int green: 30, int blue: 50, int wait: 1}) {

    var data = [red, green, blue, wait];
    print("Send Following Information:");
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


  void _resetGame() {
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    _sendBleDataToAllDevices(red: 0, green: 0, blue: 0, wait: 0);

    setState(() {
      eventCounter = 0;
    });
  }



}



