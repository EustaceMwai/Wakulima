import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wakulima/services/auth.dart';
import 'package:wakulima/services/database.dart';

import 'loanStatus.dart';

class Loan extends StatefulWidget {
  final int total;

  Loan(this.total);
  int get t {
    return total;
  }

  @override
  _LoanState createState() => _LoanState();
}

class _LoanState extends State<Loan> {
  final formKey = GlobalKey<FormState>();
  int selected;
  bool isLoading = false;

  TextEditingController loanAmountController = new TextEditingController();
  QuerySnapshot recordsSnapshot;
  DocumentSnapshot loanSnapshot;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();

  var loanEligible;

  @override
  void initState() {
    getDetails();
    loanEligible = applyLoan(widget.total);
    print(loanEligible);
    checkExistingLoan();
    // print(loanEligible["from"]);
    super.initState();
  }

  getDetails() {
    databaseMethods.getFarmerLoanRecord().then((val) {
      setState(() {
        recordsSnapshot = val;
      });
    });
  }

  checkExistingLoan() {
    databaseMethods.getLoanDetails().then((val) {
      setState(() {
        loanSnapshot = val;
      });
      print("This is what is $loanSnapshot");
    });
  }

  Widget recordList() {
    if (recordsSnapshot != null && recordsSnapshot.documents == null)
      return CircularProgressIndicator();
    return recordsSnapshot.documents != null
        ? ListView.builder(
            itemCount: recordsSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return recordTile(
                  crb: recordsSnapshot.documents[index].data["Crb"],
                  shares: recordsSnapshot.documents[index].data["shares"]);
            })
        : Container();
  }

  Widget checkExistLoan() {
    // return loanSnapshot != null
    //     ? ListView.builder(
    //         itemCount: loanSnapshot.data.length,
    //         shrinkWrap: true,
    //         itemBuilder: (context, index) {
    //           return Center(
    //             child: Text("You already have a existing Loan"),
    //           );
    //         })
    //     : Container(
    //         child: RaisedButton(
    //           child: Text("Submit"),
    //         ),
    //       );
    return !loanSnapshot.exists
        ? Container(
            child: RaisedButton(
              child: Text("Submit"),
            ),
          )
        : Center(
            child: Text("You already have a existing Loan"),
          );
  }

  Widget recordTile({String crb, int shares}) {
    return Container(
      width: 10.0,
      height: 100.0,
      alignment: Alignment.center,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                'CRB status: $crb',
                // style: mediumTextStyle(),
              ),
            ),
            Center(
              child: Text(
                'Number of Shares bought in the sacco: $shares',
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
      ),
    );
  }

  // dynamic applyLoan() {
  //   List<int> loan = [];
  //   if (widget.total <= 500) {
  //     List<int> loan = [15000, 12000, 9000, 6000, 3000];
  //     Widget displayBoard() {
  //       List<DropdownMenuItem> menuItemList = loan
  //           .map((val) =>
  //               DropdownMenuItem(value: val, child: Text(val.toString())))
  //           .toList();
  //       return DropdownButton(
  //         value: selected,
  //         onChanged: (val) => setState(() => selected = val),
  //         items: menuItemList,
  //       );
  //     }
  //   } else if (widget.total <= 999) {
  //     loan = [24000, 21000, 18000, 15000, 12000, 9000, 6000, 3000];
  //   } else if (widget.total <= 1499) {
  //     List<int> loan = [
  //       33000,
  //       30000,
  //       27000,
  //       24000,
  //       21000,
  //       18000,
  //       15000,
  //       12000,
  //       9000,
  //       6000,
  //       3000
  //     ];
  //     Widget displayBoard() {
  //       List<DropdownMenuItem> menuItemList = loan
  //           .map((val) =>
  //               DropdownMenuItem(value: val, child: Text(val.toString())))
  //           .toList();
  //       return DropdownButton(
  //         value: selected,
  //         onChanged: (val) => setState(() => selected = val),
  //         items: menuItemList,
  //       );
  //     }
  //   } else {
  //     //not qualified
  //
  //   }
  //   return loan;
  // }
  Map applyLoan(int total) {
    var constraints = {};

    if (widget.total >= 500) {
      constraints = {"from": 3000, "to": 15000};
    } else if (widget.total >= 200) {
      constraints = {"from": 1000, "to": 5000};
    } else if (widget.total >= 1000) {
      constraints = {"from": 3000, "to": 30000};
    } else if (widget.total >= 1500) {
      constraints = {"from": 3000, "to": 45000};
    } else if (widget.total < 200) {
      constraints = {"from": 500, "to": 1000};
    } else {
      constraints = null;
    }
    return constraints;
  }

  Widget displayBoard() {
    List loan = [
      for (var i = loanEligible["from"]; i < loanEligible["to"] + 500; i += 500)
        i
    ];
    List<DropdownMenuItem> menuItemList = loan
        .map((val) => DropdownMenuItem(value: val, child: Text(val.toString())))
        .toList();
    return DropdownButtonFormField(
      value: selected,
      validator: (value) => value == null ? 'Please select loan amount' : null,
      onChanged: (val) => setState(() => selected = val),
      items: menuItemList,
      hint: Text("choose amount"),
    );
  }

  var _currencies = [
    "Food",
    "Transport",
    "Personal",
    "Shopping",
    "Medical",
    "Rent",
    "Movie",
    "Salary"
  ];

  submitLoan() async {
    if (formKey.currentState.validate()) {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final Firestore _firestore = Firestore.instance;
      FirebaseUser user = await _auth.currentUser();
      Firestore.instance.collection("loans").document(user.uid).setData({
        'id': user.uid,
        'email': user.email,
        'loan': selected,
        'loan status': "inactive",
        'repayment period': 3
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: AppBar(
        title: Text("Loan application"),
      ),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    recordList(),
                    Center(
                        child: Text(
                            "Buy more shares to increase your loan limit")),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Card(
                              child: Center(
                                  child: Text(
                                      " Eligible  amount of loan from: ${loanEligible["from"].toString()} ")),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Card(
                            child: Center(
                                child: Text(
                                    "To: ${loanEligible["to"].toString()} ")),
                          ),
                        )),
                      ],
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    displayBoard(),
                    SizedBox(height: 50),
                    checkExistLoan(),
                    // Container(
                    //   margin: EdgeInsets.all(20),
                    //   child: FlatButton(
                    //     child: Text('submit'),
                    //     color: Colors.blueAccent,
                    //     textColor: Colors.white,
                    //     onPressed: () async {
                    //       setState(() {
                    //         isLoading = true;
                    //       });
                    //       print(selected);
                    //       submitLoan();
                    //       setState(() {
                    //         isLoading = false;
                    //       });
                    //     },
                    //   ),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: FlatButton(
                        child: Text('check loan status'),
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => loanStatus()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
