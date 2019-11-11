import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:turnet/utils/alert_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'config/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class HomePage extends StatefulWidget {
  static String tag = 'recovery-page';
  @override
  _HomePageState createState() => new _HomePageState();
}


@JsonSerializable()
class _HomePageState extends State<HomePage> {
  static Future<bool> setName(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString("name", value);
  }

  // maintains validators and state of form fields
  final GlobalKey<FormState> _recoveryFormKey = GlobalKey<FormState>();

  // manage state of modal progress HUD widget
  bool _isInAsyncCall = false;

  String _username;

  bool _isInvalidAsyncUser = false; // managed after response from server

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

  void _submit() {
    if (_recoveryFormKey.currentState.validate()) {
      _recoveryFormKey.currentState.save();

      // dismiss keyboard during async call
      FocusScope.of(context).requestFocus(new FocusNode());

      // start the modal progress HUD
      setState(() {
        _isInAsyncCall = true;
      });

      //Recovery password
      Map<String, String> headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({"employeeNumber": _username});
      http.post(RECOVERY_PASSWORD, headers: headers, body: body).then((rta) {
        if (rta.statusCode == 200 && rta.body.length > 0) {
          Map data = json.decode(rta.body);
          if (data["code"] != "OK" || data["data"] == null)
            _isInvalidAsyncUser = true;
          else if (data["data"]["message"] == "Usuario no Existe") {
            _isInvalidAsyncUser = true;
          } else {
            _recoveryFormKey.currentState.reset();
            AlertNotification.alert(
                context,
                "Tu solicitud ha sido recibida",
                "Revisa tu correo electrónico y sigue las instrucciones para reestablecer tu contraseña",
                "Listo");
          }
        } else {
          print('Response code: ' + rta.statusCode.toString());
          AlertNotification.alert(context, "Aviso importante",
              "Fallo recuperación de contraseña", "Aceptar");
        }
        // stop the modal progress HUD
        setState(() {
          _isInAsyncCall = false;
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Turnet'),
        backgroundColor: Color.fromRGBO(239, 65, 3, 1),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          InkWell(
              onTap: () {
                print ('Click Profile Pic');
              },

              child: ClipRRect(

                borderRadius: BorderRadius.circular(100),
                child: new IconButton(icon: Image.asset(
                    "images/icon.png",

                ),
                  onPressed: null,
                  iconSize: 45,
                  color: Colors.green,
                  disabledColor: Colors.white,
                ),
              )

          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.mail),
            title: new Text('Messages'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile')
          )
        ],
      ),
    );
  }
}
