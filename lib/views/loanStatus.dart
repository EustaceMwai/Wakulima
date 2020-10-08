import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wakulima/model/user.dart';
import 'package:wakulima/services/auth.dart';
import 'package:wakulima/services/database.dart';
import 'package:wakulima/widgets/widget.dart';

class loanStatus extends StatefulWidget {
  String userId;

  @override
  _loanStatusState createState() => _loanStatusState();
}

class _loanStatusState extends State<loanStatus> {
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
                  loan: recordsSnapshot.documents[index].data["loan"],
                  loanStatus:
                      recordsSnapshot.documents[index].data["loan status"],
                  repayment: recordsSnapshot
                      .documents[index].data["repayment period"]);
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

  Widget recordTile({int loan, String loanStatus, int repayment}) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              'Loan applied: $loan',
              // style: mediumTextStyle(),
            ),
          ),
          Center(
            child: Text(
              'THe status of the loan is: $loanStatus',
              // style: mediumTextStyle(),
            ),
          ),
          Center(
            child: Text(
              'The repayment period of your loan is: $repayment',
              // style: mediumTextStyle(),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: 8.0),
          //   child: Card(
          //     margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          //     child: ListTile(
          //       leading: CircleAvatar(
          //         radius: 25.0,
          //       ),
          //       title: Text(
          //         '$date',
          //         style: mediumTextStyle(),
          //       ),
          //       subtitle: Text(
          //         '$name',
          //         style: mediumTextStyle(),
          //       ),
          //       trailing: Text(
          //         '$kilograms',
          //         style: mediumTextStyle(),
          //       ),
          //     ),
          //   ),
          // )
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
              stream: Firestore.instance.collection("loans").snapshots(),
              builder: (context, snapshot) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    recordList(),
                    SizedBox(
                      height: 50,
                    ),
                  ]),
                );
              }),
        ),
      ),
    );
  }
}
