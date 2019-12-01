import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';
import 'config/constants.dart';
import 'package:turnet/utils/alert_notification.dart';

void main() => runApp(CommerceCalendar());

void setErrorBuilder() {
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return Scaffold(
        body: Center(
            child: Text("Cargando...")));
  };
}
class CommerceCalendar extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  @override
  Widget build(BuildContext context) {
    setErrorBuilder();

    return MaterialApp(
      builder: (BuildContext context, Widget widget) {

        return widget;
      },
    );
  }
}

class _MyAppState extends State<CommerceCalendar> {
  double padValue = 0;
  Duration _duration = Duration();
  double _lowerValue = 20.0;
  double _upperValue = 80.0;
  double _lowerValueFormatter = 20.0;
  double _upperValueFormatter = 20.0;
  final baseColor = Color.fromRGBO(255, 255, 255, 0.3);

  List<Paint> paints = <Paint>[];

  int initTime;
  int endTime;

  int inBedTime;
  int outBedTime;

  int initTimeD;
  int endTimeD;

  int inBedTimeD;
  int outBedTimeD;

  bool _saving = false;
  var user_type = 0;
  var user_id = 0;
  var daysOfweek = [];


  @override
  void initState() {
    super.initState();
    //_shuffle();
    _saving = true;
    getSchedule();
  }

