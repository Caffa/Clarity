/*
* New products must be added to:
* 1) search_words.txt, with '`' delimiter before name    e.g. `Cosrx Advanced Snail Mucin 96 Power Essence
* 2) assets folder, with the same name as in search_words, but replace(' ', '_')    e.g. Cosrx_Advanced_Snail_Mucin_96_Power_Essence.jpg
* 3) pubspec.yaml, with the same name as in assets folder   e.g. assets/Cosrx_Advanced_Snail_Mucin_96_Power_Essence.jpg
* */

import 'package:flutter/material.dart';
import 'search.dart';

String currentProductName = "";

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Clarity',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: new SearchPage(),
    );
  }
}
