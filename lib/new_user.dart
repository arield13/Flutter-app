import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:turnet/utils/alert_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'config/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:turnet/login_page.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class NewUserPage extends StatefulWidget {
  static String tag = 'recovery-page';
  @override
  _RecoveryPageState createState() => new _RecoveryPageState();
}

@JsonSerializable()
class _RecoveryPageState extends State<NewUserPage> {
  static Future<bool> setName(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("name", value);
  }

  // maintains validators and state of form fields
  final GlobalKey<FormState> _createUserFormKey = GlobalKey<FormState>();

  // manage state of modal progress HUD widget
  bool _isInAsyncCall = false;

  String _username;
  String _email;
  String _user_type = "Cliente";
  String _latitude;
  String _longitude;
  String _fcm_id;
  String _user_img = "user.png";
  String _password;
  String _repeat_password;

  //var value;
  bool isExpanded = false;

  bool _isInvalidAsyncUser = false; // managed after response from server

  _saveDeviceToken() async {
    // Get the current user
    String uid = 'jeffd23';
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    _fcm_id = await _firebaseMessaging.getToken();
    print("TockenArielin: $_fcm_id");

  }

  // validate user name
  String _validateUserName(String userName) {
    if (userName.length == 0) {
      return 'Debe ingresar su usuario';
    }
    if (_isInvalidAsyncUser) {
      // disable message until after next async call
      _isInvalidAsyncUser = false;
      return 'Usuario no encontrado!';
    }

    return null;
  }

// validate password
  String _validatePassword(String password) {
    if (password.length == 0) {
      return 'Debe ingresar su contraseña';
    }
    return null;
  }

  // validate password
  String _validatePassword2(String password) {
    if (password.length == 0) {
      return 'Debe repetir su contraseña';
    }
    return null;
  }

  // validate email
  String _validateEmail(String email) {
    if (email.length == 0) {
      return 'Debe ingresar su email';
    }
    return null;
  }

  void _submit() {
    print("Por akaaaa.");
    if (_createUserFormKey.currentState.validate()) {
      _createUserFormKey.currentState.save();
      //print("Por iiiikaaaa. $_user_type");
      // dismiss keyboard during async call
      FocusScope.of(context).requestFocus(new FocusNode());

      // start the modal progress HUD
      setState(() {
        _isInAsyncCall = true;
      });

      //Login user
      Map<String, String> headers = {'Content-Type': 'application/json'};
      final body =  jsonEncode({
        "username": _email,
        "password": _password,
        "fullname": _username,
        "usertype": (_user_type == "Cliente" ? 1 : 2),
        "latitude": "243213421",
        "longitude": "2314313",
        "fcm_id": _fcm_id,
        "user_img": _user_img
      });

      http.post(USER_CREATE, headers: headers, body: body).then((rta) async {
        if (rta.statusCode == 200 && rta.body.length > 0) {
          AlertNotification.alert(context, "Aviso importante",
              "Usuario creado exitosamente", "Aceptar");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
        }

       // print("Por vvv akaaaajjj. $rta");
        // stop the modal progress HUD
        setState(() {
          _isInAsyncCall = false;
        });
      });
    }
  }

  @override
  void initState() {
     _saveDeviceToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        titleSpacing: -28.4,
        backgroundColor: Color.fromRGBO(239, 65, 3, 1),
        centerTitle: true,
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

    final List<String> _dropdownValues = [
      "Cliente",
      "Negocio",
    ];
    // run the validators on reload to process async results
    _createUserFormKey.currentState?.validate();

    return Form(
      key: this._createUserFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
           child: new IconButton(icon: Icon(Icons.person),
               onPressed: null,
             iconSize: 118,
           )
          ),
          Container(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 0),
              child: Text(
                "Usuario Nuevo",
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
          Center(
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(17.0),
                  child: OutlineDropdownButton(
                    style: TextStyle(
                        color: Color.fromARGB(255, 184, 184, 184),
                        fontSize: 14,
                        letterSpacing: 0.22,
                        fontFamily: "Helvetica",
                        height: 1.3),
                    elevation: 6,
                    inputDecoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32)),
                      contentPadding: EdgeInsets.fromLTRB(16, -4, 16, -4),
                      fillColor: Colors.white,
                    ),
                    items: _dropdownValues
        .map((value) => DropdownMenuItem(
    child: Text(value),
    value: value,
    )).toList(),
                    isExpanded: true,
                    hint: Text("Tipo de usuario"),
                    onChanged: (newVal) {
                      //print("--- $newVal");
                      _user_type = newVal;
                      setState(() {});
                    },
                    value: _user_type,

                  ),

                ),
              ])),
          Container(
            margin: EdgeInsets.only(left: 17, top: 5, right: 15, bottom: 15),
            child: TextFormField(
              autofocus: false,
              initialValue: '',
              obscureText: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Email',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              validator: (val) => !EmailValidator.validate(val, true)
                  ? 'Email incorrecto.'
                  : null,
              keyboardType: TextInputType.emailAddress, //Keyboard number
              style: TextStyle(
                  color: Color.fromARGB(255, 184, 184, 184),
                  fontSize: 14,
                  letterSpacing: 0.22,
                  fontFamily: "Helvetica",
                  height: 1.3),
              onSaved: (value) => _email = value,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 17, top: 5, right: 15, bottom: 15),
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
              keyboardType: TextInputType.text, //Keyboard number
              style: TextStyle(
                  color: Color.fromARGB(255, 184, 184, 184),
                  fontSize: 14,
                  letterSpacing: 0.22,
                  fontFamily: "Helvetica",
                  height: 1.3),
              validator: _validateUserName, //Validations field
              onSaved: (value) => _username = value,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 17, top: 5, right: 15, bottom: 15),
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
            margin: EdgeInsets.only(left: 17, top: 5, right: 15, bottom: 15),
            child: TextFormField(
              autofocus: false,
              initialValue: '',
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Repetir Contraseña',
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
              onSaved: (value) => _repeat_password = value,
            ),
          ),
          Container(
            constraints: BoxConstraints.expand(height: 45),
            margin: EdgeInsets.only(left: 17, top: 5, right: 15, bottom: 17),
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
              color: Color.fromRGBO(235, 69, 3, 1),
              child: Text('Registrarme',
                  style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 17,
                  letterSpacing: 0.27,
                  fontFamily: "Helvetica")),
            ),
          ),
        ],
      ),
    );
  }
}
