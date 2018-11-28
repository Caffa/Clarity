import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import '../results.dart';

class Profile extends StatefulWidget {
  final TextStorage storage = TextStorage();

  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _textField = new TextEditingController();
  String _content = '';

  @override
  void initState() {
    super.initState();

    widget.storage.readFile().then((String text) {
      setState(() {
        _content = text;
        profile.text = _content;
      });
    });
  }

  Future<File> _writeStringToTextFile(String text) async {
    setState(() {
      _content = text;
      profile.text = _content;
    });

    return widget.storage.writeFile(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Profile',
          style: new TextStyle(
            fontSize:
                Theme.of(context).platform == TargetPlatform.iOS ? 17.0 : 20.0,
          ),
        ),
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                if (_textField.text.isNotEmpty) {
                  _writeStringToTextFile(_textField.text);
                  _textField.clear();
                }
              })
        ],
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Hi $_content', style: TextStyle(fontSize: 21.0))
                ]),
            new ListTile(
              leading: const Icon(Icons.face),
              title: new TextField(
                maxLength: 15,
                maxLines: null,
                controller: _textField,
                decoration: new InputDecoration(hintText: 'Edit username'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/profile.txt');
  }

  Future<String> readFile() async {
    try {
      final file = await _localFile;

      String content = await file.readAsString();
      return content;
    } catch (e) {
      return '';
    }
  }

  Future<File> writeFile(String text) async {
    final file = await _localFile;
    return file.writeAsString(text);
  }

  Future<File> cleanFile() async {
    final file = await _localFile;
    return file.writeAsString('');
  }
}
