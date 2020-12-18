import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wakulima/helper/autheticate.dart';
import 'package:wakulima/services/auth.dart';
import 'package:wakulima/services/database.dart';
import 'package:wakulima/views/admin.dart';
import 'package:wakulima/views/adminManager.dart';
import 'package:wakulima/views/records.dart';
import 'package:wakulima/views/showVet.dart';

import 'bottom.dart';

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
  DatabaseMethods databaseMethods = new DatabaseMethods();

  DocumentSnapshot userSnapshot;

  String userid;
  void _getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    userid = user.uid;
  }

  checkRole(DocumentSnapshot snapshot) {
    if (snapshot.data['admin'] == true) {
      return ListTile(
        title: Text("Go to Dairy"),
      );
    } else {
      return Text('You are not an admin');
    }
  }

  checkIfAdmin() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    return await Firestore.instance
        .collection("users")
        .document(user.uid)
        .snapshots();
  }

  initiateSearch() async {
    FirebaseUser user = await _auth.currentUser();

    databaseMethods.getUserName().then((val) {
      setState(() {
        userSnapshot = val;
      });
    });
  }

  // Widget userHome() {
  //   return userSnapshot != null
  //       ? ListView.builder(
  //           itemCount: userSnapshot.documentID.,
  //           shrinkWrap: true,
  //           itemBuilder: (context, index) {
  //             return userName(
  //               name: userSnapshot["name"],
  //             );
  //           })
  //       : Container();
  // }

  Widget userHome() {
    return userSnapshot != null
        ? Container(
            child: userName(name: userSnapshot["name"]),
          )
        : Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  Widget userName({String name}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.green, spreadRadius: 3),
          ],
        ),
        height: 200.0,
        child: Card(
          elevation: 10,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.4), BlendMode.dstATop),
                    image: new AssetImage(
                      "assets/images/c1.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                  child: Text(
                'Welcome $name',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    initiateSearch();
    super.initState();

    // _getUser();
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
              // StreamBuilder<DocumentSnapshot>(
              //   stream: Firestore.instance
              //       .collection('users')
              //       .document(userid)
              //       .snapshots(),
              //   builder: (BuildContext context,
              //       AsyncSnapshot<DocumentSnapshot> snapshot) {
              //     if (snapshot.hasError) {
              //       return Text('Error');
              //     }
              //     print("error");
              //     switch (snapshot.connectionState) {
              //       case ConnectionState.waiting:
              //         return Text('Loading...');
              //       case ConnectionState.active:
              //         return checkRole(snapshot.data);
              //       default:
              //         return Text("wait");
              //     }
              //   },
              // ),
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  authMethods.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Authenticate()));
                },
              ),
              // SizedBox(
              //   height: 10,
              // ),
              // ListTile(
              //   title: Text('search'),
              //   onTap: () {
              //     authMethods.signOut();
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => Example()));
              //   },
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // ListTile(
              //   title: Text('mpesa'),
              //   onTap: () {
              //     authMethods.signOut();
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => Mpesa()));
              //   },
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // ListTile(
              //   title: Text('slider'),
              //   onTap: () {
              //     authMethods.signOut();
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => SliderExample()));
              //   },
              // ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text("Wakulima"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(1), BlendMode.dstATop),
            image: AssetImage("assets/images/c2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: StreamBuilder(
              stream: Firestore.instance.collection("wakulima").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (userSnapshot == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    userHome(),
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
                                      builder: (context) => Admin()));
                            },
                            child: Card(
                                elevation: 10,
                                child: Center(
                                    child: Text(
                                  'Dairy',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ))),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdminManager()));
                            },
                            child: Card(
                              elevation: 10,
                              child: Center(
                                  child: Text(
                                'Manager',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Records()));
                            },
                            child: Card(
                              elevation: 10,
                              child: Center(
                                  child: Text(
                                'Dairy Records',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Vets()));
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
                );
              }),
        ),
      ),
    );
  }
}
