import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wakulima/services/auth.dart';
import 'package:wakulima/services/database.dart';
import 'package:wakulima/widgets/widget.dart';

import 'loanStatus.dart';

class Loan2 extends StatefulWidget {
  final int total;

  Loan2(this.total);
  @override
  _Loan2State createState() => _Loan2State();
}

class _Loan2State extends State<Loan2> {
  TextEditingController loanAmountController = new TextEditingController();
  QuerySnapshot recordsSnapshot;
  DocumentSnapshot loanSnapshot;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();

  var loanEligible;
  int selected;

  getDetails() {
    databaseMethods.getFarmerLoanRecord().then((val) {
      setState(() {
        recordsSnapshot = val;
      });
    });
  }

  @override
  void initState() {
    getDetails();
    loanEligible = applyLoan(widget.total);
    print(loanEligible);

    super.initState();
  }

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
                return Column(
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
                    Center(
                        child: Text(
                      "Choose the repayment period below",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    )),

                    // slider(),
                    SizedBox(height: 50),
                    // confirmButton(),

                    // checkExistLoan(),
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
                );
              }),
        ),
      ),
    );
  }
}
