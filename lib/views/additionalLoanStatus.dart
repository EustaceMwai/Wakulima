import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mpesa_flutter_plugin/initializer.dart';
import 'package:mpesa_flutter_plugin/payment_enums.dart';
import 'package:wakulima/model/user.dart';
import 'package:wakulima/services/auth.dart';
import 'package:wakulima/services/database.dart';
import 'package:wakulima/widgets/widget.dart';

class AdditionalLoanStatus extends StatefulWidget {
  String userId;

  @override
  _AdditionalLoanStatusState createState() => _AdditionalLoanStatusState();
}

class _AdditionalLoanStatusState extends State<AdditionalLoanStatus> {
  final formKey = GlobalKey<FormState>();
  TextEditingController payLoanController = new TextEditingController();
  TextEditingController payLoan2Controller = new TextEditingController();
  TextEditingController previousMilkController = new TextEditingController();
  TextEditingController cumulativeMilkController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();

  QuerySnapshot additionalSnapshot;
  FirebaseUser username;
  String name = 'eustace';
  String email;
  double total = 0.0;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
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

  searchAdditionalLoan() {
    databaseMethods.getFarmerAdditionalLoanState().then((val) {
      setState(() {
        additionalSnapshot = val;
      });
    });
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
                stream: Firestore.instance
                    .collection("additionalLoans")
                    .snapshots(),
                builder: (context, snapshot) {
                  return Container(
                    // padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          record2List(),
                          SizedBox(
                            height: 50,
                          ),
                          additionalSnapshot != null
                              ? TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator: (val) {
                                    return val.isEmpty
                                        ? "Value cannot be empty"
                                        : null;
                                  },
                                  controller: payLoan2Controller,
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
                          additionalSnapshot != null
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
                                                payLoan2Controller.text),
                                            phone: "254718273753");
                                      }
                                    },
                                    child: Text("Pay Loan"),
                                  ),
                                )
                              : Text("You have no additional loans"),
                        ]),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
