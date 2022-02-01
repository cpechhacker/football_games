import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'BleDeviceSelectionWidget.dart';
import 'SelectColours.dart';

class SliderZonenSpiel extends StatefulWidget {
  @override
  _SliderZonenSpiel createState() => _SliderZonenSpiel();
}

enum GameEventType { bluetoothReceived, timer }

class _SliderZonenSpiel extends State {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => _initializeBleDevices());
  }

  double _startValueEventTimer = 3;
  double _endValueEventTimer = 10;

  double _startValueTimetoEvent = 40;
  double _endValueTimetoEvent = 60;

  double EventTimer = 10;

  int waitingTimeInt = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('Spiel Drippling'),
      ),

      body: Container(
        child: Center(

          // Todo: Modularize this Select random Colors widget
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              buildColours(context),
              sendColours(),

              Text('Event Time next event: $waitingTimeInt'),

              SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.red[700],
                    inactiveTrackColor: Colors.red[100],
                    trackShape: RoundedRectSliderTrackShape(),
                    trackHeight: 4.0,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    thumbColor: Colors.redAccent,
                    overlayColor: Colors.red.withAlpha(32),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                    tickMarkShape: RoundSliderTickMarkShape(),
                    activeTickMarkColor: Colors.red[700],
                    inactiveTickMarkColor: Colors.red[100],
                    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                    valueIndicatorColor: Colors.redAccent,
                    valueIndicatorTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  child:       RangeSlider(
                    min: 0.0,
                    max: 40.0,
                    activeColor: Colors.green,
                    inactiveColor: Colors.green[100],
                    values: RangeValues(_startValueEventTimer, _endValueEventTimer),
                    divisions: 100,

                    labels: RangeLabels(
                      _startValueEventTimer.round().toString(),
                      _endValueEventTimer.round().toString(),
                    ),
                    onChanged: (values) {
                      setState(() {
                        _startValueEventTimer = values.start;
                        _endValueEventTimer = values.end;
                      });
                    },
                  )
              ),

              Text('Time till next event:'),
              SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.red[700],
                    inactiveTrackColor: Colors.red[100],
                    trackShape: RoundedRectSliderTrackShape(),
                    trackHeight: 4.0,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    thumbColor: Colors.redAccent,
                    overlayColor: Colors.red.withAlpha(32),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                    tickMarkShape: RoundSliderTickMarkShape(),
                    activeTickMarkColor: Colors.red[700],
                    inactiveTickMarkColor: Colors.red[100],
                    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                    valueIndicatorColor: Colors.redAccent,
                    valueIndicatorTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  child:       RangeSlider(
                    min: 0.0,
                    max: 120.0,
                    activeColor: Colors.green,
                    inactiveColor: Colors.green[100],
                    values: RangeValues(_startValueTimetoEvent, _endValueTimetoEvent),
                    divisions: 100,

                    labels: RangeLabels(
                      _startValueTimetoEvent.round().toString(),
                      _endValueTimetoEvent.round().toString(),
                    ),
                    onChanged: (values) {
                      setState(() {
                        _startValueTimetoEvent = values.start;
                        _endValueTimetoEvent = values.end;
                      });
                    },
                  )
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

  void _onEvent(GameEventType type, BleDevice device, List<int> bluetoothData) {
    print("I'm here!");
    print(bluetoothData);

    setState(() {
      var col_selected = randColor; //ToDo: eigentlich sollte _randomColor() aufgerufen werden
      //print("Color selected: $col_selected");

      final _randomWaitingTime = new Random();
      waitingTimeInt = _startValueEventTimer.round() + _randomWaitingTime.nextInt(_endValueEventTimer.round() - _startValueEventTimer.round());
      print("Waiting Time $waitingTimeInt");

      //ToDo: Hier soll nicht mehr "_sendBleDataToAllDevices" benötigt werden
      _sendBleDataToAllDevices(red: col_selected.red, green: col_selected.green, blue: col_selected.blue, wait: waitingTimeInt);
    });

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






}



