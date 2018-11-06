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
    Map _googleResults;
    var imageCount = 1;

    @override
    void initState() {
      super.initState();
        // This is the proper place to make the async calls
        // This way they only get called once

        // During development, if you change this code,
        // you will need to do a full restart instead of just a hot reload
        
        // You can't use async/await here,
        // We can't mark this method as async because of the @override
        loadAsyncData().then((result) {
            // If we need to rebuild the widget with the resulting data,
            // make sure to use `setState`
            setState(() {
                _googleResults = result;
            });
        });
    }

  Future<Map> fetchFromCSE(customSearchUrl) async {
    final response = await http.get(customSearchUrl);
    print(response.body);
    // var responseJson = json.decode(response.body.toString());

    // //fixes some odd errors
    // var myString = json.encode(responseJson);
    // var formattedJson = json.decode(myString);

    var formattedJson = json.decode(response.body.toString());
    //get number of results
    int resultCount = 0;
   
    if(formattedJson.containsKey("queries")){
      resultCount = int.parse(formattedJson["queries"]["request"][0]["totalResults"]);
    }
    // print(resultCount);

    String dummyImageUrl = "http://unbxd.com/blog/wp-content/uploads/2014/02/No-results-found.jpg";
    
    List<List<String>> dummyListData = [
      ["No Results found" , 'We could not find any listings from amazon and soko glam']
      ];
      //default assumption cannot find
      String imageLink = dummyImageUrl;
      List<List<String>> bottomListInfo = dummyListData;

    if(resultCount != 0){
      //process this json
      imageLink = formattedJson["items"][0]["pagemap"]["cse_image"][0]["src"];

      var result = formattedJson["items"];
  
      bottomListInfo = new List();
      List<String> productImagesList = new List();
      productImagesList.add("ImageList");
      
  result.forEach((element) {
    try{
    var title = (element["title"]);
    var pgMap = (element["pagemap"]);
    var pgMeta = pgMap["metatags"][0];
//     image check
    if(pgMap.containsKey("cse_image")){
      productImagesList.add(pgMap["cse_image"][0]["src"]);
    }
// gets ratings (might need to put product name)
    if(pgMap.containsKey("aggregaterating")){
       bottomListInfo.add(["Rating Count", pgMap["aggregaterating"][0]["ratingcount"]]);
       bottomListInfo.add(["Rating Value", pgMap["aggregaterating"][0]["ratingvalue"]]);
    }
// gets prices
    if(pgMap.containsKey("offer")){
       bottomListInfo.add(["Offer " + title, pgMap["offer"][0]["price"] + " " + pgMap["offer"][0]["pricecurrency"] ]);
    }
// gets descriptions
    if(pgMeta.containsKey("og")){
      bottomListInfo.add(["Description", pgMeta["og"]["description"] ]);
    }
    //TODO find a way to get reviews?
    									
    }catch(e){
      print(e);
      // print(element["pagemap"]);
    }
   
  });
  
  bottomListInfo.add(productImagesList);
  
  print(bottomListInfo);
 
    }


      var toRet = {
        // Key:    Value
        'headerImg': imageLink,
        'bottomList': bottomListInfo,
      };

    return toRet;

  }

  Future<Map> loadAsyncData(){
    var customSearchUrl = "https://www.googleapis.com/customsearch/v1/siterestrict?key=AIzaSyBqPiaQJjHxVBW7ZYfCKxwqdUl1sFIf3aI&cx=007128306264330162968:4phmp_x0f8g&q=" + widget.query; 
    var googleResults = fetchFromCSE(customSearchUrl);
    return googleResults;  
  }
  
  Widget _buildImageList(List<String> imageLinkList){
    var myHeader =  new ListView.builder(
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
                      imageLinkList[index]),
               
                  fit: BoxFit.fitHeight,
                ),
              ),
              width: 100.0,
            ),
          ),
        );
      },
      scrollDirection: Axis.horizontal,
      itemCount: imageLinkList.length,
    );
    final _width = MediaQuery.of(context).size.width;

    return new Container(height: 100.0, width: _width, child: myHeader);
  }

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

  List<Widget> _complexListItemBuilder(List<String> item){
    List<Widget> toRet = new List<Widget>();
    if(item.length == 1){
      Widget singleObject = new Text(
        item[0],
        style: new TextStyle(
            fontSize: 16.0,
            color: Colors.black87,
            fontWeight: FontWeight.bold),
      );
      toRet.add(singleObject);                           
    }else if(item.length == 2){
      Widget titleObj = new Text(item[0],
              style: new TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
            );
      Widget subTextObj = new Text(
              item[1],
              style: new TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.normal),
            );
      toRet.add(titleObj);
      toRet.add(subTextObj);
    }else{
      //assume the first item dictates how to show it
      //what type of tile? TODO
      if(item[0] == "ImageList"){
        Widget titleObj = new Text("Images",
              style: new TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
            );
        toRet.add(titleObj);
        List<String> imageLinks = item.sublist(1);
        toRet.add(_buildImageList(imageLinks));
      }

    }

    return toRet;

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
                                children: _complexListItemBuilder(itemListInfo[index])
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

  List<Widget> _getContentGoogle(){

    Map infoList = _googleResults;
    String headerImgUrl = infoList["headerImg"];
    List<List<String>> bottomInfoList = infoList["bottomList"];

    Widget headerImg = new Container(
      constraints: BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 200.0,
      ),
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: Text('Loading', style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white)),
      foregroundDecoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(headerImgUrl),
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

    // final googleBody = new FutureBuilder(
    //   future: null,
    //   builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.none: return new Text('Press button to start');
    //       case ConnectionState.waiting: return new Text('Awaiting result...');
    //       case ConnectionState.done:
    //         return googleBodyIntermediate;
    //       default:
    //         if (snapshot.hasError)
    //           return new Text('Error: ${snapshot.error}');
    //         else
    //           return new Text('Result: ${snapshot.data}');
    //     }
    //   },
    // );


    var body;

    bool useFB = false;

    if(useFB){
      body = fbBody;
    }else{
      if(_googleResults == null){
        body = new Text("Loading");
      }else{
        body = googleBody;
      }
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
