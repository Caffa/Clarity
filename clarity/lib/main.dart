import 'package:flutter/material.dart';
import 'search_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Clarity',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new SearchPage(),
    );
  }
}
