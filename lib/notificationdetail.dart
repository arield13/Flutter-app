import 'package:flutter/material.dart';
import 'package:turnet/view.dart';
import 'package:turnet/appoinment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'config/constants.dart';
// Uncomment lines 7 and 10 to view the visual layout at runtime.
// import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
const IconData person_pin = IconData(0xe55a, fontFamily: 'MaterialIcons');
enum ConfirmAction { CANCEL, ACCEPT }

void main() {
  // debugPaintSizeEnabled = true;
  runApp(NotificationDetail());
}

class NotificationDetail extends StatefulWidget {
   var detail = {};
   NotificationDetail({Key key,  this.detail}) : super(key: key);
  _ExampleState createState() => _ExampleState();
}
class _ExampleState extends State<NotificationDetail> {

  var user_type;
  var fullname;
  bool _saving = false;
  List<dynamic> _detailViewData = [];

  Future<Null> getSharedPrefs() async {


    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('userEmail') ?? null;

    setState(() {
      fullname =  prefs.getString('fullname') ?? null;

      user_type =  prefs.getInt('usertype') ?? 0;
    });

  }

  @override
  void initState() {
    user_type = 0;
    getSharedPrefs();
  }

  void sendNontification() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var user = prefs.getString('userEmail') ?? null;

    var fullname = prefs.getString('fullname') ?? null;

    user_type = prefs.getInt('usertype') ?? 0;
    var role = user_type == 1 ? "Cliente" : "Proveedor";

    var id_client = prefs.getInt('id') ?? 0;

    setState(() {
      _saving = true;
    });

    //Login user
    Map<String, String> headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "title": "Cita",
      "username": fullname,
      "idreceptor": 0,
      "message": 'El ' +
          role +
          ' :' +
          (fullname != null ? fullname : '') +
          ' ha cancelado la cita. ',
      "token": "",
      "topic": (user_type == 1 ? "cc" : "cn"),
      "userClientId": id_client,
      "comment": ""
    });
   var id = widget.detail['appoinmentId'];
    http.post(NOTIFICATION_CANCEL+ "/$id", headers: headers, body: body).then((rta) async {
      // stop the modal progress HUD
      setState(() {
        _saving = false;
      });
      var data = json.decode(rta.body);
      print("Result $data");
      _showDialog(data['message']);
    });
  }

  void _showDialog(date) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text((date == "NO" ? "Importante!": "Notificación ")),
          content: new Text((date == "NO" ? "Las citas no se pueden cancelar para el mismo día.!\nGracias.": "Su cita fue cancelada exitosamente.")),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.all(12),
              color: Colors.blueAccent,
              child: Text('CERRAR', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }

  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context, data) async {

    var date_appoinment = DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.detail['appoinmentDate']));

    var now = new DateTime.now();
    var date_now = new DateFormat('yyyy-MM-dd').format(now);
    print(date_appoinment);
    print(date_now.compareTo(date_appoinment));
var days = date_now.compareTo(date_appoinment);
    if(days.toInt() > 0){
      print("Hola");
      showDialog(
          context: context,
          builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("Importante!"),
        content: new Text("Las citas no se pueden cancelar para el mismo día.!\nGracias."),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: EdgeInsets.all(12),
            color: Colors.blueAccent,
            child: new Text("CERRAR", style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
          });

    }else {
      var info = 'Desea cancelar la cita con : ' + widget.detail['fullname'] +
          '?';
      return showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cancelar Cita!'),
            content: Text(info),
            actions: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: EdgeInsets.all(12),
                color: Colors.blueAccent,
                child: Text('NO', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop(ConfirmAction.CANCEL);
                  }
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: EdgeInsets.all(12),
                color: Colors.blueAccent,
                child: Text('SI', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  sendNontification();
                  Navigator.of(context).pop(ConfirmAction.ACCEPT);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = this.widget.detail;
    print("Yepa.. $widget.detail");
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    widget.detail['fullname']?? '' ,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                ),
                Text(
                  widget.detail['appoinmentDate'] ?? '' ,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          /*3*/
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          Text('10'),
        ],
      ),
    );

    Color color = Theme.of(context).primaryColor;

    Widget buttonSection = InkWell(
      child :Container(
        constraints: BoxConstraints.expand(height: 45),

        margin: EdgeInsets.only(left: 17, top: 5, right: 15, bottom: 17),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24.5)),
        ),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
       //Submit form
          padding: EdgeInsets.all(12),
          color: Color.fromRGBO(235,69,3,1),
          child: Text('CANCELAR LA CITA',
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 17,
                  letterSpacing: 0.27,
                  fontFamily: "Helvetica")),
        ),
      ),
      onTap:(){
      _asyncConfirmDialog(context, {});
    }, );

    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        'Cita programada para '+widget.detail['appoinmentDate']+'. \n\nPor favor tener en cuenta que es muy importante para ambos atender la cita.'
            ' \n\nBuena suerte! ',
        softWrap: true,
      ),

    );

    return MaterialApp(
      title: 'Noviembre 7, 2019 ',

      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(239, 65, 3, 1),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () =>{
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ViewPage()))
            },
          ),
          title: Text('Detalle Cita'),
          centerTitle: true,

        ),
        body: ModalProgressHUD(
    child:ListView(

          padding: EdgeInsets.only(top: 30.0),
          children: [
            (user_type == 2 ?
              Icon(
                IconData(0xe55a, fontFamily: 'MaterialIcons'),
                size: 150,
                color: color
              ) :
            Image.asset(
              'images/logo.png',
              width: 127,
              height: 128,
              fit: null,

            )),

            titleSection,
            textSection,
            buttonSection,

          ],
        ),
            inAsyncCall: _saving
        ),
      ),
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),

        ),

      ],
    );
  }
}