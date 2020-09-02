import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wakulima/helper/autheticate.dart';
import 'package:wakulima/services/auth.dart';
import 'package:wakulima/views/product_list.dart';

import 'bottom.dart';
import 'loan.dart';
import 'maps.dart';
import 'milk.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AuthMethods authMethods = new AuthMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Choose'),
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                authMethods.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Wakulima"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 200.0,
              child: Card(
                elevation: 10,
                child: Center(
                    child: Text(
                  'Welcome Eustace',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MilkRecords()));
                    },
                    child: Card(
                      elevation: 10,
                      child: Center(
                          child: Text(
                        'Dairy',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Loan()));
                    },
                    child: Card(
                      elevation: 10,
                      child: Center(
                          child: Text(
                        'Loans',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductList()));
                    },
                    child: Card(
                      elevation: 10,
                      child: Center(
                          child: Text(
                        'Sold Milk Records',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Maps()));
                    },
                    child: Card(
                      elevation: 10,
                      child: Center(
                          child: Text(
                        'Veterinary',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            BottomNavigationWidget(),
          ],
        ),
      ),
    );
  }
}
