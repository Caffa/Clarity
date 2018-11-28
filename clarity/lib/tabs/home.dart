import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../results.dart';
import '../brands.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:uuid/uuid.dart';
import '../product.dart';

TextEditingController id = new TextEditingController();

class Home extends StatelessWidget {
  final String siteUrl = 'https://www.sephora.com';
  final TextStorage storage = TextStorage();

  Home() {
    createId();
  }

  void createId() {
    storage.readFile().then((String text) {
      if (text == '' || text == null) {
        var uuid = new Uuid();
        String uid = uuid.v1();
        storage.writeFile(uid);
        id.text = uid;
        Firestore.instance
            .collection('Users')
            .add({"user": uid, "timestamp": Timestamp.now()});
      } else {
        id.text = text;
      }
    });
  }

  Widget buildHorizontal(BuildContext context) {
    return Scaffold(
      body: _buildHoriBody(context),
    );
  }

  Widget _buildHoriBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('Products')
          .orderBy('name')
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildHoriList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildHoriList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(top: 10.0),
      children:
          snapshot.map((data) => _buildHoriListItem(context, data)).toList(),
    );
  }

  Widget _buildHoriListItem(BuildContext context, DocumentSnapshot data) {
    final record = Product.fromSnapshot(data);

    EdgeInsets padding =
        const EdgeInsets.only(left: 10.0, right: 10.0, top: 4.0, bottom: 30.0);

    return Padding(
      padding: padding,
      child: new InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BrandsPage(query: data['brand'])));
        },
        child: new Container(
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              new BoxShadow(
                  color: Colors.black.withAlpha(70),
                  offset: const Offset(3.0, 10.0),
                  blurRadius: 15.0)
            ],
            image: new DecorationImage(
              image: new NetworkImage(siteUrl + record.images[0].toString()),
              fit: BoxFit.scaleDown,
            ),
          ),
          //                                    height: 200.0,
          width: 200.0,
          child: new Stack(
            children: <Widget>[
              new Align(
                alignment: Alignment.bottomCenter,
                child: new Container(
                    decoration: new BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: new BorderRadius.only(
                            bottomLeft: new Radius.circular(10.0),
                            bottomRight: new Radius.circular(10.0))),
                    height: 25.0,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          record.brand,
                          style: new TextStyle(
                              color: Colors.white, fontSize: 15.0),
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildVertical(BuildContext context, Widget headerList) {
    return Expanded(
      child: _buildVertBody(context, headerList),
    );
  }

  Widget _buildVertBody(BuildContext context, Widget headerList) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('Products')
          .where(
            'loves',
            isGreaterThan: '1000',
          )
          .orderBy('loves', descending: true)
          .orderBy('name')
          .limit(30)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildVertList(context, snapshot.data.documents, headerList);
      },
    );
  }

  Widget _buildVertList(BuildContext context, List<DocumentSnapshot> snapshot,
      Widget headerList) {
    return ListView(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.only(top: 10.0),
      children: snapshot
          .map((data) => _buildVertListItem(context, data, headerList))
          .toList(),
    );
  }

  Widget _buildVertListItem(
      BuildContext context, DocumentSnapshot data, Widget headerList) {
    final record = Product.fromSnapshot(data);
    return new ListTile(
      onTap: () {
        _handleSearchSend(context, record.name);
      },
      title: new Column(
        children: <Widget>[
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                height: 72.0,
                width: 72.0,
                decoration: new BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.black.withAlpha(70),
                          offset: const Offset(2.0, 2.0),
                          blurRadius: 2.0)
                    ],
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(12.0)),
                    image: new DecorationImage(
                      image:
                          NetworkImage(siteUrl + record.images[0].toString()),
                      fit: BoxFit.scaleDown,
                    )),
              ),
              new SizedBox(
                width: 8.0,
              ),
              new Expanded(
                  child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Padding(
                      padding: EdgeInsets.all(16.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            record.name,
                            style: new TextStyle(
                                fontSize: 15.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                          new Text(
                            record.brand,
                            style: new TextStyle(
                                fontSize: 15.0, color: Colors.black87),
                          )
                        ],
                      )),
                ],
              )),
            ],
          ),
          new Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    final headerList = _buildHoriBody(context);

    final body = new Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: new Container(
        child: new Stack(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.only(top: 15.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                      height: 260.0, width: _width, child: headerList),
                  buildVertical(context, headerList)
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return body;
  }

  void _handleSearchSend(BuildContext context, String query) {
    if (query == null || query == '') {
      print('search cannot be empty');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultsPage(query: query)),
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
    return File('$path/id.txt');
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
