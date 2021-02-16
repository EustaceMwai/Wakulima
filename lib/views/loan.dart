import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wakulima/services/auth.dart';
import 'package:wakulima/services/database.dart';
import 'package:wakulima/views/loanStatus.dart';
import 'package:wakulima/views/slider.dart';

class Loan extends StatefulWidget {
  final int total;
  final String name;
  int farmerId;

  Loan(this.total, this.name, this.farmerId);

  int get t {
    return total;
  }

  @override
  _LoanState createState() => _LoanState();
}

class _LoanState extends State<Loan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  int selected;
  bool isLoading = false;

  double period;
  double payableLoan;
  int rate;
  double interest;
  double _value = 50.0;
  double loanPeriod = 36.0;
  TextEditingController loanAmountController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  SliderExample sliderVariable = new SliderExample();
  AuthMethods authMethods = new AuthMethods();

  QuerySnapshot recordsSnapshot;
  DocumentSnapshot loanSnapshot;

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

  checkExistingLoan() async {
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
    return recordsSnapshot != null
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
    //           onPressed: submitLoan,
    //           child: Text("Submit"),
    //         ),
    //       );
    if (loanSnapshot == null) return CircularProgressIndicator();
    return !loanSnapshot.exists
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue,
              boxShadow: [
                BoxShadow(color: Colors.blue, spreadRadius: 3),
              ],
            ),
            child: FlatButton(
              child: Text('submit'),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                print(selected);
                submitLoan();
                setState(() {
                  isLoading = false;
                });
              },
            ),
          )
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue,
              boxShadow: [
                BoxShadow(color: Colors.blue, spreadRadius: 3),
              ],
            ),
            child: FlatButton(
              child: Text('submit another loan'),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                print(selected);
                submitAnotherLoan();
                setState(() {
                  isLoading = false;
                });
              },
            ),
          );

    // if (!loanSnapshot.exists || loanSnapshot == null) {
    //   return Container(
    //     child: RaisedButton(
    //       onPressed: () {
    //         submitLoan();
    //       },
    //       child: Text("Submit"),
    //     ),
    //   );
    // } else {
    //   return Center(
    //     child: Text("You already have a existing Loan"),
    //   );
    // }
  }

  Widget loan1Status() {
    // if (loanSnapshot == null) return CircularProgressIndicator();
    // return loanSnapshot.data.containsKey("id")
    //     ?
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue,
        boxShadow: [
          BoxShadow(color: Colors.blue, spreadRadius: 3),
        ],
      ),
      margin: EdgeInsets.all(20),
      child: FlatButton(
        child: Text('check loan status'),
        color: Colors.blueAccent,
        textColor: Colors.white,
        onPressed: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => loanStatus()));
        },
      ),
    );
    // : Container();
  }

  Widget recordTile({String crb, int shares}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.green, spreadRadius: 3),
          ],
        ),
        width: 20.0,
        height: 170.0,
        alignment: Alignment.center,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
                    'CRB status: $crb',
                    // style: mediumTextStyle(),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Number of Shares bought in the sacco: $shares',
                    // style: mediumTextStyle(),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.green, spreadRadius: 3),
          ],
        ),
        child: Card(
          child: DropdownButtonFormField(
            value: selected,
            validator: (value) =>
                value == null ? 'Please select loan amount' : null,
            onChanged: (val) => setState(() => selected = val),
            items: menuItemList,
            hint: Text("choose loan amount"),
          ),
        ),
      ),
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

  calculateInterest() {
    if (formKey.currentState.validate()) {
      payableLoan = selected + (selected * 0.4 * loanPeriod / 36);
      print("loan period is ${loanPeriod}");
      print(payableLoan);
    }
  }

  submitAnotherLoan() async {
    if (formKey.currentState.validate()) {
      calculateInterest();
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final Firestore _firestore = Firestore.instance;
      FirebaseUser user = await _auth.currentUser();
      Firestore.instance.collection("additionalLoans").add(
        {
          'id': user.uid,
          'name': widget.name,
          'farmerId': widget.farmerId,
          'email': user.email,
          'loan': selected,
          'loan status': "inactive",
          'repayment period': loanPeriod.toInt(),
          'payableLoan': payableLoan.toInt(),
        },
      );
      final snackBar = SnackBar(
          duration: Duration(seconds: 3),
          content: Text('Another loan submitted successfully'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  submitLoan() async {
    if (formKey.currentState.validate()) {
      calculateInterest();
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final Firestore _firestore = Firestore.instance;
      FirebaseUser user = await _auth.currentUser();
      Firestore.instance.collection("loans").document(user.uid).setData(
        {
          'id': user.uid,
          'name': widget.name,
          'farmerId': widget.farmerId,
          'email': user.email,
          'loan': selected,
          'loan status': "inactive",
          'repayment period': loanPeriod.toInt(),
          'payableLoan': payableLoan.toInt(),
        },
      );
      final snackBar = SnackBar(
          duration: Duration(seconds: 3),
          content: Text('Loan submitted successfully'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  Widget slider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.blue[700],
        inactiveTrackColor: Colors.blue[100],
        trackShape: RoundedRectSliderTrackShape(),
        trackHeight: 4.0,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
        thumbColor: Colors.blueAccent,
        overlayColor: Colors.blue.withAlpha(32),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
        tickMarkShape: RoundSliderTickMarkShape(),
        activeTickMarkColor: Colors.blue[700],
        inactiveTickMarkColor: Colors.blue[100],
        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
        valueIndicatorColor: Colors.blueAccent,
        valueIndicatorTextStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      child: Slider(
        value: loanPeriod,
        min: 0,
        max: 36,
        divisions: 12,
        label: '${loanPeriod.toStringAsFixed(0)} months',
        onChanged: (value) {
          setState(
            () {
              loanPeriod = value;
              print("the loan period is ${loanPeriod}");
            },
          );
        },
      ),
    );
  }

  Widget confirmButton() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
          boxShadow: [
            BoxShadow(color: Colors.blue, spreadRadius: 3),
          ],
        ),
        child: FlatButton(
          child: Text(
            "Confirm",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            calculateInterest();
            final snackBar = SnackBar(
                duration: Duration(seconds: 5),
                content: Text(
                    'You have chosen a loan amount of $selected\n You will pay back Ksh ${payableLoan.toStringAsFixed(0)} within a payment period of ${loanPeriod.toStringAsFixed(0)} months  \n Click submit to proceed with loan application'));

            _scaffoldKey.currentState.showSnackBar(snackBar);
          },
        ));
  }

  Widget farmerEligibleLoan() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.green, spreadRadius: 3),
          ],
        ),
        height: 170.0,
        alignment: Alignment.center,
        child: Card(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Image.asset(
                    'assets/images/logo-sacco.jpg',
                  ),
                ),
              ),
              Divider(),
              Expanded(
                child: Center(
                    child: Text("Buy more shares to increase your loan limit")),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: Center(
                  child: Text(
                      " Eligible  amount of loan from: ${loanEligible["from"].toString()} "),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                  child: Center(
                      child: Text("To: ${loanEligible["to"].toString()} "))),
            ],
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text("Loan application"),
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.topCenter,
          child: Form(
            key: formKey,
            child: StreamBuilder(
                stream: Firestore.instance.collection("loans").snapshots(),
                builder: (context, snapshot) {
                  //   if (!snapshot.hasData) {
                  //     print('test phrase');
                  //   return Text("Loading.....");f
                  // }

                  // if (snapshot.hasError) {
                  //   return Center(
                  //     child: Text('Error: ${snapshot.error}'),
                  //   );
                  // }
                  // if (snapshot.data.documents.length < 0)
                  //   return CircularProgressIndicator();

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  // if (!snapshot.data.documents.length > 0) {
                  //   return Center(
                  //     child: CircularProgressIndicator(),
                  //   );
                  // }
                  return Column(
                    children: <Widget>[
                      recordList(),

                      farmerEligibleLoan(),
                      SizedBox(
                        width: 50,
                      ),
                      displayBoard(),
                      SizedBox(height: 50),
                      Center(
                          child: Text(
                        "Choose the repayment period below",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      )),
                      // slider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.green, spreadRadius: 3),
                            ],
                          ),
                          height: 30.0,
                          child: Card(
                            child: SliderExample(
                              updateValue: (double value) {
                                loanPeriod = value;
                                print("value from another world is: $value");
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      confirmButton(),
                      SizedBox(height: 30),
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
                      loan1Status(),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
