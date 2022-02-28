import 'dart:async';
import 'package:flutter/material.dart';
import 'BleDeviceSelectionWidget.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

enum GameEventType { bluetoothReceived, timer }

class BallHalten extends StatefulWidget {
  @override
  _BallHalten createState() => _BallHalten();
}

class _BallHalten extends State {

  final StopWatchTimer _stopwatchGesamt = StopWatchTimer(); // Create instance.
  final StopWatchTimer _stopwatch1 = StopWatchTimer(); // Create instance.
  final StopWatchTimer _stopwatch2 = StopWatchTimer(); // Create instance.

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
        title: Text('Ball Halten Stoppuhr'),

      ),

      body: Container(
        child: Center(

          // Todo: Modularize this Select random Colors widget
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: StreamBuilder<int>(
                  stream: _stopwatchGesamt.rawTime,
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
                      ],
                    );
                  },
                ),
              ),

              Column(
                children: [
                  ElevatedButton(
                    onPressed: _resetGame, child: Text("Reset!"),
                  ),
                  ElevatedButton(
                    onPressed: _stopGame, child: Text("Stop!"),
                  )
                ]
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: StreamBuilder<int>(
                  stream: _stopwatch1.rawTime,
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
                            onPressed: _startWatch1,
                            child: const Text(
                              'Team 1',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: StreamBuilder<int>(
                  stream: _stopwatch2.rawTime,
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
                            onPressed: _startWatch2,
                            child: const Text(
                              'Team 2',
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


  void _startWatch1() {
    _stopwatch1.onExecute.add(StopWatchExecute.start);
    _stopwatch2.onExecute.add(StopWatchExecute.stop);
    _stopwatchGesamt.onExecute.add(StopWatchExecute.start);
  }

  void _startWatch2() {
    _stopwatch2.onExecute.add(StopWatchExecute.start);
    _stopwatch1.onExecute.add(StopWatchExecute.stop);
    _stopwatchGesamt.onExecute.add(StopWatchExecute.start);
  }

  void _stopGame() {
    _stopwatch1.onExecute.add(StopWatchExecute.stop);
    _stopwatch2.onExecute.add(StopWatchExecute.stop);
  }

  void _resetGame() {
    _stopwatch1.onExecute.add(StopWatchExecute.stop);
    _stopwatch2.onExecute.add(StopWatchExecute.stop);

    _stopwatch1.onExecute.add(StopWatchExecute.reset);
    _stopwatch2.onExecute.add(StopWatchExecute.reset);

    _stopwatchGesamt.onExecute.add(StopWatchExecute.reset);
  }

  void _initializeBleDevices() {
    print("Available devices: ${bleDevices.length}");

    //bleDevices.forEach(
    //        (device) => device.tx.value.listen((value) => _onEvent(GameEventType.bluetoothReceived, device, value)));
  }




}



