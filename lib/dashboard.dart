import 'package:flutter/material.dart';
import 'view.dart';

void main() {
  runApp(
      new MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: Colors.blue
          ),
          home: ViewPage()
      )
  );
}