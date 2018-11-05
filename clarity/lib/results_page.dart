import 'package:flutter/material.dart';

class ResultsPage extends StatefulWidget {
  final String query;
  final String title;

  ResultsPage({Key key, this.query, this.title}) : super(key: key);

  @override
  _ResultsPageState createState() => new _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(),
        body: Text('Result analysis to be displayed here\n' + widget.query),
        floatingActionButton: new FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: new Icon(Icons.keyboard_return)));
  }
}
