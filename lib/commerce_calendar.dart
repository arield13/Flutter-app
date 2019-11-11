import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';

void main() => runApp(CommerceCalendar());

class CommerceCalendar extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<CommerceCalendar> {
  double padValue = 0;
  Duration _duration = Duration(hours: 0, minutes: 15);
  double _lowerValue = 20.0;
  double _upperValue = 80.0;
  double _lowerValueFormatter = 20.0;
  double _upperValueFormatter = 20.0;
  final baseColor = Color.fromRGBO(255, 255, 255, 0.3);

  List<Paint> paints = <Paint>[
    Paint(1, 'Lunes', '8:00 am to 6:00 pm', Colors.green),
    Paint(2, 'Martes', '8:00 am to 6:00 pm', Colors.green),
    Paint(3, 'Miercoles', '8:00 am to 6:00 pm', Colors.green),
    Paint(4, 'Jueves', '8:00 am to 6:00 pm', Colors.green),
    Paint(5, 'Viernes', '8:00 am to 6:00 pm', Colors.green),
    Paint(6, 'Sabado', '8:00 am to 6:00 pm', Colors.green),
    Paint(7, 'Domingo', '8:00 am to 6:00 pm', Colors.green)
  ];

  int initTime;
  int endTime;

  int inBedTime;
  int outBedTime;

  int initTimeD;
  int endTimeD;

  int inBedTimeD;
  int outBedTimeD;

  @override
  void initState() {
    super.initState();
    _shuffle();
  }

  void _shuffle() {
    setState(() {
      initTime = 96;
      endTime = 192;
      inBedTime = initTime;
      outBedTime = endTime;
      initTimeD = 144;
      endTimeD = 156;
      inBedTimeD = initTimeD;
      outBedTimeD = endTimeD;
    });
  }

  int _generateRandomTime() => Random().nextInt(288);

  Widget _formatBedTime(String pre, int time) {
    return Column(
      children: [
        Text((pre== 'INICIO' || pre == 'FIN' ? 'DESCANSO':'HORA'), style: TextStyle(color: Colors.red)),
        Text(pre, style: TextStyle(color: Colors.red)),

        Text(
          '${_formatTime(time)}',
          style: TextStyle(color: Colors.blue),
        )
      ],
    );
  }

  String _formatTime(int time) {
    print("este -- $time");
    if (time == 0 || time == null) {
      return '00:00';
    }
    var hours = time ~/ 12;
    var minutes = (time % 12) * 5;
    print("---$minutes");
    minutes = ( minutes.toString() == '0' ? '00': minutes);
    return '$hours:$minutes';
  }

  String _formatIntervalTimeD(int init, int end) {
    print("otro -- $init - $end");
    var sleepTime = end > init ? end - init : 188 - init + end;
    var hours = sleepTime ~/ 6;
    var minutes = (sleepTime % 6) * 10;
    return '${hours}h ${minutes}m';
  }

  String _formatIntervalTime(int init, int end) {
    print("otro -- $init - $end");
    var sleepTime = end > init ? end - init : 188 - init + end;
    var hours = sleepTime ~/ 12;
    var minutes = (sleepTime % 12) * 5;
    return '${hours}h ${minutes}m';
  }

  _updateLabels(init, end) {
    setState(() {
      inBedTime = init;
      outBedTime = end;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Container(height: 20),
        Container(
          height: 40,
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('TURNO POR CLIENTE', style: TextStyle(color: Colors.red)),
              ]),
        ),
        Container(
          child: new SizedBox(
              child: DurationPicker(
            height: 170,
            duration: _duration,
            onChange: (val) {
              this.setState(() => _duration = val);
            },
            snapToMins: 10.0,
          )),
        ),

        Container(height: 15),
        Container(
          height: 40,
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('INGRESO Y SALIDA', style: TextStyle(color: Colors.red)),
              ]),
        ),
        Container(
          height: 50,
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _formatBedTime('INGRESO', inBedTime,),
                _formatBedTime('SALIDA', outBedTime),
              ]),
        ),
        Container(
          height: 170,
          child: SizedBox(
              child: new DoubleCircularSlider(
            288,
            initTime,
            endTime,
            height: 200.0,
            primarySectors: 24,
            secondarySectors: 24,
            baseColor: Color.fromRGBO(255, 255, 255, 0.1),
            selectionColor: Colors.blue,
            handlerColor: Colors.red,
            handlerOutterRadius: 12.0,
            onSelectionChange: (int a, int b, last) {
              setState(() {
                inBedTime = a;
                outBedTime = b;
              });
            },
            sliderStrokeWidth: 12.0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                  child: Text('${_formatIntervalTime(inBedTime, outBedTime)}',
                      style: TextStyle(fontSize: 15.0, color: Colors.red))),
            ),
          )),
        ),
        Container(height: 15),
        Container(
          height: 40,
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('HORARIO DESCANSO', style: TextStyle(color: Colors.red)),
              ]),
        ),
        Container(
          height: 50,
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _formatBedTime('INICIO', inBedTimeD),
                _formatBedTime('FIN', outBedTimeD),
              ]),
        ),
        Container(
          height: 170,
          child: SizedBox(
              child: new DoubleCircularSlider(
                288,
                initTimeD,
                endTimeD,
                height: 200.0,
                primarySectors: 24,
                secondarySectors: 24,
                baseColor: Color.fromRGBO(255, 255, 255, 0.1),
                selectionColor: Colors.blue,
                handlerColor: Colors.red,
                handlerOutterRadius: 12.0,
                onSelectionChange: (int a, int b, last) {
                  setState(() {
                    inBedTimeD = a;
                    outBedTimeD = b;
                  });
                },
                sliderStrokeWidth: 12.0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                      child: Text('${_formatIntervalTime(inBedTimeD, outBedTimeD)}',
                          style: TextStyle(fontSize: 15.0, color: Colors.red))),
                ),
              )),
        ),
        Container(height: 15),
        Container(
          height: 15,
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('SELECCIONE DIAS HABILES', style: TextStyle(color: Colors.red)),
              ]),
        ),
        Container(
            height: 520,
            child: new ListView(
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(paints.length, (index) {
                return ListTile(
                  contentPadding: EdgeInsets.fromLTRB(15, -10, 15, 0),
                  onLongPress: () {
                    setState(() {
                      paints[index].selected = !paints[index].selected;
                      //log( paints[index].selected.toString());
                    });
                  },
                  selected: paints[index].selected,
                  leading: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                    child: Container(
                      width: 38,
                      height: 38,
                      padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 0.0),
                      alignment: Alignment.center,
                      child: Icon(Icons.schedule, color: Colors.blue, size: 30),
                    ),
                  ),
                  title: Text(paints[index].title),
                  subtitle: Text(paints[index].hours.toString()),
                  trailing: (paints[index].selected)
                      ? Icon(Icons.check_box)
                      : Icon(Icons.check_box_outline_blank),
                );
              }),
            )),
        Container(height: 25),
      ],
    )

        );
  }
}

class Paint {
  final int id;
  final String title;
  final String hours;
  final Color colorpicture;
  bool selected = false;

  Paint(this.id, this.title, this.hours, this.colorpicture);
}
