import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:turnet/utils/alert_notification.dart';
import 'package:turnet/appoinment.dart';
import 'package:turnet/profile.dart';
import 'package:turnet/clients.dart';
import 'package:turnet/commerce_calendar.dart';

import 'package:turnet/notificationdetail.dart';
import 'package:flutter/services.dart';

class ViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: ContactPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class ContactPage extends StatefulWidget {
  final String title;
  ContactPage({Key key, this.title}) : super(key: key);

  @override
  ContactPageState createState() => ContactPageState();

  //ContactListState createState() => ContactListState(kContacts);
}

@JsonSerializable()
class ContactPageState extends State<ContactPage> {
  int _page = 0;
  int user_type = 0;

  GlobalKey _bottomNavigationKey = GlobalKey();

  final AppoinmentPage _appoinmentPage = AppoinmentPage();
  final ProfilePageDesign _profilePage = new ProfilePageDesign();
  final ClientsPage _clientsPage = new ClientsPage();
  final CommerceCalendar _commerceCalendar = new CommerceCalendar();



  Widget showPage = new AppoinmentPage();

  Widget pageChose(int page){
    switch(page){
      case 0:
        return _appoinmentPage;
        break;
      case 1:
        return (user_type == 2 ?_clientsPage : _commerceCalendar);
        break;
      case 2:
        return _profilePage;
        break;
    }
  }

  final FirebaseMessaging _firebaseMessaging2 = FirebaseMessaging();

  @override
  void initState() {
    // _saveDeviceToken();
    super.initState();
    getConfiguration();
    notification();
  }

  getConfiguration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    user_type = prefs.getInt('usertype') ?? 0;
  }

  Future<void> notification() async {

    _firebaseMessaging2.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("Data $message");
        AlertNotification.alert(context, message['data']['username'],
           'Su cita fue programada para el '+ message['data']['appoinmenDate'], "Aceptar");
        var json_data = {
          "appoinmentDate":message['data']['appoinmenDate'],
          "fullname":message['data']['username'],
        };
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => NotificationDetail(detail: json_data)));
      },
      onResume: (Map<String, dynamic> message) async {


        // TODO optional
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     /* appBar: AppBar(
        title: Text("Turnet"),
        backgroundColor: Color.fromRGBO(239, 65, 3, 1),
        centerTitle: true,
      ),*/

      body: Container(child: Center(
        child: showPage,
      ),
        color: Colors.red,


      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.list, size: 30, color: Colors.white),
          Icon(Icons.explore, size: 30, color: Colors.white),
          Icon(Icons.perm_identity,
              size: 30, color: Colors.white),
        ],
        color: Color.fromRGBO(239, 65, 3, 1),
        buttonBackgroundColor: Color.fromRGBO(239, 65, 3, 1),
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 200),
        onTap: (int tabIndex) {
          setState(() {
            showPage = pageChose(tabIndex);
          });
        },
      ),
    );
  }

}


