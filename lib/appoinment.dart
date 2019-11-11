import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'dart:async';
import 'dart:convert';
import 'config/constants.dart';
import 'package:turnet/utils/alert_notification.dart';
import 'package:turnet/notificationdetail.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

enum ConfirmAction { CANCEL, ACCEPT }

class AppoinmentPage extends StatefulWidget {
  final String title;
  AppoinmentPage({Key key, this.title}) : super(key: key);

  @override
  AppoinmentPageState createState() => AppoinmentPageState();
}

@JsonSerializable()
class AppoinmentPageState extends State<AppoinmentPage> {
  bool _isInAsyncCall = false;

  List<dynamic> _listViewData = [];
  var items = List<dynamic>();

  List<dynamic> detail = [];

  bool _saving = false;
  var user_type = 0;
  var user_id = 0;
  String _fcm_id;

  @override
  void initState() {
     _saveDeviceToken();
    super.initState();
    getClients();
    /* notification();*/
  }

  _saveDeviceToken() async {
    // Get the current user
    String uid = 'jeffd23';
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    _fcm_id = await _firebaseMessaging.getToken();
    print("TockenArielin: $_fcm_id");

  }

  Future<void> getClients() async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var type  = prefs.getInt('usertype') ?? 0;
    user_type = type;
    user_type = user_type == 1 ? 2 : 1;
    user_id = prefs.getInt('id') ?? 0;
    setState(() {
      _isInAsyncCall = true;
      _saving = true;
      user_type = user_type;
      user_id = user_id;
    });
    var fullname = prefs.getString('fullname') ?? null;
    print("User fullname  $fullname");

    http.get( (type == 1 ? APPOINMENT : APPOINMENT_COMMERCE) + "/$user_id", headers: headers).then((rta) async {
      if (rta.statusCode == 200 && rta.body.length > 0) {
        setState(() {
          //Iterable list = json.decode(rta.body);
          _listViewData = json.decode(rta.body);
          items.addAll(_listViewData);
          _isInAsyncCall = false;
          _saving = false;
          //supplier = list.map((model) => Contact.fromJson(model)).toList();
        });
      }
      // stop the modal progress HUD
    });
  }



Future<ConfirmAction> _asyncConfirmDialog(BuildContext context, data) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Reset settings?'),
        content: const Text(
            'This will reset your device to its default factory settings.'),
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCELAR'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          FlatButton(
            child: const Text('ACEPTAR'),
            onPressed: () {
              sendNontification(data);
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          )
        ],
      );
    },
  );
}

  void _showDialog(date) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text((date == "NO" ? "Notificaión!": "Su cita fue programada para: ")),
          content: new Text((date == "NO" ? "El sistema permite programar solo una cita!\nPor favor verifique.!": date)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void sendNontification(data) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var user = prefs.getString('userEmail') ?? null;

    var fullname = prefs.getString('fullname') ?? null;

    var type  = prefs.getInt('usertype') ?? 0;
    user_type = type;
    var role = user_type == 1 ? "Cliente" : "Proveedor";

    var id_client = prefs.getInt('id') ?? 0;

    setState(() {
      _isInAsyncCall = true;
    });

    //Login user
    Map<String, String> headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "title": "Cita",
      "username": fullname,
      "idreceptor": data['id'],
      "message": 'El ' +
          role +
          ' :' +
          (fullname != null ? fullname : '') +
          ' a programado una cita ',
      "token": "",
      "topic": role,
      "userClientId": id_client,
      "comment": ""
    });

    http.post(NOTIFICATION, headers: headers, body: body).then((rta) async {
      // stop the modal progress HUD
      setState(() {
        _isInAsyncCall = false;
      });
      var data = json.decode(rta.body);
      _showDialog(data['message']);
    });
  }

  duplicate(context, title, content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            title,
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              content,
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.lightBlueAccent,
            ),
          ],
        );
      },
    );
  }

  void filterSearchResults(String query) {
    List<dynamic> dummySearchList = [];

    dummySearchList.addAll(_listViewData);
    if(query.isNotEmpty) {
      /*print("Here -");
      print(dummySearchList);
      print(query);*/
      List<dynamic> dummyListData = [];
      dummySearchList.forEach((item) {
        if(item['fullname'] .contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(_listViewData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: ModalProgressHUD(
        child:  Container(
          color: Colors.red,
          child: FloatingSearchBar.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white60)),
                ),
                child: ListTile(
                  title: Text(items[index]['fullname']),
                  subtitle:  Text(items[index]['appoinmentDate']),
                  leading: CircleAvatar(
                    child: (user_type == 2 ?
                    Image.asset(
                      'images/logo.png',
                      width: 140,
                      height: 140,
                      fit: null,

                    ): Icon(
                      Icons.person,
                      color: Colors.white,
                    )),
                    backgroundColor: (user_type == 2 ? Colors.white : Color.fromRGBO(239, 65, 3, 1)),
                  ),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationDetail(detail: items[index]),
                      ),
                    );
                   // _asyncConfirmDialog(context, items[index]);
                    //sendNontification(items[index]);
                  },
                ),
              );
            },
            trailing: CircleAvatar(
                child: Icon(
              Icons.search,
              color: Colors.white,
            )),
            onChanged: (String value) {
              print("New value -> $value");
              filterSearchResults(value);

            },
            onTap: () {},
            decoration: InputDecoration.collapsed(
              hintText: "Buscar citas...",
            ),
          ),
        ),inAsyncCall: _saving));
  }
}
/*
class DataSearch extends SearchDelegate<String> {
  final cities = [
    "Ave",
    "Be",
    "Con",
    "Tio",
    "Nato",
    "burnavi",
    "Besi",
    "Sin",
    "Sa",
    "Semo",
    "Cula",
    "Senfes",
    "Dani",
    "Verte",
  ];
  final recentCities = [
    "Sa",
    "Semo",
    "Cula",
    "Senfes",
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {})];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow), onPressed: () {});
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty ? recentCities: cities;
    return ListView.builder(itemBuilder: (context, index) => ListTile(
      leading: Icon(Icons.person),
      title: Text(suggestionList[index]),

    ),
      itemCount: suggestionList.length,
    );
  }
}
*/