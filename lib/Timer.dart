import 'dart:async';
import 'package:flutter/material.dart';
import 'BleDeviceSelectionWidget.dart';
import 'dart:math';
import 'package:flutter_spinbox/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';


enum GameEventType { bluetoothReceived, timer }

class TouchDetect extends StatefulWidget {
  @override
  _TouchDetect createState() => _TouchDetect();
}

class _TouchDetect extends State {

  List<Color> currentColors = [Color.fromRGBO(255, 0, 0, 0.4)];
  Color randColor = Color.fromRGBO(255, 0, 0, 0.4);
  Random _random = Random();

  int eventCounter = 0;
  int maximumEvents = 10;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(); // Create instance.

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
        title: Text('Touch Detect'),
      ),

      body: Container(
        child: Center(

          // Todo: Modularize this Select random Colors widget
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

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

              ),

              ElevatedButton(
                onPressed: _sendRandomColourFromList, child: Text("Send Color to All Devices"),
              ),

              SpinBox(
                min: 1,
                max: 20,
                value: 10,
                onChanged: (setGamesCount) => setMaxEvents(setGamesCount),
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

              //SelectColours(),
              //SendColours(),

              // buildColours(context),
              // sendColours(),

              // Text('Event Time next event: $waitingTimeInt'),
              //
              // SliderTheme(
              //     data: SliderTheme.of(context).copyWith(
              //       activeTrackColor: Colors.red[700],
              //       inactiveTrackColor: Colors.red[100],
              //       trackShape: RoundedRectSliderTrackShape(),
              //       trackHeight: 4.0,
              //       thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
              //       thumbColor: Colors.redAccent,
              //       overlayColor: Colors.red.withAlpha(32),
              //       overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
              //       tickMarkShape: RoundSliderTickMarkShape(),
              //       activeTickMarkColor: Colors.red[700],
              //       inactiveTickMarkColor: Colors.red[100],
              //       valueIndicatorShape: PaddleSliderValueIndicatorShape(),
              //       valueIndicatorColor: Colors.redAccent,
              //       valueIndicatorTextStyle: TextStyle(
              //         color: Colors.white,
              //       ),
              //     ),
              //     child:       RangeSlider(
              //       min: 0.0,
              //       max: 40.0,
              //       activeColor: Colors.green,
              //       inactiveColor: Colors.green[100],
              //       values: RangeValues(_startValueEventTimer, _endValueEventTimer),
              //       divisions: 100,
              //
              //       labels: RangeLabels(
              //         _startValueEventTimer.round().toString(),
              //         _endValueEventTimer.round().toString(),
              //       ),
              //       onChanged: (values) {
              //         setState(() {
              //           _startValueEventTimer = values.start;
              //           _endValueEventTimer = values.end;
              //         });
              //       },
              //     )
              // ),
              //
              // Text('Time till next event:'),
              // SliderTheme(
              //     data: SliderTheme.of(context).copyWith(
              //       activeTrackColor: Colors.red[700],
              //       inactiveTrackColor: Colors.red[100],
              //       trackShape: RoundedRectSliderTrackShape(),
              //       trackHeight: 4.0,
              //       thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
              //       thumbColor: Colors.redAccent,
              //       overlayColor: Colors.red.withAlpha(32),
              //       overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
              //       tickMarkShape: RoundSliderTickMarkShape(),
              //       activeTickMarkColor: Colors.red[700],
              //       inactiveTickMarkColor: Colors.red[100],
              //       valueIndicatorShape: PaddleSliderValueIndicatorShape(),
              //       valueIndicatorColor: Colors.redAccent,
              //       valueIndicatorTextStyle: TextStyle(
              //         color: Colors.white,
              //       ),
              //     ),
              //     child:       RangeSlider(
              //       min: 0.0,
              //       max: 120.0,
              //       activeColor: Colors.green,
              //       inactiveColor: Colors.green[100],
              //       values: RangeValues(_startValueTimetoEvent, _endValueTimetoEvent),
              //       divisions: 100,
              //
              //       labels: RangeLabels(
              //         _startValueTimetoEvent.round().toString(),
              //         _endValueTimetoEvent.round().toString(),
              //       ),
              //       onChanged: (values) {
              //         setState(() {
              //           _startValueTimetoEvent = values.start;
              //           _endValueTimetoEvent = values.end;
              //         });
              //       },
              //     )
              // ),



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
    print("Event detected! \n Send new colour");
    print(bluetoothData);

    eventCounter++;
    print("Event Counter: $eventCounter");

    var col_selected = _randomColor();
    setState(() {
      randColor = col_selected;
    });

    if(eventCounter == 1)             _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    if(eventCounter == maximumEvents) {
      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    }


    int waitingTimeInt = 10; // irgendein Wert angegeben, macht noch nichts im Python Skript Detect Colours bei FUN = colour_wheel.show_color
    _sendBleDataToAllDevices(red: col_selected.red, green: col_selected.green, blue: col_selected.blue, wait: waitingTimeInt);

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

    // To Do: Farbe von Button "Wähle mögliche Farbe" soll Farbe von LED anzeigen
    setState(() {
      randColor = randColor;
    });


    return randColor;
  }

  void _sendBleDataToAllDevices({int red: 250, int green: 30, int blue: 50, int wait: 1}) {  // double wait: 1

    print("Anzahl gefundener Devices $bleDevices.length");

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

  void setMaxEvents(maxEvents) {
    maximumEvents = maxEvents;
  }

  void _resetGame() {
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);

    setState(() {
      eventCounter = 0;
    });
  }



}



