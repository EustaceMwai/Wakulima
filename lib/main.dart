import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wakulima/pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wakulima',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        accentColor: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Welcome to Wakulima App'),
    );
  }
}


