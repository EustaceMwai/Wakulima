import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wakulima/model/user.dart';
import 'package:wakulima/services/auth.dart';
import 'package:wakulima/services/database.dart';
import 'package:wakulima/widgets/widget.dart';

import '../views/milk2.dart';

class MilkRecords extends StatefulWidget {
  String email;

  int farmerId;
  String name;
  MilkRecords({this.email, this.farmerId, this.name});

  @override
  _MilkRecordsState createState() => _MilkRecordsState();
}

class _MilkRecordsState extends State<MilkRecords> {
  final formKey = GlobalKey<FormState>();
  TextEditingController todayMilkController = new TextEditingController();
  TextEditingController previousMilkController = new TextEditingController();
  TextEditingController cumulativeMilkController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();
  String selected;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DocumentSnapshot userSnapshot;

  QuerySnapshot recordsSnapshot;
  bool isLoading = false;

  String name = 'eustace';

  String username;

  @override
  void initState() {
    getUserEmail();
    checkAgentName();

    super.initState();
  }

  getUserEmail() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    String email;
    String userId;
    String username;
    final user = await _auth.currentUser();
    setState(() {
      email = user.email;
      userId = user.uid;
      username = user.displayName;
      print(email);
      print(userId);
      print(username);
    });
  }

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  Widget recordList() {
    return recordsSnapshot != null
        ? ListView.builder(
            itemCount: recordsSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return recordTile(
                  id: recordsSnapshot.documents[index].data["id"],
                  name: recordsSnapshot.documents[index].data["name"],
                  kilograms: recordsSnapshot.documents[index].data["kilograms"],
                  date: recordsSnapshot.documents[index].data["date"]);
            })
        : Container();
  }

  initiateSearch() {
    databaseMethods.getFarmerRecordsByEmail().then((val) {
      setState(() {
        recordsSnapshot = val;
      });
    });
  }

  checkAgentName() async {
    FirebaseUser user = await _auth.currentUser();

    databaseMethods.getUserName().then((val) {
      setState(() {
        userSnapshot = val;
      });
    });
  }

  Widget recordTile({String id, String name, String date, dynamic kilograms}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$date',
                style: mediumTextStyle(),
              ),
              Text(
                '$name',
                style: mediumTextStyle(),
              ),
              Text(
                '$kilograms',
                style: mediumTextStyle(),
              )
            ],
          ),
        ],
      ),
    );
  }

  saveFarmerMilk() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    final user = await _auth.currentUser();
    databaseMethods.uploadMilkInfo(User.userId, user.email,
        DateTime.now().toIso8601String(), int.parse(todayMilkController.text));
    todayMilkController.clear();
  }

  Widget inputMilkMissedRecords({String email}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MissedRecords(
                      email: widget.email,
                      name: widget.name,
                      farmerId: widget.farmerId,
                    )));
      },
      child: Container(
        alignment: Alignment.centerRight,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [const Color(0xff007EF4), const Color(0xff2A75BC)]),
            borderRadius: BorderRadius.circular(30)),
        child: Center(
          child: Text(
            "Input missed milk Records",
            style: mediumTextStyle(),
          ),
        ),
      ),
    );
  }

  submitMilk() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await Firestore.instance.collection("farmers").add({
        "email": widget.email,
        'date': new DateFormat.yMd().add_jm().format(DateTime.now()),
        'kilograms': int.parse(todayMilkController.text),
        'farmerId': widget.farmerId,
        'name': widget.name,
        "location": selected,
        "servedBy": userSnapshot["name"],
      });
    }
  }

  Widget displayBoard() {
    List loan = ["Kaheti", "Thunguri", "Karima", "Mukurweini-west"];
    List<DropdownMenuItem> menuItemList = loan
        .map((val) => DropdownMenuItem(value: val, child: Text(val)))
        .toList();
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
        child: Card(
          child: DropdownButtonFormField(
            value: selected,
            validator: (value) =>
                value == null ? 'Please select location' : null,
            onChanged: (val) => setState(() => selected = val),
            items: menuItemList,
            hint: Text("choose location"),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                // height: MediaQuery.of(context).size.height - 50,
                alignment: Alignment.center,
                child: StreamBuilder(
                    stream:
                        Firestore.instance.collection("farmers").snapshots(),
                    builder: (context, snapshot) {
                      if (userSnapshot == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Form(
                              key: formKey,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          const Color(0xff007EF4),
                                          const Color(0xff2A75BC)
                                        ]),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Center(
                                      child: Text(
                                        formatDate(DateTime.now(), [
                                          dd,
                                          '/',
                                          mm,
                                          '/',
                                          yyyy,
                                          ' ',
                                          HH,
                                          ':',
                                          nn
                                        ]),
                                        style: mediumTextStyle(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    validator: (val) {
                                      return val.isEmpty
                                          ? "Cannot be empty"
                                          : null;
                                    },
                                    initialValue:
                                        "Farmer ID: ${widget.farmerId}",
                                    style: simpleTextStyle(),
                                    decoration: InputDecoration(
                                        fillColor: Colors.white54,
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.pink,
                                                width: 2.0))),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  TextFormField(
                                    validator: (val) {
                                      return val.isEmpty
                                          ? "Cannot be empty"
                                          : null;
                                    },
                                    initialValue: widget.name,
                                    style: simpleTextStyle(),
                                    decoration: InputDecoration(
                                        fillColor: Colors.white54,
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.pink,
                                                width: 2.0))),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    validator: (val) {
                                      return val.length > 3
                                          ? "Value cannot be more than 100"
                                          : null;
                                    },
                                    controller: todayMilkController,
                                    style: simpleTextStyle(),
                                    decoration: InputDecoration(
                                        hintText: 'Today Milk Litres Sold',
                                        fillColor: Colors.white54,
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.pink,
                                                width: 2.0))),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  displayBoard(),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  recordList(),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              validator: (val) {
                                return val.isEmpty ? "Cannot be empty" : null;
                              },
                              initialValue: "Served By:${userSnapshot["name"]}",
                              style: simpleTextStyle(),
                              decoration: InputDecoration(
                                  fillColor: Colors.white54,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.pink, width: 2.0))),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                // saveFarmerMilk();
                                setState(() {
                                  print("isloading");
                                  isLoading = true;
                                });
                                submitMilk();
                                setState(() {
                                  isLoading = false;
                                  todayMilkController.clear();
                                });
                              },
                              child: Container(
                                alignment: Alignment.centerRight,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(vertical: 20),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      const Color(0xff007EF4),
                                      const Color(0xff2A75BC)
                                    ]),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                  child: Text(
                                    "Update",
                                    style: mediumTextStyle(),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) => Records()));
                            //   },
                            //   child: Container(
                            //     alignment: Alignment.centerRight,
                            //     width: MediaQuery.of(context).size.width,
                            //     padding: EdgeInsets.symmetric(vertical: 20),
                            //     decoration: BoxDecoration(
                            //         gradient: LinearGradient(colors: [
                            //           const Color(0xff007EF4),
                            //           const Color(0xff2A75BC)
                            //         ]),
                            //         borderRadius: BorderRadius.circular(30)),
                            //     child: Center(
                            //       child: Text(
                            //         "Go to Records",
                            //         style: mediumTextStyle(),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              height: 20,
                            ),
                            inputMilkMissedRecords(),
                          ],
                        ),
                      );
                    }),
              ),
            ),
    );
  }
}
