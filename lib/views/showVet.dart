import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakulima/services/auth.dart';
import 'package:wakulima/services/database.dart';
import 'package:wakulima/views/chatRoomScreen.dart';

import 'maps.dart';

class Vets extends StatefulWidget {
  @override
  _VetsState createState() => _VetsState();
}

class _VetsState extends State<Vets> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();
  String url = 'tel:+254718273753';

  QuerySnapshot recordsSnapshot;
  FirebaseUser username;

  String email;
  double total = 0.0;

  // Widget recordList() {
  //   return recordsSnapshot != null
  //       ? ListView.builder(
  //           itemCount: recordsSnapshot.documents.length,
  //           shrinkWrap: true,
  //           itemBuilder: (context, index) {
  //             return recordTile(
  //               email: recordsSnapshot.documents[index].data["email"],
  //               name: recordsSnapshot.documents[index].data["name"],
  //             );
  //           })
  //       : Container();
  // }

  initiateSearch() {
    databaseMethods.getVeterinaries().then((val) {
      setState(() {
        recordsSnapshot = val;
      });
    });
  }

  Future<void> callnow() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // throw 'call not possible';
      print('call cannot go through');
    }
  }

  Widget recordTile() {
    return Container(
      // padding: EdgeInsets.only(bottom: 10.0),
      height: 300.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.green, spreadRadius: 3),
        ],
      ),
      child: SingleChildScrollView(
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 70,
                width: 70,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          'assets/images/wakulima.png',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),

              Icon(Icons.person_pin),
              // Center(
              //   child: Text(
              //     '$name',
              //     // style: mediumTextStyle()
              //     style: TextStyle(
              //       fontSize: 17.0,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              recordsSnapshot != null
                  ? ListView.builder(
                      itemCount: recordsSnapshot.documents.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Center(
                              child: Text(
                                  recordsSnapshot
                                      .documents[index].data["email"],
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            SizedBox(
                              height: 24.0,
                            ),
                            Center(
                              child: Text(
                                  recordsSnapshot.documents[index].data["name"],
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontFamily: 'Nunito-Regular',
                                  )),
                            ),
                          ],
                        );
                      })
                  : Container(),
              // SizedBox(
              //   height: 12.0,
              // ),
              // SizedBox(
              //   height: 12.0,
              // ),
              // Center(
              //   child: Text(
              //     'Email: $email',
              //     // style: mediumTextStyle(),
              //     style: TextStyle(
              //       fontSize: 17.0,
              //       fontFamily: 'Nunito-Regular',
              //     ),
              //   ),
              // ),
              IconButton(
                icon: Icon(Icons.location_searching),
                color: Colors.green,
                onPressed: () {},
              ),
              FlatButton(
                color: Colors.black,
                child: Row(
                  children: [
                    Expanded(
                      child: Icon(
                        Icons.location_searching,
                        color: Colors.green,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "locate \n vet ",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Maps()));
                },
              )
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Veterinaries'),
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height - 50,
          // alignment: Alignment.topCenter,
          child: StreamBuilder(
              stream: Firestore.instance.collection("wakulima").snapshots(),
              builder: (context, snapshot) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        recordTile(),
                        SizedBox(
                          height: 420,
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.green,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.green,
                                            spreadRadius: 3),
                                      ],
                                    ),
                                    child: FlatButton(
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: IconButton(
                                            icon: Icon(Icons.call),
                                            onPressed: () {
                                              // callnow();
                                            },
                                          )),
                                          Expanded(
                                              flex: 2,
                                              child: Text(
                                                "Call \n vet ",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                        ],
                                      ),
                                      onPressed: () {
                                        callnow();
                                      },
                                    )),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.blue,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.blue,
                                              spreadRadius: 3),
                                        ],
                                      ),
                                      child: FlatButton(
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Icon(Icons.message)),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "Chat \n vet",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatRoom()));
                                        },
                                      ))),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black,
                                              spreadRadius: 3),
                                        ],
                                      ),
                                      child: FlatButton(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Icon(
                                                Icons.location_searching,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "locate \n vet ",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Maps()));
                                        },
                                      ))),
                            ],
                          ),
                        )
                      ]),
                );
              }),
        ),
      ),
    );
  }
}
