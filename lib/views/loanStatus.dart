import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mpesa_flutter_plugin/initializer.dart';
import 'package:mpesa_flutter_plugin/payment_enums.dart';
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
  TextEditingController payLoanController = new TextEditingController();
  TextEditingController previousMilkController = new TextEditingController();
  TextEditingController cumulativeMilkController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();

  QuerySnapshot recordsSnapshot;
  QuerySnapshot additionalSnapshot;
  FirebaseUser username;
  String name = 'eustace';
  String email;
  double total = 0.0;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  Widget recordList() {
    return recordsSnapshot != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: recordsSnapshot.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return recordTile(
                      loan: recordsSnapshot.documents[index].data["loan"],
                      loanStatus:
                          recordsSnapshot.documents[index].data["loan status"],
                      repayment: recordsSnapshot
                          .documents[index].data["repayment period"],
                      repayableLoan:
                          recordsSnapshot.documents[index].data["payableLoan"]);
                }),
          )
        : Container(
            child: Text('no loans'),
          );
  }

  Widget record2List() {
    return additionalSnapshot != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: additionalSnapshot.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return record2Tile(
                      loan: additionalSnapshot.documents[index].data["loan"],
                      loanStatus: additionalSnapshot
                          .documents[index].data["loan status"],
                      repayment: additionalSnapshot
                          .documents[index].data["repayment period"],
                      repayableLoan: additionalSnapshot
                          .documents[index].data["payableLoan"]);
                }),
          )
        : Container(
            child: Text('no additional loans'),
          );
  }

  initiateSearch() {
    databaseMethods.getFarmerLoanState().then((val) {
      setState(() {
        recordsSnapshot = val;
      });
    });
  }

  searchAdditionalLoan() {
    databaseMethods.getFarmerAdditionalLoanState().then((val) {
      setState(() {
        additionalSnapshot = val;
      });
    });
  }

  Widget recordTile(
      {int loan, String loanStatus, int repayment, int repayableLoan}) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.green, spreadRadius: 3),
        ],
      ),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Center(
                child: Image.asset(
                  'assets/images/logo-sacco.jpg',
                ),
              ),
            ),
            Divider(),
            Expanded(
              child: Center(
                child: Text(
                  'Loan applied: Ksh $loan',
                  // style: mediumTextStyle(),
                ),
              ),
            ),
            Expanded(
                child: Center(
              child: Text(
                'The status of the loan is: $loanStatus',
                // style: mediumTextStyle(),
              ),
            )),
            Expanded(
                child: Center(
              child: Text(
                'The repayment period of your loan is: $repayment months',
                // style: mediumTextStyle(),
              ),
            )),
            Expanded(
                child: Center(
              child: Text(
                'The amount you are going to repay is Ksh $repayableLoan ',
                // style: mediumTextStyle(),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget record2Tile(
      {int loan, String loanStatus, int repayment, int repayableLoan}) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.green, spreadRadius: 3),
        ],
      ),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Center(
                child: Image.asset(
                  'assets/images/logo-sacco.jpg',
                ),
              ),
            ),
            Divider(),
            Expanded(
              child: Center(
                child: Text(
                  'Loan applied: Ksh $loan',
                  // style: mediumTextStyle(),
                ),
              ),
            ),
            Expanded(
                child: Center(
              child: Text(
                'The status of the loan is: $loanStatus',
                // style: mediumTextStyle(),
              ),
            )),
            Expanded(
                child: Center(
              child: Text(
                'The repayment period of your loan is: $repayment months',
                // style: mediumTextStyle(),
              ),
            )),
            Expanded(
                child: Center(
              child: Text(
                'The amount you are going to repay is Ksh $repayableLoan ',
                // style: mediumTextStyle(),
              ),
            )),
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
    searchAdditionalLoan();
    super.initState();
  }

  Future<dynamic> startTransaction({double amount, String phone}) async {
    dynamic transactionInitialisation;
    //Wrap it with a try-catch
    try {
      //Run it
      transactionInitialisation = await MpesaFlutterPlugin.initializeMpesaSTKPush(
          businessShortCode: "174379",
          transactionType: TransactionType.CustomerPayBillOnline,
          amount: amount,
          partyA: phone,
          partyB: "174379",
          callBackURL: Uri(
              scheme: "https", host: "my-app.herokuapp.com", path: "/callback"),
          accountReference: "payment",
          phoneNumber: phone,
          baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
          transactionDesc: "demo",
          passKey:
              "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919");

      print("RESULT: " + transactionInitialisation.toString());
    } catch (e) {
      //you can implement your exception handling here.
      //Network unreachability is a sure exception.
      print(e.getMessage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            // height: MediaQuery.of(context).size.height - 50,
            alignment: Alignment.topCenter,
            child: StreamBuilder(
                stream: Firestore.instance.collection("loans").snapshots(),
                builder: (context, snapshot) {
                  return Container(
                    // padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          recordList(),
                          SizedBox(
                            height: 10,
                          ),
                          record2List(),
                          SizedBox(
                            height: 50,
                          ),
                          additionalSnapshot == null || recordsSnapshot == null
                              ? TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator: (val) {
                                    return val.isEmpty
                                        ? "Value cannot be empty"
                                        : null;
                                  },
                                  controller: payLoanController,
                                  style: simpleTextStyle(),
                                  decoration: InputDecoration(
                                      hintText: 'Enter amount to pay',
                                      fillColor: Colors.white54,
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.green,
                                              width: 2.0))),
                                )
                              : Text("You have no loans"),
                          SizedBox(
                            height: 50,
                          ),
                          additionalSnapshot == null || recordsSnapshot == null
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.green, spreadRadius: 3),
                                    ],
                                  ),
                                  child: RaisedButton(
                                    elevation: 1,
                                    onPressed: () {
                                      if (formKey.currentState.validate()) {
                                        startTransaction(
                                            amount: double.parse(
                                                payLoanController.text),
                                            phone: "254718273753");
                                      }
                                    },
                                    child: Text("Pay Loan"),
                                  ),
                                )
                              : Text("You have no loans"),
                        ]),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
