import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'BleDeviceSelectionWidget.dart';
//import 'package:GameWidget.dart';
import 'WidgetSelection.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}
class _HomeWidgetState extends State {
  String msg = 'Flutter RaisedButton example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: Text('Games'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text("Bluetooth selection"),
                onPressed: _pushBleSelectionPage,
                color: Colors.white,
                textColor: Colors.blue,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
              // RaisedButton(
              //   child: Text("Start Game"),
              //   onPressed: _pushGame,
              //   color: Colors.blue,
              //   textColor: Colors.white,
              //   padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              //   splashColor: Colors.grey,
              // ),
              RaisedButton(
                child: Text("Widget Selection"),
                onPressed: _pushWidgetSelection,
                color: Colors.blue,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }

  // This code is called when the first button is pressed.
  void _pushBleSelectionPage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => BleDeviceSelectionWidget()),
    );
  }

  // This code is called when the second button is pressed.
  // void _pushGame() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(builder: (context) => GameWidget()),
  //   );
  // }

  // This code is called when the second button is pressed.
  void _pushWidgetSelection() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) =>SelectionWidget()),
    );
  }
}


