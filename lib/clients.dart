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

enum ConfirmAction { CANCEL, ACCEPT }

class ClientsPage extends StatefulWidget {
  final String title;
  ClientsPage({Key key, this.title}) : super(key: key);

  @override
  ClientsPageState createState() => ClientsPageState();
}
@JsonSerializable()
class ClientsPageState extends State<ClientsPage> {
  bool _isInAsyncCall = false;

  List<dynamic> _listViewData = [];

  bool _saving = false;

  var items = List<dynamic>();
  var user_type = 0;
  var user_id = 0;

  @override
  void initState() {
    super.initState();
    getClients();
  }

  Future<void> getClients() async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var user_type = prefs.getInt('usertype') ?? 0;
    user_type = user_type == 1 ? 2 : 1;
    setState(() {
      _isInAsyncCall = true;
      _saving = true;
    });
    http.get(CLIENTS + "/$user_type", headers: headers).then((rta) async {
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
    var info = 'Desea solicitar una cita con: '+ data["fullname"]+'?';
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Solicitar Cita!'),
          content:  Text(info),
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
              },
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.all(12),
              color: Colors.blueAccent,
              child: Text('SI', style: TextStyle(color: Colors.white)),
              onPressed: () {
                sendNontification(data);
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            ),
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
          title: new Text((date == "NO" ? "Importante!": "Su cita fue programada para: ")),
          content: new Text((date == "NO" ? "El sistema permite programar solo una cita por Proveedor.\n\nPor favor verifique si ya tiene una asignada!\nGracias.": date)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("CERRAR"),
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
      var data = json.decode(rta.body);
      print("Resul $data");
      setState(() {
        _saving = false;
      });


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
        backgroundColor: Colors.red,
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
                      subtitle: Text(items[index]['username']),
                      leading: CircleAvatar(
                        child: Image.asset(
                          'images/logo.png',
                          width: 127,
                          height: 128,
                          fit: null,

                        ),/* Text(items[index]['fullname'][0].toString()),*/
                        backgroundColor: Colors.transparent,
                      ),
                      onTap: () {
                        _asyncConfirmDialog(context, items[index]);
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
                  hintText: "Search...",
                ),
              ),
            ),
            inAsyncCall: _saving)
    );
  }

  /*
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ModalProgressHUD(
          child: Container(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              itemCount: _listViewData.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration( //                    <-- BoxDecoration
                    border: Border(bottom: BorderSide(color: Colors.white60)),
                  ),
                  child: ListTile(
                    title: Text(_listViewData[index]['fullname']),
                    subtitle: Text(_listViewData[index]['username']),
                    leading: CircleAvatar(
                      child:
                      Text(_listViewData[index]['fullname'][0].toString()),
                      backgroundColor: Colors.blueAccent
                    ),
                    onTap: () {
                      sendNontification(_listViewData[index]);
                    },
                  ),
                );
              },
            ),
            color: Colors.black12,
          ),
          inAsyncCall: _saving),
    );
  }*/
}