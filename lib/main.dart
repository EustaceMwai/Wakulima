import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wakulima',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Welcome to Wakulima App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
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
    );
  }
}
