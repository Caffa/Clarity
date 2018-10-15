import 'package:flutter/material.dart';

  String currentProductName = "Niacinamide";
  List results = [
    {"title": "Ingredient List", "body": "Niacinamide, Aqua"},
    {"title":"Search results", "body": "google search contents google search contents google search contents google search contents" },
    {"title":"Reddit Summary", "body": "positive etc" }

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
      home: new SearchEntryScreen(),
    );
  }
}


class SearchEntryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Search'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchResults()),
            );
          },
        ),
      ),
    );
  }
}

class SearchResults extends StatelessWidget {
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
      floatingActionButton: new FloatingActionButton(onPressed: () {
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

    TextSpan bodyTextWidget = new TextSpan(text: body, style: new TextStyle(color: Colors.black));

    return new RichText(text: new TextSpan(
      children: [
        bodyTextWidget
      ]
    ),);
  }

  ListTile _getListTile(Map subResult) {
    return new ListTile(
      // leading: _getLeadingWidget(currency['title'], color),
      title: _getTitleWidget(subResult['title']),
      subtitle: _getSubtitleText(
          subResult['body']),
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

