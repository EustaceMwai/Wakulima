import 'package:flutter/material.dart';


import 'bottom.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: <Widget>[
                  Card(
                    elevation: 10,
                    child: Center(
                        child: Text(
                          'Dairy',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                  ),
                  Card(
                    elevation: 10,
                    child: Center(
                        child: Text(
                          'Loans',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                  ),
                  Card(
                    elevation: 10,
                    child: Center(
                        child: Text(
                          'Wakulima Products',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                  ),
                  Card(
                    elevation: 10,
                    child: Center(
                        child: Text(
                          'Payments',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                  )
                ],
              ),
            ),
          ),
          BottomNavigationWidget(),
        ],
      ),
    );
  }
}
