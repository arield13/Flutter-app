import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:turnet/utils/alert_notification.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'config/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:turnet/view.dart';
import 'package:turnet/recovery_page.dart';
import 'package:turnet/new_user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

@JsonSerializable()
class _LoginPageState extends State<LoginPage> {
  // maintains validators and state of form fields
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  // manage state of modal progress HUD widget
  bool _isInAsyncCall = false;

  bool _isInvalidAsyncUser = false; // managed after response from server

  String _username;
  String _password;
  String _fcm_id;

  @override
  void initState() {
    _getDeviceToken();
    super.initState();
  }

  // validate password
  String _validatePassword(String password) {
    if (password.length == 0) {
      return 'Debe ingresar su contraseña';
    }
    return null;
  }

  _getDeviceToken() async {
    // Get the token for this device
    _fcm_id = await _firebaseMessaging.getToken();
  }

  void _submit() {
    if (_loginFormKey.currentState.validate()) {
     _loginFormKey.currentState.save();

      // dismiss keyboard during async call
      FocusScope.of(context).requestFocus(new FocusNode());

      // start the modal progress HUD
      setState(() {
        _isInAsyncCall = true;
      });

      //Login user
      Map<String, String> headers = {
                                     'Content-Type': 'application/x-www-form-urlencoded',
                                     'Authorization': 'Basic aGVuZGktY2xpZW50OmhlbmRpLXNlY3JldA=='
                                    };

      http.post(USER_LOGIN, headers: headers, body: {"username": _username, "password": _password, "grant_type": "password"}).then((rta) async {
        if (rta.statusCode == 200 && rta.body.length > 0) {
          Map data_login = json.decode(rta.body);
          print('Response first:'+  data_login['access_token']);
          Map<String, String> headers_user = {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': 'Bearer '+data_login['access_token']
          };
          http.post(USER_DETAIL+"/$_fcm_id", headers: headers_user).then((rta) async {
            if (rta.statusCode == 200 && rta.body.length > 0) {
              setState(() {
                _isInAsyncCall = false;
              });

              List<dynamic> _listViewData = [];
              _listViewData = json.decode(rta.body);

              _isInvalidAsyncUser = true;

              SharedPreferences prefs = await SharedPreferences.getInstance();
              setState(() {
                prefs.setString('userEmail', _listViewData[0]['username']);
                prefs.setInt('id', _listViewData[0]['id']);
                prefs.setInt('usertype', _listViewData[0]['usertype']);
                prefs.setString('fullname', _listViewData[0]['fullname']);
              });


              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new  ViewPage() )
              );
            }
          });


        } else {
          setState(() {
            _isInAsyncCall = false;
          });
          Map data = json.decode(rta.body);
          print('Response code error: ' + data["error_description"]);
          String msg = data["error_description"] == "Bad credentials" ? "Usuario o contraseña incorrecta" : "Fallo el inicio de sesión";
          AlertNotification.alert(context, "Aviso importante",msg, "Aceptar");
        }
        // stop the modal progress HUD

      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(239, 65, 3, 1),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      // display modal progress HUD (heads-up display, or indicator)
      // when in async call
      body: ModalProgressHUD(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: buildLoginForm(context),
          ),
        ),
        inAsyncCall: _isInAsyncCall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
      resizeToAvoidBottomPadding: true,
    );
  }

  Widget buildLoginForm(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final leftSection = new Container(
      child: GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new RecoveryPage())
        );
      },
      child: Text("¿Olvidaste la contraseña?",
          style: TextStyle(
            color: Color.fromARGB(255, 74, 144, 226),
            fontSize: 14,
            letterSpacing: 0.22,
            fontFamily: "Helvetica",
          ),
          textAlign: TextAlign.center,


      ),
      )
    );

    final rightSection = new Container(
        margin: EdgeInsets.only(left: 17, top: 0, right: 0, bottom: 0),
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new NewUserPage()
                ));
          },
          child: Text("Usuario nuevo",
              style: TextStyle(
                color: Color.fromARGB(255, 74, 144, 226),
                fontSize: 14,
                letterSpacing: 0.22,
                fontFamily: "Helvetica",
              ),
              textAlign: TextAlign.center
          ),
        )
    );
    // run the validators on reload to process async results
    _loginFormKey.currentState?.validate();
    return Form(
      key: this._loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 20),
            child: Image.asset(
              "images/icon.png",
              width: 118,
              height: 118,
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 11),
              child: Text(
                "Bienvenido a Turnet",
                style: TextStyle(
                  color: Color.fromARGB(255, 99, 99, 99),
                  fontSize: 18,
                  fontFamily: "Helvetica",
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 17, top: 20, right: 15, bottom: 10),
            child: TextFormField(
              autofocus: false,
              initialValue: '',
              obscureText: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Usuario',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              style: TextStyle(
                  color: Color.fromARGB(255, 184, 184, 184),
                  fontSize: 14,
                  letterSpacing: 0.22,
                  fontFamily: "Helvetica",
                  height: 1.3),
              validator: (val) => !EmailValidator.validate(val, true)
                  ? 'Email incorrecto.'
                  : null,
              keyboardType: TextInputType.emailAddress,
              onSaved: (value) => _username = value,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 17, top: 15, right: 15, bottom: 15),
            child: TextFormField(
              autofocus: false,
              initialValue: '',
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Contraseña',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0)),
              ),
              style: TextStyle(
                  color: Color.fromARGB(255, 184, 184, 184),
                  fontSize: 14,
                  letterSpacing: 0.22,
                  fontFamily: "Helvetica",
                  height: 1.3),
              validator: _validatePassword, //Validations field
              onSaved: (value) => _password = value,
            ),
          ),
          Container(
            constraints: BoxConstraints.expand(height: 45),
            margin: EdgeInsets.only(left: 17, top: 10, right: 15, bottom: 10),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 65, 143, 222),
              borderRadius: BorderRadius.all(Radius.circular(24.5)),
            ),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: _submit, //Submit form
              padding: EdgeInsets.all(12),
              color: Color.fromRGBO(235,69,3,1),
              child: Text('Iniciar sesión',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 17,
                      letterSpacing: 0.27,
                      fontFamily: "Helvetica")),
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 17, top: 15, right: 0, bottom: 12),

            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new RecoveryPage())
                );
              },
              child: Text("¿Olvidaste la contraseña?",
                style: TextStyle(
                  color: Color.fromARGB(255, 74, 144, 226),
                  fontSize: 14,
                  letterSpacing: 0.22,
                  fontFamily: "Helvetica",
                ),
                textAlign: TextAlign.center,


              ),
            )
          ),
          Container(
            margin: EdgeInsets.only(left: 17, top: 10, right: 0, bottom: 0),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new NewUserPage()
                    ));
              },
              child: Text("Usuario nuevo",
                  style: TextStyle(
                    color: Color.fromARGB(255, 74, 144, 226),
                    fontSize: 14,
                    letterSpacing: 0.22,
                    fontFamily: "Helvetica",
                  ),
                  textAlign: TextAlign.center
              ),
            ),
          ),

        ],
      ),
    );
  }
}
