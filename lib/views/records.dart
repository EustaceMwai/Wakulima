import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wakulima/model/user.dart';
import 'package:wakulima/services/auth.dart';
import 'package:wakulima/services/database.dart';
import 'package:wakulima/views/showVet.dart';
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
  String name;
  String email;
  double total = 0.0;
  double firstAmount;
  double secondAmount;
  double difference;
  double price = 15.0;
  double earnedAmount;
  int farmerId;
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
                  date: recordsSnapshot.documents[index].data["date"],
                  farmerId: recordsSnapshot.documents[index].data["farmerId"],
                  name: recordsSnapshot.documents[index].data["name"]);
            })
        : Container();
  }

  initiateSearch() {
    databaseMethods.getFarmerRecordsByEmail().then((val) {
      setState(() {
        recordsSnapshot = val;
        firstAmount = recordsSnapshot.documents[0].data['kilograms'];
        secondAmount = recordsSnapshot.documents[1].data['kilograms'];

        difference = secondAmount - firstAmount;
        name = recordsSnapshot.documents[1].data['name'];
        farmerId = recordsSnapshot.documents[0].data['farmerId'];
        recommendVet();
      });
    });
  }

  recommendVet() {
    if (difference >= 5) {
      print('contact a vet');
      showDialog(
        context: context,
        builder: (BuildContext context) => _buildAboutDialog(context),
      );
    }
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
        earnedAmount = total * price;
      });
      debugPrint(total.toString());
      Firestore.instance
          .collection("users")
          .document(user.uid)
          .updateData({"cummulativeRecords": total});
    });
  }

  Widget recordTile(
      {String email,
      String date,
      dynamic kilograms,
      int farmerId,
      String name}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                Center(
                  child: Text(
                    'Farmer Id: $farmerId',
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
                    '  Date and time sold:\n$date',
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
                    'Email: $email',
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

  Widget _buildAboutText() {
    return new RichText(
      text: new TextSpan(
        text:
            'Your milk production levels seems to have dropped by $difference litres. This is a significant margin and could be caused by various issues with your cows. If this is the case we recommend that you visit our veterinary page and get help .\n\n',
        style: const TextStyle(color: Colors.black87),
        children: <TextSpan>[
          const TextSpan(text: 'Thank You '),
        ],
      ),
    );
  }

  Widget _buildAboutDialog(BuildContext context) {
    return new AlertDialog(
      title: Text('Hello $name'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAboutText(),
          // _buildLogoAttribution(),
        ],
      ),
      actions: <Widget>[
        Row(
          children: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              textColor: Theme.of(context).primaryColor,
              child: const Text('Ok, got it!'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Vets(
                              name: name,
                            )));
              },
              textColor: Colors.green,
              child: const Text('Contact Vet!'),
            ),
          ],
        ),
      ],
    );
  }

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
      backgroundColor: Colors.white70,
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height - 50,
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Container(
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
                            child: Column(
                              children: [
                                Text(
                                  "Cumulative amount of  Milk sold: $total litres",
                                  style: mediumTextStyle(),
                                ),
                                Text(
                                  "Amount Earned: $earnedAmount Kshs",
                                  style: mediumTextStyle(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        recordList(),
                        SizedBox(
                          height: 12.0,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Loan(
                                          total.round(),
                                          name, farmerId
                                        )));
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
