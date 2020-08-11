import 'package:flutter/material.dart';
import 'package:wakulima/widgets/widget.dart';

class MilkRecords extends StatefulWidget {
  @override
  _MilkRecordsState createState() => _MilkRecordsState();
}

class _MilkRecordsState extends State<MilkRecords> {
  final formKey = GlobalKey<FormState>();
  TextEditingController todayMilkController = new TextEditingController();
  TextEditingController previousMilkController = new TextEditingController();
  TextEditingController cumulativeMilkController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          return val.isEmpty ? "Cannot be empty" : null;
                        },
                        controller: todayMilkController,
                        style: simpleTextStyle(),
                        decoration: InputDecoration(
                            hintText: 'Today Milk Kgs',
                            fillColor: Colors.white54,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white, width: 2.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.pink, width: 2.0))),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          return val.isEmpty ? "Cannot be empty" : null;
                        },
                        controller: previousMilkController,
                        style: simpleTextStyle(),
                        decoration: InputDecoration(
                            hintText: 'Previous Milk Kgs',
                            fillColor: Colors.white54,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white, width: 2.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.pink, width: 2.0))),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        validator: (val) {
                          return val.isEmpty ? "Cannot be empty" : null;
                        },
                        controller: cumulativeMilkController,
                        style: simpleTextStyle(),
                        decoration: InputDecoration(
                            hintText: 'Cumulative Milk Kgs',
                            fillColor: Colors.white54,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white, width: 2.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.pink, width: 2.0))),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.centerRight,
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
                        "Update",
                        style: mediumTextStyle(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
