import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../results.dart';

class Home extends StatelessWidget {
  final String siteUrl = 'https://www.sephora.com';

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
        /*onTap: () {
          print('Card selected');
        },*/
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

class Product {
  final String brand;
  final String name;
  final String price;
  final String loves;
  final List<dynamic> images;
  final List<dynamic> details;

  final DocumentReference reference;

  Product.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['brand'] != null),
        assert(map['name'] != null),
        //assert(map['price'] != null),
        assert(map['loves'] != null),
        //assert(map['image'] != null),
        assert(map['details'] != null),
        brand = map['brand'],
        name = map['name'],
        price = map['price'],
        loves = map['loves'],
        images = map['images'],
        details = map['details'];

  Product.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Product<$brand:$name:$price:$loves$images:$details>";
}
