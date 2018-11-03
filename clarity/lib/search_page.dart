import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'results_page.dart';
import 'feedback_page.dart';

final TextEditingController searchQuery = new TextEditingController();

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  SearchState createState() => new SearchState();
}

class SearchState extends State<SearchPage> {
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

  SearchState() {
    searchQuery.addListener(() {
      if (searchQuery.text.isEmpty) {
        setState(() {
          isSearching = false;
        });
      } else {
        setState(() {
          isSearching = true;
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
              //children: isSearching ? buildSearchList() : buildList(),
              children: isSearching ? buildSearchList() : buildHomePage(),
              scrollDirection: isSearching ? Axis.vertical : Axis.horizontal,
            ),
          ),
        ));
  }

  List<Widget> buildHomePage() {
    return <Widget>[
      Container(
        width: 160.0,
        color: Colors.pink,
        child: Image.network(
          'https://github.com/flutter/website/blob/master/src/_includes/code/layout/lakes/images/lake.jpg?raw=true',
        ),
      ),
      Container(
        width: 160.0,
        color: Colors.white,
        child: Image.network(
          'https://images.ulta.com/is/image/Ulta/2521741?\$md\$',
        ),
      ),
      Container(
        width: 160.0,
        color: Colors.pink,
      ),
      Container(
        width: 160.0,
        color: Colors.white,
      ),
      Container(
        width: 160.0,
        color: Colors.pink,
      ),
    ];
  }

  List<ChildItem> buildSearchList() {
    if (searchQuery.text.isEmpty) {
      return list.map((name) => new ChildItem(this, name)).toList();
    } else {
      List<String> searchList = List();
      for (int i = 0; i < list.length; i++) {
        String item = list.elementAt(i);
        if (item.toLowerCase().contains(searchQuery.text.toLowerCase())) {
          searchList.add(item);
        }
      }
      return searchList.map((name) => new ChildItem(this, name)).toList();
    }
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(
        centerTitle: true,
        title: appBarTitle,
        backgroundColor: new Color(0xffb86b77),
        actions: <Widget>[
          new IconButton(
            icon: actionIcon,
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
                        new IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _handleSearchEnd();
                          },
                        )
                      ]);
                  _handleSearchStart();
                } else {
                  _handleSearchSend(searchQuery.text);
                }
              });
            },
          ),
          new IconButton(
              icon: Icon(Icons.feedback), onPressed: _handleFeedback),
        ]);
  }

  void _handleSearchStart() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.send,
        color: Colors.white,
      );
    });
  }

  void _handleSearchEnd() {
    setState(() {
      searchQuery.clear();
    });
  }

  void _handleSearchSend(String query) {
    _handleSearchEnd();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultsPage(title: 'Results', query: query)),
    );
  }

  void _handleFeedback() {
    _handleSearchEnd();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FeedbackPage()),
    );
  }
}

class ChildItem extends StatelessWidget {
  final SearchState state;
  final String name;

  ChildItem(this.state, this.name);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
        title: new Text(this.name,
            style: new TextStyle(
              color: new Color(0xffb86b77),
            )),
        onTap: () {
          searchQuery.clear();
          state._handleSearchSend(this.name);
        });
  }
}
