import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

String currentProductName = "Niacinamide";
List results = [
  {"title": "Ingredient List", "body": "Niacinamide, Aqua"},
  {
    "title": "Search results",
    "body":
        "google search contents google search contents google search contents google search contents"
  },
  {"title": "Reddit Summary", "body": "positive etc"}
];

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Clarity',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SearchList(),
    );
  }
}

final TextEditingController _searchQuery = new TextEditingController();

class SearchList extends StatefulWidget {
  SearchList({Key key}) : super(key: key);

  @override
  _SearchListState createState() => new _SearchListState();
}

class _SearchListState extends State<SearchList> {
  Widget appBarTitle = new Text(
    "Search Clarity",
    style: new TextStyle(color: Colors.white),
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final key = new GlobalKey<ScaffoldState>();

  List<String> _list;
  bool _isSearching;
  String _searchText = "";

  _SearchListState() {
    // the 'toggle' to start auto-complete
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    init();
  }

  void init() {
    // load dictionary of search words
    _list = List();
    readData().then((l) {
      _list.addAll(l);
    });
  }

  Future<String> loadAsset() async {
    // get text file containing search words
    return await rootBundle.loadString('assets/search_words.txt');
  }

  Future<List<String>> readData() async {
    // parse and return the search words from text file
    try {
      String body = await loadAsset();
      //print(body);
      List<String> items = body.split("\n");
      //print(items);
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
          home: new Scaffold(
            key: key,
            appBar: buildBar(context),
            body: new ListView(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              children: _isSearching ? _buildSearchList() : _buildList(),
            ),
          ),
        ));
  }

  List<ChildItem> _buildList() {
    // placeholder list containing all search words
    return _list.map((contact) => new ChildItem(contact)).toList();
  }

  List<ChildItem> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _list.map((contact) => new ChildItem(contact)).toList();
    } else {
      // search list containing only matching search words
      List<String> _searchList = List();
      for (int i = 0; i < _list.length; i++) {
        String name = _list.elementAt(i);
        if (name.toLowerCase().contains(_searchText.toLowerCase())) {
          _searchList.add(name);
        }
      }
      return _searchList.map((contact) => new ChildItem(contact)).toList();
    }
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
      new IconButton(
        icon: actionIcon,
        onPressed: () {
          setState(() {
            if (this.actionIcon.icon == Icons.search) {
              this.actionIcon = new Icon(
                Icons.close,
                color: Colors.white,
              );
              this.appBarTitle = new TextField(
                controller: _searchQuery,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.white)),
              );
              _handleSearchStart();
            } else {
              _handleSearchEnd();
            }
          });
        },
      ),
      new RaisedButton(
        child: Text('Search'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchResults(_searchQuery.text)),
          );
        }
      )
    ]);
  }


  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Search Clarity",
        style: new TextStyle(color: Colors.white),
      );
      _isSearching = false;
      _searchQuery.clear();
    });
  }
}

class ChildItem extends StatelessWidget {
  final String name;

  ChildItem(this.name);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
        title: new Text(this.name),
        onTap: () {
          _searchQuery.text = this.name;
        });
  }
}

class SearchResults extends StatelessWidget {
  String search;

  SearchResults(String search) {
    this.search = search;
  }


  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new SearchResultsWidget(results),
    );
  }
}

class SearchResultsWidget extends StatelessWidget {
  final List results;

  SearchResultsWidget(this.results);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _buildBody(),
      backgroundColor: Colors.blue,
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.pop(context); //goes back
        },
        child: new Icon(Icons.keyboard_return),
      ),
    );
  }

  Widget _buildBody() {
    return new Container(
      // A top margin of 56.0. A left and right margin of 8.0. And a bottom margin of 0.0.
      margin: const EdgeInsets.fromLTRB(8.0, 56.0, 8.0, 0.0),
      child: new Column(
        // A column widget can have several widgets that are placed in a top down fashion
        children: <Widget>[_getAppTitleWidget(), _getListViewWidget()],
      ),
    );
  }

  Widget _getAppTitleWidget() {
    return new Text(
      currentProductName,
      style: new TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),
    );
  }

  Widget _getListViewWidget() {
    // We want the ListView to have the flexibility to expand to fill the
    // available space in the vertical axis
    return new Flexible(
        child: new ListView.builder(
            // The number of items to show
            itemCount: results.length,
            // Callback that should return ListView children
            // The index parameter = 0...(itemCount-1)
            itemBuilder: (context, index) {
              // Get the subResult at this position
              final Map subResult = results[index];

              return _getListItemWidget(subResult);
            }));
  }

  Text _getTitleWidget(String title) {
    return new Text(
      title,
      style: new TextStyle(fontWeight: FontWeight.bold),
    );
  }

  RichText _getSubtitleText(String body) {
    // TextSpan priceTextWidget = new TextSpan(text: "\$$priceUsd\n", style:
    // new TextStyle(color: Colors.black),);
    // String percentChangeText = "1 hour: $percentChange1h%";
    // TextSpan percentChangeTextWidget;

    // if(double.parse(percentChange1h) > 0) {
    //   // Currency price increased. Color percent change text green
    //   percentChangeTextWidget = new TextSpan(text: percentChangeText,
    //   style: new TextStyle(color: Colors.green),);
    // }
    // else {
    //   // Currency price decreased. Color percent change text red
    //   percentChangeTextWidget = new TextSpan(text: percentChangeText,
    //       style: new TextStyle(color: Colors.red),);
    // }

    TextSpan bodyTextWidget =
        new TextSpan(text: body, style: new TextStyle(color: Colors.black));

    return new RichText(
      text: new TextSpan(children: [bodyTextWidget]),
    );
  }

  ListTile _getListTile(Map subResult) {
    return new ListTile(
      // leading: _getLeadingWidget(currency['title'], color),
      title: _getTitleWidget(subResult['title']),
      subtitle: _getSubtitleText(subResult['body']),
      isThreeLine: false,
    );
  }

  Container _getListItemWidget(Map subResult) {
    // Returns a container widget that has a card child and a top margin of 5.0
    return new Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: new Card(
        child: _getListTile(subResult),
      ),
    );
  }
}
