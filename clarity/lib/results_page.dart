import 'package:flutter/material.dart';
import 'main.dart';

String currentProductImage = '';
String url = '';

class ResultsPage extends StatelessWidget {
  ResultsPage(String query) {
    currentProductName = query;
    currentProductImage =
        currentProductName.replaceAll('\n', '').replaceAll(' ', '_');
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new ResultsWidget(),
    );
  }
}

class ResultsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _buildBodyImage(),
      backgroundColor: new Color(0xffa56370),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.pop(context); //goes back
        },
        child: new Icon(Icons.keyboard_return),
      ),
    );
  }

  Widget _buildBodyImage() {
    return new Container(
        child: new OverflowBox(
            minWidth: 0.0,
            minHeight: 0.0,
            maxHeight: double.infinity,
            // maxWidth: double.infinity,
            child: new Image(
                image: new AssetImage('assets/$currentProductImage.jpg'),
                fit: BoxFit.cover)));
  }
}
