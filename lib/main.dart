import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool userIsLoggedIn = false;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    if (state == AppLifecycleState.resumed) {
      Firestore.instance.collection("wakulima").document(user.uid).updateData({
        'status': "online",
      });
      print("online");
    } else {
      Firestore.instance.collection("wakulima").document(user.uid).updateData({
        'status': "offline",
        'last_seen': new DateFormat.yMd().add_jm().format(DateTime.now()),
      });
      print("offline");
    }
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
        scaffoldBackgroundColor: Colors.white70,
        primarySwatch: Colors.blue,
      ),
      home: userIsLoggedIn ? MyHomePage() : Authenticate(),
    );
  }
}
