import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'background.dart';

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

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;




    final overallHeader = new StreamBuilder(
      stream: Firestore.instance.collection("Lipsticks") .where("name", isEqualTo: widget.query).snapshots(),
      // stream: Firestore.instance.collection('Lipsticks').where('title', isEqualTo: widget.query).snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData) return const Text('Loading...');
        return _buildHeaderList(context, snapshot.data.documents[0]);
      }
    );

    final overallBottomList = new StreamBuilder(
      stream: Firestore.instance.collection("Lipsticks") .where("name", isEqualTo: widget.query).snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData) return const Text('Loading...');
        return _buildBottomList(context, snapshot.data.documents[0]);
      }
    );

    final body = new Scaffold(
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
                      height: 300.0, width: _width, child: overallHeader),
                  overallBottomList,
                 ],
              ),
            ),
          ],
        ),
      ),
    );

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
