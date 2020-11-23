import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wakulima/services/auth.dart';
import 'package:wakulima/services/database.dart';

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
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recordsSnapshot.documents
        : recordsSnapshot.documents.where((p) => p.startsWith(query)).toList();
    initiateSearch();
    return recordsSnapshot != null
        ? ListView.builder(
            itemBuilder: (context, index) => ListTile(
              onTap: () {},
              leading: Icon(Icons.location_city),
              title: RichText(
                text: TextSpan(
                    text: recordsSnapshot.documents[index].data["email"]
                        .substring(0, query.length),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: recordsSnapshot.documents[index].data["email"]
                              .substring(query.length),
                          style: TextStyle(color: Colors.grey))
                    ]),
              ),
            ),
            itemCount: recordsSnapshot.documents.length,
          )
        : Container();
  }
}
