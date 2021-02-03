import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wakulima/views/users.dart';

class Admin extends StatefulWidget {
  const Admin({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  String userId;
  void _getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      userId = user.uid;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin page'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('wakulima')
            .document(userId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
            // return Container();
          } else if (snapshot.hasData) {
            return checkRole(snapshot.data);
            // snapshot.hasData ? checkRole(snapshot.data) :Container();
            // return Text(snapshot.data['email']);
          }

          return LinearProgressIndicator();
        },
      ),
    );
  }

  Center checkRole(DocumentSnapshot snapshot) {
    if (snapshot.data == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (snapshot.data['admin'] == true) {
      return adminPage(snapshot);
    } else {
      return userPage(snapshot);
    }
  }

  Center adminPage(DocumentSnapshot snapshot) {
    return Center(
        child: RaisedButton(
      child: Text('Go to Dairy'),
      color: Colors.blue,
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Users()));
      },
    ));
  }

  Center userPage(DocumentSnapshot snapshot) {
    return Center(child: Text("You are not an admin"));
  }
}
