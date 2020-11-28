import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wakulima/services/auth.dart';
import 'package:wakulima/services/database.dart';

import 'milk.dart';

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();
  QuerySnapshot recordsSnapshot;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          )
        ],
      ),
      drawer: Drawer(),
    );
  }
}

class DataSearch extends SearchDelegate<dynamic> {
  List<dynamic> litems = ["1", "2", "Third", "4"];

  List<dynamic> cities = ["Tokyo", "nairobi", "Third", "4"];
  List email = [];
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();
  QuerySnapshot recordsSnapshot;
  initiateSearch() async {
    await databaseMethods.getAllUsers().then((val) {
      recordsSnapshot = val;
    });
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    initiateSearch();

    if (recordsSnapshot != null) {
      email.clear();
      recordsSnapshot.documents.forEach((element) {
        email.add(element["farmerId"].toString());
      });
      print(email);
    }
    final suggestionList = query.isEmpty
        ? email
        : email.where((p) => p.startsWith(query)).toList();

    return recordsSnapshot != null
        ? ListView.builder(
            padding:
                const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
            itemBuilder: (context, index) => Card(
              child: ListTile(
                // contentPadding:
                //     EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MilkRecords(
                                email: recordsSnapshot
                                    .documents[index].data["email"],
                                farmerId: recordsSnapshot
                                    .documents[index].data["farmerId"],
                              )));
                },
                leading: Icon(Icons.person),
                title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                            text:
                                "Farmer ID: ${suggestionList[index].substring(0, query.length)}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: suggestionList[index]
                                      .substring(query.length),
                                  style: TextStyle(color: Colors.grey))
                            ]),
                      ),
                      Text(
                          "Name: ${recordsSnapshot.documents[index].data["name"]}"),
                      SizedBox(),
                      Text(
                          "Email: ${recordsSnapshot.documents[index].data["email"]}"),
                    ]),
              ),
            ),
            itemCount: suggestionList.length,
          )
        : Container();
  }
}
