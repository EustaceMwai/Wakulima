import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wakulima/helper/autheticate.dart';
import 'package:wakulima/services/auth.dart';
import 'package:wakulima/views/users.dart';

import 'bottom.dart';
import 'maps2.dart';
import 'milk.dart';

class MyHomePage extends StatefulWidget {
  final String userId;

  MyHomePage({this.userId});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AuthMethods authMethods = new AuthMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  FirebaseUser user;

  checkRole(DocumentSnapshot snapshot) {
    if (snapshot.data['admin'] == true) {
      return ListTile(
        title: Text("Go to Dairy"),
      );
    } else {
      return Text('You are not an admin');
    }
  }

  Future checkIfAdmin() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    return await Firestore.instance
        .collection("users")
        .document(user.uid)
        .snapshots();
  }

  @override
  void initState() {
    // TODO: implement initState
    checkIfAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text('Choose'),
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: checkIfAdmin(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error');
                  }
                  print("error");
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text('Loading...');
                    case ConnectionState.active:
                      return checkRole(snapshot.data);
                    default:
                      return Text("wait");
                  }
                },
              ),
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  authMethods.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Authenticate()));
                },
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text("Wakulima"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 200.0,
              child: Card(
                elevation: 10,
                child: Center(
                    child: Text(
                  'Welcome Eustace',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MilkRecords()));
                    },
                    child: Card(
                      elevation: 10,
                      child: Center(
                          child: Text(
                        'Dairy',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => Loan()));
                    },
                    child: Card(
                      elevation: 10,
                      child: Center(
                          child: Text(
                        'Loans',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Users()));
                    },
                    child: Card(
                      elevation: 10,
                      child: Center(
                          child: Text(
                        'Users',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MapView()));
                    },
                    child: Card(
                      elevation: 10,
                      child: Center(
                          child: Text(
                        'Veterinary',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            BottomNavigationWidget(),
          ],
        ),
      ),
    );
  }
}
