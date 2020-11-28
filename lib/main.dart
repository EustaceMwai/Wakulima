import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mpesa_flutter_plugin/initializer.dart';
import 'package:wakulima/views/home.dart';
import 'package:wakulima/views/keys.dart';

import 'helper/autheticate.dart';
import 'helper/helperfunctions.dart';

void main() {
  MpesaFlutterPlugin.setConsumerKey(kConsumerKey);
  MpesaFlutterPlugin.setConsumerSecret(kConsumerSecret);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        // scaffoldBackgroundColor: Color(0xff1F1F1F),
        scaffoldBackgroundColor: Colors.white54,
        primarySwatch: Colors.blue,
      ),
      home: userIsLoggedIn ? MyHomePage() : Authenticate(),
    );
  }
}
