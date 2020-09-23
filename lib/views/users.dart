import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wakulima/model/user.dart';
import 'package:wakulima/services/auth.dart';
import 'package:wakulima/services/database.dart';
import 'package:wakulima/widgets/widget.dart';

class Users extends StatefulWidget {
  String userId;

  Users({this.userId});

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
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
  double total = 0.0;

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
                email: recordsSnapshot.documents[index].data["email"],
              );
            })
        : Container();
  }

  initiateSearch() {
    databaseMethods.getAllUsers().then((val) {
      setState(() {
        recordsSnapshot = val;
      });
    });
  }

  Widget recordTile({String email}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 50,
        height: 50,
        child: Card(
          child: Center(
            child: Text(
              '$email',
              // style: mediumTextStyle(),
            ),
          ),
        ),
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
  void initState() {
    initiateSearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.topCenter,
          child: StreamBuilder(
              stream: Firestore.instance.collection("users").snapshots(),
              builder: (context, snapshot) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    recordList(),
                  ]),
                );
              }),
        ),
      ),
    );
  }
}
