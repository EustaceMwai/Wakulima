import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wakulima/model/user.dart';
import 'package:wakulima/services/auth.dart';
import 'package:wakulima/services/database.dart';
import 'package:wakulima/views/records.dart';
import 'package:wakulima/widgets/widget.dart';

class MilkRecords extends StatefulWidget {
  String userId;

  MilkRecords({this.userId});

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

  QuerySnapshot recordsSnapshot;
  FirebaseUser username;
  String name = 'eustace';
  String email;

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

//  saveFarmerMilk() {
//    Map<String, dynamic> farmerSale = {
//      "id": user.userId,
//      "name": name,
//      "date": DateTime.now().toIso8601String(),
//      "Kgs": todayMilkController.text
//    };
//}
  //  databaseMethods.uploadMilkInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.center,
          child: StreamBuilder(
              stream: Firestore.instance.collection("farmers").snapshots(),
              builder: (context, snapshot) {
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
                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(
                                child: Text(
                                  DateTime.now().toIso8601String(),
                                  style: mediumTextStyle(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                return val.isEmpty ? "Cannot be empty" : null;
                              },
                              controller: todayMilkController,
                              style: simpleTextStyle(),
                              decoration: InputDecoration(
                                  hintText: 'Today Milk Kgs',
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
                              height: 50,
                            ),
                            recordList(),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
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
                                  "Cumulative",
                                  style: mediumTextStyle(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        onTap: () {
//                      saveFarmerMilk();
                          databaseMethods.uploadMilkInfo(
                              User.userId,
                              name,
                              DateTime.now().toIso8601String(),
                              int.parse(todayMilkController.text));
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Records()));
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
                              "Go to Records",
                              style: mediumTextStyle(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
