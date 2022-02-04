import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


List<Color> currentColors = [Color.fromRGBO(255, 0, 0, 0.4)];
Color randColor = Color.fromRGBO(255, 0, 0, 0.4);

class SelectColours extends StatefulWidget {
  @override
  _SelectColours createState() => _SelectColours();
}

class _SelectColours extends State {
  @override
  Widget build(BuildContext context) {
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


  // ToDo: set Sate for  randColor -> Ziel: Auch in App soll die aktuelle Farbe angezeigt werden. Und die Farbe sollte bei Event (Touch) auch geändert werden
  void changeColors(List<Color> colors) {
    print("Aktuelle Farben:");
    print(currentColors);
  }

}



