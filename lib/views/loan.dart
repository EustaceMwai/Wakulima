import 'package:flutter/material.dart';

class Loan extends StatefulWidget {
  @override
  _LoanState createState() => _LoanState();
}

class _LoanState extends State<Loan> {
  final formKey = GlobalKey<FormState>();
  TextEditingController loanAmountController = new TextEditingController();
  @override
  void applyLoan() {
    int total;
    if (total <= 500) {
      var loan = List.generate(10000, (i) => i);
    } else if (total <= 999) {
      var loan = List.generate(20000, (i) => i);
    } else if (total <= 1999) {
      var loan = List.generate(40000, (i) => i);
    } else {
      //not qualified
    }
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
  String _currentSelectedValue;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: AppBar(
        title: Text("Loan application"),
      ),
      body: Column(
        children: <Widget>[
          //show loanns available
          // Center(
          //   child: Form(
          //     child: TextFormField(
          //       keyboardType: TextInputType.number,
          //       validator: (val) {
          //         return val.isEmpty ? "Cannot be empty" : null;
          //       },
          //       controller: loanAmountController,
          //       style: simpleTextStyle(),
          //       decoration: InputDecoration(
          //           hintText: 'Loan Amount',
          //           fillColor: Colors.white54,
          //           filled: true,
          //           enabledBorder: OutlineInputBorder(
          //               borderSide:
          //                   BorderSide(color: Colors.white, width: 2.0)),
          //           focusedBorder: OutlineInputBorder(
          //               borderSide:
          //                   BorderSide(color: Colors.pink, width: 2.0))),
          //     ),
          //   ),
          // ),
          FormField<String>(
            builder: (FormFieldState<String> state) {
              return InputDecorator(
                decoration: InputDecoration(
                    labelStyle:
                        TextStyle(color: Colors.blueGrey, fontSize: 16.0),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 16.0),
                    hintText: 'Please select expense',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                isEmpty: _currentSelectedValue == '',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _currentSelectedValue,
                    isDense: true,
                    onChanged: (String newValue) {
                      setState(() {
                        _currentSelectedValue = newValue;
                        state.didChange(newValue);
                      });
                    },
                    items: _currencies.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
