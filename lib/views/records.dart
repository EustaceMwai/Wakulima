import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wakulima/model/user.dart';
import 'package:wakulima/services/auth.dart';
import 'package:wakulima/services/database.dart';
import 'package:wakulima/widgets/widget.dart';

import 'loan.dart';

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

  Future queryValues() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();
    Firestore.instance
        .collection('farmers')
        .where("email", isEqualTo: user.email)
        .getDocuments()
        .then((val) {
      double tempTotal =
          val.documents.fold(0, (tot, doc) => tot + doc.data['kilograms']);
      setState(() {
        total = tempTotal;
      });
      debugPrint(total.toString());
      Firestore.instance
          .collection("users")
          .document(user.uid)
          .updateData({"cummulativeRecords": total});
    });
  }

  Widget recordTile({String email, String date, dynamic kilograms}) {
    return Container(
      height: 100.0,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                'Date and time sold :$date',
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
            Center(
              child: Text(
                '$email',
                // style: mediumTextStyle(),
                style: TextStyle(
                  fontSize: 17.0,
                  fontFamily: 'Nunito-Regular',
                ),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Center(
              child: Text(
                'Amount of Milk sold: $kilograms litres',
                // style: mediumTextStyle(),
                style: TextStyle(
                  fontSize: 17.0,
                  fontFamily: 'Nunito',
                ),
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
    queryValues();
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
              stream: Firestore.instance.collection("farmers").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    recordList(),
                    SizedBox(
                      height: 12.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        initiateSearch();
                      },
                      child: Container(
                        alignment: Alignment.bottomCenter,
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
                            "Cumulative amount of  Milk sold: $total litres",
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
                                builder: (context) => Loan(total.round())));
                      },
                      child: Container(
                        alignment: Alignment.bottomCenter,
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
                            "Go to Loans",
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
