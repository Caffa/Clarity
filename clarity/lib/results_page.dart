import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'background.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class ResultsPage extends StatefulWidget {
  final String query;
  final String title;

  ResultsPage({Key key, this.query, this.title}) : super(key: key);

  @override
  _ResultsPageState createState() => new _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  var imageCount = 1;

  Widget _buildHeaderList(BuildContext context, DocumentSnapshot document){
    return new ListView.builder(
      itemBuilder: (context, index) {
        EdgeInsets padding = 
        index == 0
            ? const EdgeInsets.only(
                left: 20.0, right: 10.0, top: 4.0, bottom: 30.0)
            :
             const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 4.0, bottom: 30.0);

        return new Padding(
          padding: padding,
          child: new InkWell(
            onTap: () {
              print('Card selected');
            },
            child: new Container(
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(10.0),
                color: Colors.lightBlue,
                boxShadow: [
                  new BoxShadow(
                      color: Colors.black.withAlpha(70),
                      offset: const Offset(3.0, 10.0),
                      blurRadius: 15.0)
                ],
                image: new DecorationImage(
                  image: new NetworkImage(
                      document['image']),
               
                  fit: BoxFit.fitHeight,
                ),
              ),
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
                              document['name'],
                              style: new TextStyle(color: Colors.white),
                            )
                          ],
                        )),
                  )
                ],
              ),
            ),
          ),
        );
      },
      scrollDirection: Axis.horizontal,
      itemCount: imageCount,
    );
    
  }

  Widget _buildBottomList(BuildContext context, DocumentSnapshot document){
    //this is for firestore only
    List<List<String>> itemListInfo = [
      ["Price " , document['price']],
      ['Rating: ', document['rating']],
      ['Reviews', "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry"]
    ];

    return new Expanded(
                    child: ListView.builder(
                      itemCount: itemListInfo.length,
                      itemBuilder: (context, index) 
                       {
                    return new ListTile(
                      title: new Column(
                        children: <Widget>[
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Expanded(
                                  child: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text(
                                    itemListInfo[index][0],
                                    style: new TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  new Text(
                                    itemListInfo[index][1],
                                    style: new TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              )),
                            ],
                          ),
                          new Divider(),
                        ],
                      ),
                    );
                  }
                  )
                  );
                

  }

  Widget _buildComplexBottomList(List<List<String>> itemListInfo){

    return new Expanded(
                    child: ListView.builder(
                      itemCount: itemListInfo.length,
                      itemBuilder: (context, index) 
                       {
                    return new ListTile(
                      title: new Column(
                        children: <Widget>[
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Expanded(
                                  child: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text(
                                    itemListInfo[index][0],
                                    style: new TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  new Text(
                                    itemListInfo[index][1],
                                    style: new TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              )),
                            ],
                          ),
                          new Divider(),
                        ],
                      ),
                    );
                  }
                  )
                  );
                

  }

// Future<List> fetchFromCSE(customSearchUrl) async {
//   final response = await http.get(customSearchUrl);
//   print(response.body);
//   List responseJson = json.decode(response.body.toString());
//   return responseJson;
//   }

  List<List<List<String>>> googleCustomSearch() {
    //using widget.query
    // var customSearchUrl = "https://www.googleapis.com/customsearch/v1/siterestrict?key=AIzaSyBqPiaQJjHxVBW7ZYfCKxwqdUl1sFIf3aI&cx=007128306264330162968:4phmp_x0f8g&q=" + widget.query; 
    // List customSearchResults = await fetchFromCSE(customSearchUrl);
    //future builder?
    //todo : check that you got results

    //unpack into standard format


    String imageUrl = "http://cdn.shopify.com/s/files/1/0249/1218/products/Missha-Time-Revolution-The-First-Treatment-Essence-Intensive-Moist_grande_57a9ddeb-9f2c-4772-8955-1aa17cfaa135_grande.jpg?v=1506963497";
    
    List<List<String>> listData = [
      ["Price " , '\$5'],
      ['Rating: ', '5.89'],
      ['General Info', 'lots of dataots of dataots of dataots of dataots of dataots of dataots of dataots of data']
    ];

    //dummy
    return [
      [[imageUrl]],
      listData
    ];

  }

  List<Widget> _getContentGoogle(){

    List<List<List<String>>> infoList = googleCustomSearch();

    String imageUrl = infoList[0][0][0];

    List<List<String>> bottomInfoList = infoList[1];

    // dynamic bottomInfoList = infoList.removeAt(0);

    // List<List<String>> bottomInfoList = [
    //   ["Price " , '\$5'],
    //   ['Rating: ', '5.89'],
    //   ['General Info', 'lots of dataots of dataots of dataots of dataots of dataots of dataots of dataots of data']
    // ];

    Widget headerImg = new Container(
      constraints: BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 200.0,
      ),
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: Text('Loading', style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white)),
      foregroundDecoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
        ),
      ),
    );

    Widget bottomInfo = _buildComplexBottomList(bottomInfoList);

    List<Widget> bodyList = [headerImg, bottomInfo];
    return bodyList;                
  }
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
//Fire base components
    final fbHeader = new StreamBuilder(
      stream: Firestore.instance.collection("Lipsticks") .where("name", isEqualTo: widget.query).snapshots(),
      // stream: Firestore.instance.collection('Lipsticks').where('title', isEqualTo: widget.query).snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData) return const Text('Loading...');
        return _buildHeaderList(context, snapshot.data.documents[0]);
      }
    );
    final fbBottomList = new StreamBuilder(
      stream: Firestore.instance.collection("Lipsticks") .where("name", isEqualTo: widget.query).snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData) return const Text('Loading...');
        return _buildBottomList(context, snapshot.data.documents[0]);
      }
    );
    final fbBody = new Scaffold(
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.pop(context); //goes back
        },
        child: new Icon(Icons.keyboard_return),
      ),
      appBar: new AppBar(
        title: new Text(widget.title),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      body: new Container(
        child: new Stack(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.only(top: 10.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                      height: 300.0, width: _width, child: fbHeader),
                  fbBottomList,
                 ],
              ),
            ),
          ],
        ),
      ),
    );
//Google query components


    final googleBody = new Scaffold(
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.pop(context); //goes back
        },
        child: new Icon(Icons.keyboard_return),
      ),
      appBar: new AppBar(
        title: new Text(widget.title),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      body: new Container(
        child: new Stack(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.only(top: 10.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: 
                  _getContentGoogle()
                 
              ),
            ),
          ],
        ),
      ),

    );



    var body;

    bool useFB = false;

    if(useFB){
      body = fbBody;
    }else{
      body = googleBody;
    }

    return new Container(
      decoration: new BoxDecoration(
        color: const Color(0xFF273A48),
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
}
