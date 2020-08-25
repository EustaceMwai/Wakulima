import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wakulima/model/user.dart';
import 'package:wakulima/services/auth.dart';
import 'package:wakulima/services/database.dart';
import 'package:wakulima/widgets/widget.dart';

class Records extends StatefulWidget {
  String userId;

  Records({this.userId});

  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
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
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    recordList(),
                    GestureDetector(
                      onTap: () {
                        initiateSearch();
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
                            "show Records",
                            style: mediumTextStyle(),
                          ),
                        ),
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
