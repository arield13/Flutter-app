import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:turnet/utils/alert_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'config/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RecoveryPage extends StatefulWidget {
  static String tag = 'home';
  @override
  _RecoveryPageState createState() => new _RecoveryPageState();
}

@JsonSerializable()
class _RecoveryPageState extends State<RecoveryPage> {
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
    // run the validators on reload to process async results
    _recoveryFormKey.currentState?.validate();
    return Form(
      key: this._recoveryFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            child: Text(
              "¿Olvidaste tu contraseña?",
              style: TextStyle(
                color: Color.fromARGB(255, 99, 99, 99),
                fontSize: 18,
                fontFamily: "Helvetica",
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            child: Container(
              width: 222,
              margin: EdgeInsets.only(top: 10),
              child: Text(
                "Escribe tu usuario y te enviaremos las instucciones para reestablecerla",
                style: TextStyle(
                  color: Color.fromARGB(153, 0, 0, 0),
                  fontSize: 12,
                  fontFamily: "Helvetica",
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 17, top: 30, right: 15, bottom: 10),
            child: TextFormField(
              autofocus: false,
              initialValue: '',
              obscureText: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Usuario',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
              keyboardType: TextInputType.number, //Keyboard number
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
            constraints: BoxConstraints.expand(height: 45),
            margin: EdgeInsets.only(left: 17, top: 20, right: 15),
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
              child: Text('Enviar',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 17,
                      letterSpacing: 0.27,
                      fontFamily: "Helvetica")),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            child: Container(
              width: 314,
              margin: EdgeInsets.only(top: 28),
              child: Text(
                "Si olvidaste tu usuario, escríbenos a",
                style: TextStyle(
                  color: Color.fromARGB(153, 0, 0, 0),
                  fontSize: 12,
                  fontFamily: "Helvetica",
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            child: Container(
              width: 314,
              child: Text(
                "info@cimit.co",
                style: TextStyle(
                  color: Color.fromARGB(255, 74, 144, 226),
                  fontSize: 12,
                  fontFamily: "Helvetica",
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
