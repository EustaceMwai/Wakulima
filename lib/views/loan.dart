import 'package:flutter/material.dart';

class Loan extends StatefulWidget {
  final int total;

  Loan(this.total);
  @override
  _LoanState createState() => _LoanState();
}

class _LoanState extends State<Loan> {
  final formKey = GlobalKey<FormState>();
  String selected;

  TextEditingController loanAmountController = new TextEditingController();

  dynamic applyLoan() {
    List<int> loan = [];
    if (widget.total <= 500) {
      List<int> loan = [15000, 12000, 9000, 6000, 3000];
      Widget displayBoard() {
        List<DropdownMenuItem> menuItemList = loan
            .map((val) => DropdownMenuItem(value: val, child: Text(val)))
            .toList();
        return DropdownButton(
          value: selected,
          onChanged: (val) => setState(() => selected = val),
          items: menuItemList,
        );
      }
    } else if (widget.total <= 999) {
      List<int> loan = [24000, 21000, 18000, 15000, 12000, 9000, 6000, 3000];
      Widget displayBoard() {}
    } else if (widget.total <= 1499) {
      List<int> loan = [
        33000,
        30000,
        27000,
        24000,
        21000,
        18000,
        15000,
        12000,
        9000,
        6000,
        3000
      ];
    } else {
      //not qualified

    }
    return loan;
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
