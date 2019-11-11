import 'package:flutter/material.dart';
import 'package:turnet/view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
// Uncomment lines 7 and 10 to view the visual layout at runtime.
// import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
const IconData person_pin = IconData(0xe55a, fontFamily: 'MaterialIcons');


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

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(Colors.red, Icons.cancel, 'CANCELAR'),
        ],
      ),
    );

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
        body: ListView(

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