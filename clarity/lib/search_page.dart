import 'package:flutter/material.dart';
import 'results_page.dart';
import 'feedback_page.dart';
import 'background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final TextEditingController searchQuery = new TextEditingController();

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  SearchState createState() => new SearchState();
}

class SearchState extends State<SearchPage> {
  final key = new GlobalKey<ScaffoldState>();

  bool isSearching = false;
  bool searchOver = true;

  SearchState() {
    searchQuery.addListener(() {
      if (searchQuery.text.isEmpty) {
        setState(() {
          isSearching = false;
        });
      } else {
        setState(() {
          isSearching = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
          debugShowCheckedModeBanner: false,
          home: new Scaffold(
            resizeToAvoidBottomPadding: false,
            key: key,
            appBar: searchOver ? buildBar() : buildSearchBar(context),
            body: new Container(
              child: isSearching ? buildSearchList(context) : buildHomePage(),
            ),
          ),
        ));
  }

  Widget buildHorizontal(BuildContext context) {
    return Scaffold(
      body: _buildHoriBody(context),
    );
  }

  Widget _buildHoriBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('Lipsticks')
          .orderBy('rating')
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
              image: new NetworkImage(record.image),
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
                        color: Colors.redAccent,
                        borderRadius: new BorderRadius.only(
                            bottomLeft: new Radius.circular(10.0),
                            bottomRight: new Radius.circular(10.0))),
                    height: 30.0,
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
          .collection('Lipsticks')
          .where(
            'rating',
            isGreaterThan: '4.0',
          )
          .orderBy('rating', descending: true)
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
        _handleSearchSend(record.name);
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
                      image: NetworkImage(record.image),
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
                      child: new Text(
                        record.name,
                        style: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
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

  Widget buildHomePage() {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    final headerList = _buildHoriBody(context);

    final body = new Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.transparent,
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
                  new Text(
                    'Featured',
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0),
                  ),
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

    return new Container(
      decoration: new BoxDecoration(
        color: Colors.redAccent,
      ),
      child: new Stack(
        children: <Widget>[
          new CustomPaint(
            size: new Size(_width, _height),
            painter: new Background(),
          ),
          body,
        ],
      ),
    );
  }

  Widget buildSearchList(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("Lipsticks").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Container();
          return new ListView(children: getSearchItems(snapshot));
        });
  }

  getSearchItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<DocumentSnapshot> docs = snapshot.data.documents;
    List<String> names = List();
    List<ChildItem> searchList = List();
    for (var d in docs) {
      names.add(Product.fromSnapshot(d).name);
      if (!names.contains(Product.fromSnapshot(d).brand)) {
        names.add(Product.fromSnapshot(d).brand);
      }
    }
    for (int i = 0; i < names.length; i++) {
      String item = names.elementAt(i);
      if (item.toLowerCase().contains(searchQuery.text.toLowerCase())) {
        searchList.add(ChildItem(this, item));
      }
    }
    return searchList;
  }

  Widget buildBar() {
    return new AppBar(
      backgroundColor: Colors.redAccent,
      actions: <Widget>[
        new IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                searchOver = false;
              });
            }),
        new IconButton(icon: Icon(Icons.feedback), onPressed: _handleFeedback),
      ],
    );
  }

  Widget buildSearchBar(BuildContext context) {
    return new AppBar(
        centerTitle: true,
        title:
            new Stack(alignment: const Alignment(1.0, 1.0), children: <Widget>[
          new TextField(
            controller: searchQuery,
            style: new TextStyle(
              color: Colors.white,
            ),
            decoration: new InputDecoration(
                hintText: "Type to search",
                hintStyle: new TextStyle(color: Colors.white)),
          ),
          new IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _handleSearchEnd();
              })
        ]),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: () {
                _handleSearchSend(searchQuery.text);
              })
        ]);
  }

  void _handleSearchEnd() {
    setState(() {
      searchQuery.clear();
    });
  }

  void _handleSearchSend(String query) {
    setState(() {
      searchOver = true;
    });
    _handleSearchEnd();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ResultsPage(title: 'Results', query: query)),
    );
  }

  void _handleFeedback() {
    _handleSearchEnd();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FeedbackPage()),
    );
  }
}

class ChildItem extends StatelessWidget {
  final SearchState state;
  final String name;

  ChildItem(this.state, this.name);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
        title: new Text(this.name,
            style: new TextStyle(
              color: Colors.redAccent,
            )),
        onTap: () {
          searchQuery.clear();
          state._handleSearchSend(this.name);
        });
  }
}

class Product {
  final String brand;
  final String name;
  final String price;
  final String rating;
  final String image;
  final String link;

  final DocumentReference reference;

  Product.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['brand'] != null),
        assert(map['name'] != null),
        assert(map['price'] != null),
        assert(map['rating'] != null),
        assert(map['image'] != null),
        assert(map['link'] != null),
        brand = map['brand'],
        name = map['name'],
        price = map['price'],
        rating = map['rating'],
        image = map['image'],
        link = map['link'];

  Product.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Product<$brand:$name:$price:$rating:$image:$link>";
}

class Brand {
  final String name;
  final String image;

  final DocumentReference reference;

  Brand.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['image'] != null),
        name = map['name'],
        image = map['image'];

  Brand.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Product<$name:$image>";
}
