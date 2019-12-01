import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:turnet/notificationdetail.dart';
import 'package:turnet/utils/alert_notification.dart';
import 'package:turnet/login_page.dart';
import 'package:turnet/view.dart';
import 'package:turnet/new_user.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    notification();
    startTimer();
  }

  Future<void> notification() async {

    Timer(Duration(seconds: 1), () {
    _firebaseMessaging.configure(
      onLaunch : (Map<String, dynamic> message) async {
        var json_data = {
          "appoinmentDate":message['data']['appoinmenDate'],
          "fullname":message['data']['username'],
          "appoinmentId": message['data']['appoinmentId'],
        };
        var option = (message['data']['topic'] != 'cc' &&
            message['data']['topic'] != 'cn' ? 1 : 2  );

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => (option == 1 ? NotificationDetail(detail: json_data) : ViewPage() )));
      },
    );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/icon.png"),
              fit: BoxFit.none

          ),

        ),
      ),
    );
  }

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      navigateUser(); //It will redirect  after 3 seconds
    });
  }

  void navigateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var user = prefs.getString('userEmail') ?? null;
    var usertype = prefs.getInt('usertype') ?? 0;


    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ViewPage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    }
  }
}
