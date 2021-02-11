import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakulima/services/auth.dart';
import 'package:wakulima/services/database.dart';
import 'package:wakulima/views/chatRoomScreen.dart';
import 'package:wakulima/views/veterinary.dart';

import 'maps.dart';

class Vets extends StatefulWidget {
  final String name;

  Vets({this.name});
  @override
  _VetsState createState() => _VetsState();
}

class _VetsState extends State<Vets> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();
  String url = 'tel:+254718273753';

  QuerySnapshot recordsSnapshot;
  DocumentSnapshot userSnapshot;
  FirebaseUser username;

  String email;
  double total = 0.0;
  String userId;
  void _getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      userId = user.uid;
    });
  }

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

  Future<void> callnow(phone) async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      // throw 'call not possible';
      print('call cannot go through');
    }
  }

  Widget recordTile() {
    return recordsSnapshot != null
        ? ListView.builder(
            itemCount: recordsSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // padding: EdgeInsets.only(bottom: 10.0),
                  height: 350.0,
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

                          Column(
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
                                height: 12.0,
                              ),
                              Center(
                                child: Center(
                                  child: Text(
                                      ' ${recordsSnapshot.documents[index].data["name"]} : ${recordsSnapshot.documents[index].data["phone_number"]}',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        fontFamily: 'Nunito-Regular',
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              Center(
                                child: Text(
                                    'Specialization: ${recordsSnapshot.documents[index].data["specialization"]}',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontFamily: 'Nunito-Regular',
                                    )),
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              Center(
                                child: Text(
                                    'Experience: ${recordsSnapshot.documents[index].data["experience"]} years',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontFamily: 'Nunito-Regular',
                                    )),
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              Center(
                                child: Text(
                                    'Charges per service: ${recordsSnapshot.documents[index].data["Charges"]} Kshs',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontFamily: 'Nunito-Regular',
                                    )),
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              Center(
                                child: Text(
                                    'Working Hours: ${recordsSnapshot.documents[index].data["working hours"]}',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontFamily: 'Nunito-Regular',
                                    )),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Ink(
                                      decoration: const ShapeDecoration(
                                        color: Colors.green,
                                        shape: CircleBorder(),
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.call),
                                        color: Colors.white,
                                        tooltip: "Call",
                                        onPressed: () {
                                          callnow(
                                              'tel:${recordsSnapshot.documents[index].data["phone_number"]}');
                                        },
                                      ),
                                    ),
                                    Text("Call"),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Column(
                                children: [
                                  Ink(
                                    decoration: const ShapeDecoration(
                                      color: Colors.blue,
                                      shape: CircleBorder(),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.message),
                                      color: Colors.white,
                                      tooltip: "Message",
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatRoom()));
                                      },
                                    ),
                                  ),
                                  Text("Message")
                                ],
                              )),
                              Expanded(
                                  child: Column(
                                children: [
                                  Ink(
                                    decoration: const ShapeDecoration(
                                      color: Colors.black,
                                      shape: CircleBorder(),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.location_searching),
                                      color: Colors.white,
                                      tooltip: "Location",
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Maps()));
                                      },
                                    ),
                                  ),
                                  Text("Locate Vet"),
                                ],
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            })
        : Container();
  }

  checkRole(DocumentSnapshot snapshot) {
    if (snapshot.data == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (snapshot.data['veterinary'] == true) {
      return adminPage(snapshot);
    } else {
      return userPage(snapshot);
    }
  }

  adminPage(DocumentSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Register Vet'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegisterVet(name: widget.name)));
            },
          ),
          ListTile(
            title: Text('Chats'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ChatRoom()));
            },
          ),
        ],
      ),
    );
  }

  Center userPage(DocumentSnapshot snapshot) {
    return Center(child: Text(""));
  }

  @override
  void initState() {
    initiateSearch();
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Veterinary'),
            ),
            StreamBuilder<Object>(
                stream: Firestore.instance
                    .collection('wakulima')
                    .document(userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                    // return Container();
                  } else if (snapshot.hasData) {
                    return checkRole(snapshot.data);
                  }
                  return CircularProgressIndicator();
                }),
          ],
        ),
      ),
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
                      ]),
                );
              }),
        ),
      ),
    );
  }
}
