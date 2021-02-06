import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:wakulima/helper/helperfunctions.dart';
import 'package:wakulima/services/auth.dart';
import 'package:wakulima/services/database.dart';
import 'package:wakulima/widgets/widget.dart';

import 'home.dart';

class SignUp extends StatefulWidget {
  final Function toggle;

  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  int randomNumber;
  String mobileNumber;

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController =
      new TextEditingController();

  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  // TextEditingController organisationIdEditingController =
  //     new TextEditingController();
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'KE';
  PhoneNumber number = PhoneNumber(isoCode: 'KE');

  signMeUp() {
    if (formKey.currentState.validate()) {
      Map<String, dynamic> userInfoMap = {
        "name": userNameTextEditingController.text,
        "email": emailTextEditingController.text,
        "phone_number": mobileNumber,
        "admin": false,
        "agent": false,
        "veterinary": false,
        "cumulative Records": 0,
        "shares": 0,
        "Crb": "cleared",
        "farmerId": randomNumber,
        "status": "online",
        "last_seen": new DateFormat.yMd().add_jm().format(DateTime.now()),
      };
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);
      HelperFunctions.saveUserNameInSharedPreference(
          userNameTextEditingController.text);
      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
//        print("${val.uid}");

        databaseMethods.uploadUsersInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
      });
    }
  }

  // getRandomId() {
  //   Random random = new Random();
  //   int randomNumber = random.nextInt(1000) + 100;
  //   print(randomNumber);
  // }

  @override
  void initState() {
    // TODO: implement initState
    Random random = new Random();
    randomNumber = random.nextInt(5000) + 100;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 50,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            // TextFormField(
                            //   keyboardType: TextInputType.number,
                            //   validator: (val) {
                            //     return val.length > 10
                            //         ? "Invalid phone number"
                            //         : null;
                            //   },
                            //   controller: phoneController,
                            //   style: simpleTextStyle(),
                            //   decoration:
                            //       textFieldInputDecoration("phone number"),
                            // ),
                            SizedBox(
                              height: 10,
                            ),
                            InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {
                                print(number.phoneNumber);

                                setState(() {
                                  mobileNumber = number.phoneNumber;
                                  print("mobile is: $mobileNumber");
                                });
                              },
                              onInputValidated: (bool value) {
                                print(value);
                              },

                              selectorConfig: SelectorConfig(
                                selectorType:
                                    PhoneInputSelectorType.BOTTOM_SHEET,
                              ),
                              ignoreBlank: false,
                              // autoValidateMode: AutovalidateMode.disabled,
                              selectorTextStyle: TextStyle(color: Colors.black),
                              initialValue: number,
                              textFieldController: phoneController,
                              formatInput: false,
                              // keyboardType: TextInputType.numberWithOptions(
                              //     signed: true, decimal: true),
                              inputBorder: OutlineInputBorder(),
                              validator: (val) {
                                return val.isEmpty || val.length < 5
                                    ? "Provide a valid phone"
                                    : null;
                              },
                              // onSaved: (PhoneNumber number) {
                              //   print('On Saved: $number');
                              // },
                            ),

                            // IntlPhoneField(
                            //   decoration: InputDecoration(
                            //     labelText: 'Phone Number',
                            //     border: OutlineInputBorder(
                            //       borderSide: BorderSide(),
                            //     ),
                            //   ),
                            //   // controller: phoneController,
                            //   initialCountryCode: 'KE',
                            //   validator: (val) {
                            //     return val.isEmpty || val.length < 5
                            //         ? "Provide a valid phone"
                            //         : null;
                            //   },
                            //   onChanged: (phone) {
                            //     print(phone.completeNumber);
                            //     mobileNumber = phone.completeNumber;
                            //     print(mobileNumber);
                            //   },
                            // ),
                            TextFormField(
                                validator: (val) {
                                  return val.isEmpty || val.length < 2
                                      ? "Provide a valid Username"
                                      : null;
                                },
                                controller: userNameTextEditingController,
                                style: simpleTextStyle(),
                                decoration:
                                    textFieldInputDecoration("username")),
                            TextFormField(
                                validator: (val) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val)
                                      ? null
                                      : "Please provide a valid email";
                                },
                                controller: emailTextEditingController,
                                style: simpleTextStyle(),
                                decoration: textFieldInputDecoration("email")),
                            TextFormField(
                              obscureText: true,
                              validator: (val) {
                                return val.length < 6
                                    ? "Enter Password 6+ characters"
                                    : null;
                              },
                              controller: passwordTextEditingController,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("password"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              validator: (val) {
                                return val.isEmpty ? "Cannot be empty" : null;
                              },
                              initialValue: "Organization Id: $randomNumber ",
                              // controller: organisationIdEditingController,
                              style: simpleTextStyle(),
                              decoration: InputDecoration(
                                  fillColor: Colors.white54,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.0))),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            "Forgot Password?",
                            style: simpleTextStyle(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          signMeUp();
                        },
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
                              "Sign Up",
                              style: mediumTextStyle(),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      // Container(
                      //   alignment: Alignment.centerRight,
                      //   width: MediaQuery.of(context).size.width,
                      //   padding: EdgeInsets.symmetric(vertical: 20),
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(30)),
                      //   child: Center(
                      //     child: Text(
                      //       "Your Organisation Id: $randomNumber ",
                      //       style:
                      //           TextStyle(color: Colors.black87, fontSize: 17),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Already have an account? ",
                            style: mediumTextStyle(),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "Sign In ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          )
                        ],
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
