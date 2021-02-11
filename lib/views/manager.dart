import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wakulima/model/user.dart';
import 'package:wakulima/services/auth.dart';
import 'package:wakulima/services/database.dart';

class manager extends StatefulWidget {
  @override
  _managerState createState() => _managerState();
}

class _managerState extends State<manager> {
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

  String ids;

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
                name: recordsSnapshot.documents[index].data["name"],
                loan: recordsSnapshot.documents[index].data["loan"],
                id: recordsSnapshot.documents[index].data["farmerId"],
              );
            })
        : Container();
  }

  Widget loanList() {
    return recordsSnapshot != null
        ? ListView.builder(
            itemCount: recordsSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: 60.0,
                  child: recordsSnapshot.documents[index].data["loan status"] ==
                          "approved"
                      ? Icon(Icons.check)
                      : FlatButton(
                          child: Text('approve'),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          onPressed: () async {
                            final FirebaseAuth _auth = FirebaseAuth.instance;
                            final Firestore _firestore = Firestore.instance;
                            FirebaseUser user = await _auth.currentUser();
                            Firestore.instance
                                .collection("loans")
                                .document(
                                    recordsSnapshot.documents[index].data["id"])
                                .updateData(
                              {
                                "loan status": "approved",
                              },
                            );
                          },
                        ),
                ),
              );
            })
        : Container();
  }

  Widget loanList2() {
    return recordsSnapshot != null
        ? ListView.builder(
            itemCount: recordsSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: 60.0,
                  child: recordsSnapshot.documents[index].data["loan status"] ==
                          "denied"
                      ? Icon(
                          Icons.close,
                          color: Colors.red,
                        )
                      : FlatButton(
                          child: Text('Deny'),
                          color: Colors.redAccent,
                          textColor: Colors.white,
                          onPressed: () async {
                            final FirebaseAuth _auth = FirebaseAuth.instance;
                            final Firestore _firestore = Firestore.instance;
                            FirebaseUser user = await _auth.currentUser();
                            Firestore.instance
                                .collection("loans")
                                .document(
                                    recordsSnapshot.documents[index].data["id"])
                                .updateData({
                              "loan status": "denied",
                            });
                          },
                        ),
                ),
              );
            })
        : Container();
  }

  initiateSearch() {
    databaseMethods.getAllUserLoans().then((val) {
      setState(() {
        recordsSnapshot = val;
      });
    });
  }

  Widget recordTile({String name, int loan, dynamic id}) {
    return Column(
      children: [
        Container(
          height: 70.0,
          child: Card(
            child: Center(
              child: Text(
                '$name\nFarmer Id: $id\nLoan requested: Ksh $loan',

                // style: mediumTextStyle(),
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget recordTile2({String email, int loan, dynamic id}) {
    // return Row(
    //   children: [
    //     Expanded(
    //       child: Card(
    //         child: Center(
    //           child: Text(
    //             '$email',
    //             // style: mediumTextStyle(),
    //           ),
    //         ),
    //       ),
    //     ),
    //     Expanded(
    //       child: Card(
    //         child: Center(
    //           child: Text(
    //             'Loan requested: Ksh $loan',
    //
    //             // style: mediumTextStyle(),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Card(
          child: Text('$email'),
        ),
        Card(
          child: Text('Loan requested: Ksh $loan'),
        ),
      ],
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
      appBar: AppBar(
        title: Text('Farmers Loans'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.topCenter,
          child: StreamBuilder(
              stream: Firestore.instance.collection("loans").snapshots(),
              builder: (context, snapshot) {
                // return Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   // mainAxisSize: MainAxisSize.min,
                //   // crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Expanded(child: recordList()),
                //     // Column(
                //     //   children: [loanList(), loanList2()],
                //     // ),
                //     Expanded(
                //       child: loanList(),
                //     ),
                //     Expanded(child: loanList2()),
                //
                //     // Container(
                //     //   padding: EdgeInsets.all(8.0),
                //     //   height: 50.0,
                //     //   width: 20.0,
                //     //   child: Column(
                //     //     children: [loanList(), loanList2()],
                //     //   ),
                //     // ),
                //   ],
                // );
                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: 160.0,
                      child: recordList(),
                    ),
                    Container(
                      width: 160.0,
                      child: loanList(),
                    ),
                    Container(
                      width: 160.0,
                      child: loanList2(),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
