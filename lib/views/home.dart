import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bottom.dart';
import 'milk.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
              title: Text('settings'),
              onTap: () {},
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
                  Card(
                    elevation: 10,
                    child: Center(
                        child: Text(
                      'Loans',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                  ),
                  Card(
                    elevation: 10,
                    child: Center(
                        child: Text(
                      'Wakulima Products',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                  ),
                  Card(
                    elevation: 10,
                    child: Center(
                        child: Text(
                      'Payments',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
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