import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'results.dart';
import 'product.dart';

class BrandsPage extends StatefulWidget {
  final String query;

  BrandsPage({Key key, this.query}) : super(key: key);

  @override
  _BrandsPageState createState() => new _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage> {
  final String siteUrl = 'https://www.sephora.com';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.white,
      body: _buildVertBody(context),
    );
  }

  Widget _buildVertBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('Products')
          .where('brand', isEqualTo: widget.query)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildVertList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildVertList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.only(top: 10.0),
      children:
          snapshot.map((data) => _buildVertListItem(context, data)).toList(),
    );
  }

  Widget _buildVertListItem(BuildContext context, DocumentSnapshot data) {
    final record = Product.fromSnapshot(data);
    return new ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResultsPage(query: data['item'])));
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
                            'USD ' + record.price,
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
}
