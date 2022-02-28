import 'package:flutter/material.dart';

// import 'package:flutter_ble_cp/stopwatch.dart';
// import 'package:flutter_ble_cp/WidgetGauge.dart';
// import 'package:flutter_ble_cp/WidgetColor.dart';
// // import 'package:flutter_ble_cp/WidgetLineChart.dart';
// import 'package:flutter_ble_cp/BluetoothListen.dart';
// import 'package:flutter_ble_cp/WidgetSlider.dart';

//import 'package:flutter_ble_cp/WidgetModulTesting.dart';

import 'ZonenSpiel.dart';

import 'TouchDetect.dart';
import 'TouchDetectCountdown.dart';
import 'Timer.dart';
import 'NFCReadWrite.dart';
import 'BallHaltenStoppuhr.dart';
import 'BleListen.dart';

import "Stopwatch.dart";


class SelectionWidget extends StatefulWidget {
  @override
  _SelectionWidgetState createState() => _SelectionWidgetState();
}


class _SelectionWidgetState extends State {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('Stopwatch'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // RaisedButton(
              //   child: Text("Stopwatch"),
              //   onPressed: _startStopwatch,
              //   color: Colors.white,
              //   textColor: Colors.blue,
              //   padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              //   splashColor: Colors.grey,
              // ),
              // RaisedButton(
              //   child: Text("Gauge"),
              //   onPressed: _startGauge,
              //   color: Colors.white,
              //   textColor: Colors.blue,
              //   padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              //   splashColor: Colors.grey,
              // ),
              // RaisedButton(
              //   child: Text("Colour"),
              //   onPressed: _startColour,
              //   color: Colors.white,
              //   textColor: Colors.blue,
              //   padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              //   splashColor: Colors.grey,
              // ),

              // RaisedButton(
              //   child: Text("Ble Listen"),
              //   onPressed: _startBleListen,
              //   color: Colors.white,
              //   textColor: Colors.blue,
              //   padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              //   splashColor: Colors.grey,
              // ),
/*              RaisedButton(
                child: Text("Slider Testing"),
                onPressed: _startSlider,
                color: Colors.white,
                textColor: Colors.blue,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              )*/
              // RaisedButton(
              //   child: Text("Farben Drippling"),
              //   onPressed: _startFarbenDrippling,
              //   color: Colors.white,
              //   textColor: Colors.blue,
              //   padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              //   splashColor: Colors.grey,
              // ),
              RaisedButton(
                child: Text("Zonenspiel"),
                onPressed: _startZonenSpiel,
                color: Colors.white,
                textColor: Colors.blue,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),

              RaisedButton(
                child: Text("TouchDetect"),
                onPressed: _startTouchDetect,
                color: Colors.white,
                textColor: Colors.blue,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
              RaisedButton(
                child: Text("TouchDetect Countdown"),
                onPressed: _startTouchDetectCountdown,
                color: Colors.white,
                textColor: Colors.blue,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),

              RaisedButton(
                child: Text("Timer Game"),
                onPressed: _startTimerGame,
                color: Colors.white,
                textColor: Colors.blue,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
              RaisedButton(
                child: Text("Ball halten Stoppuhr!"),
                onPressed: _startBallHalten,
                color: Colors.white,
                textColor: Colors.blue,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
              RaisedButton(
                child: Text("NFC"),
                onPressed: _startNFCReadWrite,
                color: Colors.white,
                textColor: Colors.blue,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
              RaisedButton(
                child: Text("Ble Listen"),
                onPressed: _startBleListen,
                color: Colors.white,
                textColor: Colors.blue,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }



  // void _startStopwatch() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(builder: (context) =>StopwatchWidget()),
  //   );
  // }
  //
  // void _startGauge() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(builder: (context) =>GaugeApp()),
  //   );
  // }
  //
  // void _startColour() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(builder: (context) =>ColorPickerCP()),
  //   );
  // }
  //
  //
  //
  // void _startBleListen() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(builder: (context) =>BleListenWidget()),
  //   );
  // }
  //
  // void _startSlider() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(builder: (context) =>SliderWidget()),
  //   );
  // }
  //
  // void _startFarbenDrippling() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(builder: (context) =>SliderFarbenDrippling()),
  //   );
  // }

  void _startZonenSpiel() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) =>SliderZonenSpiel()),
    );
  }

  void _startTouchDetect() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) =>TouchDetect()),
    );
  }

  void _startTouchDetectCountdown() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) =>TouchDetectCountdown()),
    );
  }

  void _startTimerGame() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => TimerGame()),   // CountDownTimerPage() oder TimerGame()
    );
  }

  void _startBallHalten() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => BallHalten()),
    );
  }

  void _startNFCReadWrite() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => NFCReadWrite()),
    );
  }

  void _startBleListen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => BleListen()),
    );
  }



}
