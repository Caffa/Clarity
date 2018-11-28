import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'results.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'tabs/home.dart';

class CommentsPage extends StatefulWidget {
  final String query;

  CommentsPage({Key key, this.query}) : super(key: key);

  @override
  _CommentsPageState createState() => new _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController comment = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final overallComments = new StreamBuilder(
        stream: Firestore.instance
            .collection("Comments")
            .where("item", isEqualTo: widget.query)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Padding(
                padding: EdgeInsets.all(50.0),
                child: CircularProgressIndicator());
          return _buildComments(context, snapshot.data.documents);
        });

    final body = new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.white,
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
                    new Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: new Text(widget.query,
                            style: TextStyle(
                                fontSize: 18.0, color: Colors.indigo))),
                    overallComments,
                    new ListTile(
                        title: new TextField(
                          maxLines: null,
                          maxLength: 180,
                          controller: comment,
                          decoration: InputDecoration(hintText: 'Write here'),
                        ),
                        trailing: new IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              writeComment();
                            }))
                  ]),
            ),
          ],
        ),
      ),
    );

    return body;
  }

  Widget buildEmpty() {
    return new Container(
      child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Icon(Icons.comment, size: 150, color: Colors.black12),
            new Text('Be the first to comment!')
          ]),
    );
  }

  Widget _buildComments(
      BuildContext context, List<DocumentSnapshot> documents) {
    if (documents.length < 1) {
      return new Expanded(child: buildEmpty());
    }

    return new Expanded(
        child: ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              return new Container(
                child: ListTile(
                    title: Text(documents[index]['comment'],
                        style: TextStyle(fontSize: 15.0)),
                    subtitle: Text(
                        'By ' +
                            documents[index]['user'] +
                            ' on ' +
                            DateFormat('dd MMM kk:mm').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(documents[index]['timestamp']))),
                        style: TextStyle(fontSize: 13.0))),
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                decoration: BoxDecoration(
                    color: new Color(0xffE8E8E8),
                    borderRadius: BorderRadius.circular(8.0)),
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
              );
            }));
  }

  void writeComment() {
    if (comment.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Comment cannot be empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          bgcolor: "#3f51b5",
          textcolor: '#ffffff');
      return;
    }
    var map = new Map<String, dynamic>();
    map['id'] = id.text;
    map['item'] = widget.query;
    map['user'] = profile.text.isEmpty ? 'anonymous' : profile.text;
    map['comment'] = comment.text;
    map['timestamp'] = DateTime.now().millisecondsSinceEpoch.toString();
    Firestore.instance.collection('Comments').add(map);
    comment.clear();
  }
}
