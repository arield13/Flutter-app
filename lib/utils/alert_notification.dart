import 'package:flutter/material.dart';
import 'custom_show_dialog.dart';

class AlertNotification {
  static Future<void> alert(context, title, message, button) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          content: new Container(
            width: 260.0,
            height: 170.0,
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              color: const Color(0xFFFFFF),
              borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // dialog top
                new Expanded(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        decoration: new BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Text(
                          title,
                          style: TextStyle(
                              fontFamily: "Helvetica",
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                // dialog centre
                new Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Helvetica",
                            fontSize: 15,
                          ),
                        ),
                      )
                    ],
                  ),
                  flex: 2,
                ),

                // dialog bottom
                Container(
                    margin: EdgeInsets.only(top: 20),
                    child: ButtonTheme(
                        minWidth: 100.0,
                        height: 50.0,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          padding: EdgeInsets.all(12),
                          color: Color.fromRGBO(235, 69, 3, 1),
                          child: Text(button,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 15,
                                  letterSpacing: 0.27,
                                  fontFamily: "Helvetica")),
                        ))),
              ],
            ),
          ),
        );
      },
    );
  }
}
