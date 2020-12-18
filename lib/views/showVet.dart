import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  QuerySnapshot recordsSnapshot;
  FirebaseUser username;

  String email;
  double total = 0.0;

  Widget recordList() {
    return recordsSnapshot != null
        ? ListView.builder(
            itemCount: recordsSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return recordTile(
                email: recordsSnapshot.documents[index].data["email"],
                name: recordsSnapshot.documents[index].data["name"],
              );
            })
        : Container();
  }

  initiateSearch() {
    databaseMethods.getVeterinaries().then((val) {
      setState(() {
        recordsSnapshot = val;
      });
    });
  }

  Widget recordTile({
    String email,
    String name,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => ChatRoom()));
      },
      child: Container(
        // padding: EdgeInsets.only(bottom: 10.0),
        height: 200.0,
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
                Center(
                  child: Text(
                    '$name',
                    // style: mediumTextStyle()
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                SizedBox(
                  height: 12.0,
                ),
                Center(
                  child: Text(
                    'Email: $email',
                    // style: mediumTextStyle(),
                    style: TextStyle(
                      fontSize: 17.0,
                      fontFamily: 'Nunito-Regular',
                    ),
                  ),
                ),
              ],
            ),
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
                        recordList(),
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
                                          Expanded(child: Icon(Icons.call)),
                                          Expanded(
                                              flex: 2,
                                              child: Text(
                                                "Call \n vet ",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                        ],
                                      ),
                                      onPressed: () {},
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
    ;
  }
}