  void _shuffle() {
    setState(() {
      _saving = true;
      initTime = 96;
      endTime = 144;
      inBedTime = initTime;
      outBedTime = endTime;
      initTimeD = 120;
      endTimeD = 130;
      inBedTimeD = initTimeD;
      outBedTimeD = endTimeD;
      paints =[
        Paint(1, 'Lunes', '8:00 am to 6:00 pm', Colors.green, false),
        Paint(2, 'Martes', '8:00 am to 6:00 pm', Colors.green, false),
        Paint(3, 'Miercoles', '8:00 am to 6:00 pm', Colors.green, false),
        Paint(4, 'Jueves', '8:00 am to 6:00 pm', Colors.green, false),
        Paint(5, 'Viernes', '8:00 am to 6:00 pm', Colors.green, false),
        Paint(6, 'Sabado', '8:00 am to 6:00 pm', Colors.green, false),
        Paint(7, 'Domingo', '8:00 am to 6:00 pm', Colors.green, false)
      ];
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

    /*if(time == null){
      return '0:0';
    }else {*/
    print("ttt-- $time");
      var hours = ( time ) ~/ 12;
      //print("hours -- $hours");
      var minutes = 0;
      if(time != null && time != 0){

        minutes =( time  % 12) * 5;
      }
      // print("---$minutes");
      var min = (minutes.toString() == "0" ? "00" : minutes);
      return '$hours:$min';
   // }

  }

  String _formatIntervalTimeD(int init, int end) {
   // print("otro -- $init - $end");
    var sleepTime = end > init ? end - init : 188 - init + end;
    var hours = sleepTime ~/ 6;
    var minutes = (sleepTime % 6) * 10;
    return '${hours}h ${minutes}m';
  }

  String _formatIntervalTime(int init, int end) {
    print("otro -- $init - $end");
    if(init == null && end == null || init == 0 && end == 0) {
      return '0h 0m';
    }else {
      var sleepTime = end > init ? end - init : 188 - init + end;
      var hours = sleepTime ~/ 12;
      var minutes = (sleepTime % 12) * 5;
      return '${hours}h ${minutes}m';
    }
  }

  Future<void> getSchedule() async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var type  = prefs.getInt('usertype') ?? 0;
    user_type = type;
    user_type = user_type == 1 ? 2 : 1;
    user_id = prefs.getInt('id') ?? 0;

    /*setState(() {
      _saving = true;
    });*/

    http.get( SCHEDULE + "$user_id", headers: headers).then((rta) async {
     // print("Dtaa  ${rta.statusCode}");

      if (rta.statusCode == 200 && rta.body.length > 0) {
        var data  = json.decode(rta.body);
        print("Dtaa  ${data}");
        int dur = data['duration'];
        double m = 1;

        //print("Dur $dur");
        var _duration2 = Duration(hours: 0, minutes: 30, seconds: 0);
        setState(() {
          //Iterable list = json.decode(rta.body);
          var entry_time = data['entry_time'] / 5;
          var departure_time = data['departure_time'] / 5;
          var take_break = data['take_break'] / 5;
          var return_break = data['return_break'] / 5;
          initTime =  (m * (entry_time)).round();
          endTime = (m * (departure_time)).round();
          inBedTime = initTime;
          outBedTime = endTime;
          initTimeD = (m * (take_break)).round();
          endTimeD = (m * (return_break)).round();
          inBedTimeD = initTimeD;
          outBedTimeD = endTimeD;
          _saving = false;
          //_duration = Duration(minutes: 40);

          _duration = _duration2;
          double mult = .5;
          paints =[
            Paint(1, 'Lunes', '8:00 am to 6:00 pm', Colors.green, ((mult * data['monday']).round() == 1 ? true: false)),
            Paint(2, 'Martes', '8:00 am to 6:00 pm', Colors.green, ((mult * data['thuesday']).round() == 1 ? true: false)),
            Paint(3, 'Miercoles', '8:00 am to 6:00 pm', Colors.green, ((mult * data['wesnesday']).round() == 1 ? true: false)),
            Paint(4, 'Jueves', '8:00 am to 6:00 pm', Colors.green, ((mult * data['thursday']).round() == 1 ? true: false)),
            Paint(5, 'Viernes', '8:00 am to 6:00 pm', Colors.green,((mult * data['friday']).round() == 1 ? true: false)),
            Paint(6, 'Sabado', '8:00 am to 6:00 pm', Colors.green, ((mult * data['saturday']).round() == 1 ? true: false)),
            Paint(7, 'Domingo', '8:00 am to 6:00 pm', Colors.green, ((mult * data['sunday']).round() == 1 ? true: false))
          ];


          /* print("Paint<<<--");
          print((mult * data['monday']).round() == 1 ? true: false);
          print((mult * data['thuesday']).round() == 1 ? true: false);
          print("Paint-- ${paints[0]}");
          paints[0].selected =((data['monday'] ~/ 2) == 1 ? true: false);
          paints[1].selected =((data['thuesday'] ~/ 2) == 1 ? true: false);*/
         /* paints[2].selected =((data['wesnesday'] ~/ 2) == 1 ? true: false);
          paints[3].selected =((data['thursday'] ~/ 2) == 1 ? true: false);
          paints[4].selected =((data['friday'] ~/ 2) == 1 ? true: false);
          paints[5].selected =((data['saturday'] ~/ 2) == 1 ? true: false);
          paints[6].selected =((data['sunday'] ~/ 2) == 1 ? true: false);*/
        });
      }else{
        setState(() {

          _saving = false;
          initTime = 96;
          endTime = 144;
          inBedTime = initTime;
          outBedTime = endTime;
          initTimeD = 120;
          endTimeD = 130;
          inBedTimeD = initTimeD;
          outBedTimeD = endTimeD;
          paints =[
            Paint(1, 'Lunes', '8:00 am to 6:00 pm', Colors.green, false),
            Paint(2, 'Martes', '8:00 am to 6:00 pm', Colors.green, false),
            Paint(3, 'Miercoles', '8:00 am to 6:00 pm', Colors.green, false),
            Paint(4, 'Jueves', '8:00 am to 6:00 pm', Colors.green, false),
            Paint(5, 'Viernes', '8:00 am to 6:00 pm', Colors.green, false),
            Paint(6, 'Sabado', '8:00 am to 6:00 pm', Colors.green, false),
            Paint(7, 'Domingo', '8:00 am to 6:00 pm', Colors.green, false)
          ];
        });
        AlertNotification.alert(context, "Aviso importante",
            "Por favor configure su agenda para recibir Citas!.", "Aceptar");

      }
      // stop the modal progress HUD
    });
  }

  void sendSchedule() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var id_client = prefs.getInt('id') ?? 0;

    setState(() {
      _saving = true;
    });

    //Login user
    Map<String, String> headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
        "userCommerceId": id_client,
        "monday": (paints[0].selected ? 1: 0),
        "thuesday": (paints[1].selected ? 1: 0),
        "wesnesday":(paints[2].selected ? 1: 0),
        "thursday":(paints[3].selected ? 1: 0),
        "friday": (paints[4].selected ? 1: 0),
        "saturday": (paints[5].selected ? 1: 0),
        "sunday": (paints[6].selected ? 1: 0),
        "departure_time": (endTime * 5),
        "entry_time": (initTime * 5),
        "take_break": (inBedTimeD * 5),
        "duration": _duration.inMinutes,
        "return_break": (outBedTimeD * 5),
        "state":1

    });

    print("Schedule ${body}");

    http.post(SCHEDULE, headers: headers, body: body).then((rta) async {
      setState(() {
        _saving = false;
      });
      print('Esto ${rta}');
      if (rta.statusCode == 200 && rta.body.length > 0) {
        AlertNotification.alert(context, "Aviso importante",
            "Su programación ha sido actualizada correctamente.", "Aceptar");
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    setErrorBuilder();
    return Scaffold(

        body: ModalProgressHUD(

        child: ListView(
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
              print("PickerTime ${val}");
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
                _formatBedTime('INGRESO', inBedTime),
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
                initTime = a;
                endTime = b;
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
            height: 480,
            child: new ListView(
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(paints.length, (index) {
                return ListTile(
                  contentPadding: EdgeInsets.fromLTRB(15, -10, 15, 0),
                  onTap: () {
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
                  subtitle: Text((paints[index].selected ? "ok":"no")+'::Horario : '+_formatTime(initTime)+' a '+_formatTime(endTime)+'\nReceso : '+_formatTime(inBedTimeD)+' a '+_formatTime(outBedTimeD)),
                  trailing: (paints[index].selected)
                      ? Icon(Icons.check_box)
                      : Icon(Icons.check_box_outline_blank),
                );
              }),
            )),
        Container(
          constraints: BoxConstraints.expand(height: 45),
          margin: EdgeInsets.only(left: 17, top: 0, right: 15, bottom: 17),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 65, 143, 222),
            borderRadius: BorderRadius.all(Radius.circular(24.5)),
          ),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: sendSchedule, //Submit form
            padding: EdgeInsets.all(12),
            color: Color.fromRGBO(235, 69, 3, 1),
            child: Text('Enviar',
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 17,
                    letterSpacing: 0.27,
                    fontFamily: "Helvetica")),
          ),
        ),
      ],
    ),inAsyncCall: _saving)

        );
  }
}

class Paint {
  final int id;
  final String title;
  final String hours;
  final Color colorpicture;
  bool selected = false;

  Paint(this.id, this.title, this.hours, this.colorpicture, this.selected);
}
