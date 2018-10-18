import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'results.dart';

final TextEditingController searchQuery = new TextEditingController();

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  SearchPageState createState() => new SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  Widget appBarTitle = new Text(
    "Search Clarity",
    style: new TextStyle(color: Colors.white),
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final key = new GlobalKey<ScaffoldState>();

  List<String> list;
  bool isSearching;
  String searchText = "";

  SearchPageState() {
    searchQuery.addListener(() {
      if (searchQuery.text.isEmpty) {
        setState(() {
          isSearching = false;
          searchText = "";
        });
      } else {
        setState(() {
          isSearching = true;
          searchText = searchQuery.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    isSearching = false;
    list = List();
    readData().then((l) {
      list.addAll(l);
    });
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/search_words.txt');
  }

  Future<List<String>> readData() async {
    try {
      String body = await loadAsset();
      List<String> items = body.split("`");
      /*for (String i in items) {
        print(i);
        print(i.length);
      }*/
      return items;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
          debugShowCheckedModeBanner: false,
          home: new Scaffold(
            key: key,
            appBar: buildBar(context),
            body: new ListView(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              children: isSearching ? buildSearchList() : buildList(),
            ),
          ),
        ));
  }

  List<ChildItem> buildList() {
    return list.map((contact) => new ChildItem(contact)).toList();
  }

  List<ChildItem> buildSearchList() {
    if (searchText.isEmpty) {
      return list.map((contact) => new ChildItem(contact)).toList();
    } else {
      List<String> searchList = List();
      for (int i = 0; i < list.length; i++) {
        String item = list.elementAt(i);
        if (item.toLowerCase().contains(searchText.toLowerCase())) {
          searchList.add(item);
        }
      }
      return searchList.map((contact) => new ChildItem(contact)).toList();
    }
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: appBarTitle, backgroundColor: new Color(0xffb86b77), actions: <Widget>[
      new IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          setState(() {
            if (this.actionIcon.icon == Icons.search) {
              this.appBarTitle = new Stack(
                  alignment: const Alignment(1.0, 1.0),
                  children: <Widget>[
                    new TextField(
                      controller: searchQuery,
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                      decoration: new InputDecoration(
                          hintText: "Search...",
                          hintStyle: new TextStyle(color: Colors.white)),
                    ),
                    new FlatButton(
                        textColor: Colors.white,
                        onPressed: () {
                          _handleSearchEnd();
                        },
                        child: new Icon(Icons.clear))
                  ]);
              _handleSearchStart();
            } else {
              _handleSearchSend();
            }
          });
        },
      ),
    ]);
  }

  void _handleSearchStart() {
    setState(() {
      isSearching = true;
      this.actionIcon = new Icon(
        Icons.send,
        color: Colors.white,
      );
    });
  }

  void _handleSearchEnd() {
    setState(() {
      searchQuery.clear();
      isSearching = false;
    });
  }

  void _handleSearchSend() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultsPage(searchQuery.text)),
    );
  }
}

class ChildItem extends StatelessWidget {
  final String name;

  ChildItem(this.name);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
        title: new Text(this.name, style: new TextStyle(
          color: new Color(0xffb86b77),
        )),
        onTap: () {
          searchQuery.text = this.name;
        });
  }
}
