import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wakulima/model/user.dart';
import 'package:wakulima/services/auth.dart';
import 'package:wakulima/services/database.dart';
import 'package:wakulima/widgets/widget.dart';

import 'milk.dart';

class Users extends StatefulWidget {
  String userId;

  Users({this.userId});

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Farmers'),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.people_outline),
                text: 'farmers',
              ),
              Tab(
                icon: Icon(Icons.search),
                text: 'search',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [Farmer(), SearchFarmer()],
        ),
      ),
    );
  }
}

class Farmer extends StatefulWidget {
  @override
  _FarmerState createState() => _FarmerState();
}

class _FarmerState extends State<Farmer> {
  final formKey = GlobalKey<FormState>();
  TextEditingController todayMilkController = new TextEditingController();
  TextEditingController previousMilkController = new TextEditingController();
  TextEditingController cumulativeMilkController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();

  QuerySnapshot recordsSnapshot;
  FirebaseUser username;
  String name = 'eustace';
  String email;
  double total = 0.0;

  List<String> litems = [];

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  @override
  void initState() {
    initiateSearch();
    super.initState();
  }

  Widget recordList() {
    return recordsSnapshot != null
        ? ListView.builder(
            itemCount: recordsSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return recordTile(
                  email: recordsSnapshot.documents[index].data["email"],
                  name: recordsSnapshot.documents[index].data["name"],
                  farmerId: recordsSnapshot.documents[index].data["farmerId"]);
            })
        : Container();
  }

  initiateSearch() {
    databaseMethods.getAllUsers().then((val) {
      setState(() {
        recordsSnapshot = val;
      });
    });
  }

  Widget recordTile({String email, String name, int farmerId}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MilkRecords(email: email, farmerId: farmerId, name: name)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.green, spreadRadius: 3),
            ],
          ),
          width: 50,
          height: 70,
          child: Card(
            child: Center(
              child: Text(
                'Name: $name\nID: $farmerId\nEmail: $email',
                // style: mediumTextStyle(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
          stream: Firestore.instance.collection("wakulima").snapshots(),
          builder: (context, snapshot) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child:
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                recordList(),
              ]),
            );
          }),
    );
  }
}

class SearchFarmer extends StatefulWidget {
  @override
  _SearchFarmerState createState() => _SearchFarmerState();
}

class _SearchFarmerState extends State<SearchFarmer> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController =
      new TextEditingController();
  QuerySnapshot searchSnapshot;
  QuerySnapshot recordsSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                  userName: searchSnapshot.documents[index].data["name"],
                  farmerId: searchSnapshot.documents[index].data["farmerId"],
                  email: searchSnapshot.documents[index].data["email"]);
            })
        : Container();
  }

  initiateSearch() {
    databaseMethods
        .getFarmerId(int.parse(searchTextEditingController.text))
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  Widget SearchTile({String userName, int farmerId, String email}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userName,
                style: mediumTextStyle(),
              ),
              Text(
                "farmerId: $farmerId",
                style: mediumTextStyle(),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MilkRecords(
                          email: email, farmerId: farmerId, name: userName)));
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Text(
                "Dairy",
                style: mediumTextStyle(),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            color: Color(0x54FFFFFF),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  controller: searchTextEditingController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: "search farmer Id...",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none),
                )),
                GestureDetector(
                  onTap: () {
                    initiateSearch();
                  },
                  child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            const Color(0x36FFFFFF),
                            const Color(0x0FFFFFFF)
                          ]),
                          borderRadius: BorderRadius.circular(40)),
                      padding: EdgeInsets.all(12),
                      child: Image.asset("assets/images/search_white.png")),
                )
              ],
            ),
          ),
          searchList()
        ],
      ),
    );
  }
}
