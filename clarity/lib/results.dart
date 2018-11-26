import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tabs/favourites_files/database_helper.dart';
import 'tabs/favourites_files/favourite_item.dart';
import 'tabs/favourites_files/image_page_item.dart';
import 'tabs/favourites_files/image_page_transformer.dart';
import 'tabs/favourites_files/image_item.dart';
import 'screens/profile.dart';

class ResultsPage extends StatefulWidget {
  final String query;

  ResultsPage({Key key, this.query}) : super(key: key);

  @override
  _ResultsPageState createState() => new _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  bool isFave = false;
  Note note;
  DatabaseHelper db = new DatabaseHelper();

  String profileName = profile.text;
  TextEditingController comment = new TextEditingController();

  @override
  void initState() {
    super.initState();

    db.checkNote(widget.query).then((result) {
      isFave = result;
    });
  }

  void _favourite(String image) async {
    if (!isFave) {
      note = Note(widget.query, image);
      db.saveNote(note);
    } else {
      db.deleteNote(await db.getNoteByTitle(widget.query));
    }

    setState(() {
      isFave = !isFave;
    });
  }

  String getImage(List<dynamic> images) {
    String noImage =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1egZw21RC1w1AZaFv9VUw-SjbH39K02L7hKCuNmL5BkfH6rTz';
    String siteUrl = 'https://www.sephora.com';
    if (images == null || images[0].toString() == 'Not Available') {
      return (noImage);
    }
    return (siteUrl + images[0].toString());
  }

  List<dynamic> getImages(List<dynamic> images) {
    String noImage =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1egZw21RC1w1AZaFv9VUw-SjbH39K02L7hKCuNmL5BkfH6rTz';
    String siteUrl = 'https://www.sephora.com';
    List imageList = new List();
    if (images.length > 0) {
      for (dynamic i in images) {
        imageList.add(siteUrl + i);
      }
    } else {
      imageList.add(noImage);
    }
    return imageList;
  }

  Widget _buildTitle(BuildContext context, DocumentSnapshot document) {
    return ListTile(
        title: Text(widget.query,
            style: TextStyle(fontSize: 18.0, color: Colors.indigo)),
        trailing: new IconButton(
            icon:
                Icon(Icons.favorite, color: isFave ? Colors.red : Colors.grey),
            onPressed: () {
              _favourite(getImage(document['images']));
            }));
  }

  Widget _buildHeaderList(BuildContext context, DocumentSnapshot document) {
    List<dynamic> images = getImages(document['images']);
    return new Scaffold(
      body: Center(
        child: SizedBox.fromSize(
          size: const Size.fromHeight(500.0),
          child: PageTransformer(
            pageViewBuilder: (context, visibilityResolver) {
              return PageView.builder(
                controller: PageController(viewportFraction: 0.85),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final item = ImageItem(imageUrl: images[index].toString());
                  final pageVisibility =
                      visibilityResolver.resolvePageVisibility(index);

                  return ImagePageItem(
                    item: item,
                    pageVisibility: pageVisibility,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget detailsTile(String title, String desc) {
    return ExpansionTile(
      title: Text(title, style: TextStyle(fontSize: 16.0)),
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
            child: Text(desc, style: TextStyle(fontSize: 15.0)))
      ],
    );
  }

  Widget usageTile(String title, String desc) {
    List<String> usages = desc.split('-');

    List<ListTile> texts = List();
    for (int i = 1; i < usages.length; i++) {
      texts.add(ListTile(
          leading: Text('$i)', style: TextStyle(fontSize: 16.0)),
          title: Text(usages[i].trim(), style: TextStyle(fontSize: 16.0))));
    }

    return new ExpansionTile(
      title: new Text('Suggested Usage', style: TextStyle(fontSize: 16.0)),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
          child: Column(
              children: texts, crossAxisAlignment: CrossAxisAlignment.start),
        )
      ],
    );
  }

  Widget ingredientsTile(String title, String desc) {
    List<Widget> chips = List();
    List<String> usages = desc.split(', ');

    for (int i = 0; i < usages.length; i++) {
      if (usages[i].length > 30) {
        continue;
      }
      chips.add(Chip(
          label: Text(usages[i].trim().replaceAll('.', ''),
              style: TextStyle(fontSize: 14.0)),
          padding: EdgeInsets.all(1.0)));
    }

    return new ExpansionTile(
      title: new Text('Ingredients', style: TextStyle(fontSize: 16.0)),
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: Wrap(
                spacing: 5.0, // gap between adjacent chips
                children: chips))
      ],
    );
  }

  Widget _buildComment(BuildContext context, List<DocumentSnapshot> documents) {
    return new ListTile(
          title: Text(documents[1]['user']),
          subtitle: Text(documents[1]['comment'])
      );
  }

  Widget buildComments() {
    return new ExpansionTile(
        title: Text('Comments', style: TextStyle(fontSize: 16.0)),
        children: <Widget>[
          new StreamBuilder(
              stream: Firestore.instance
                  .collection("Comments")
                  .where("item", isEqualTo: widget.query)
                  .limit(5)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text('No comments');
                return _buildComment(context, snapshot.data.documents);
              }),
          IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                writeComment(widget.query);
              }),
          IconButton(
              icon: Icon(Icons.rate_review),
              onPressed: () {
                writeComment(widget.query);
              })
        ]
        );
  }

  Widget _customListTile(int index, String title, String desc) {
    if (title == 'Comments') {
      return buildComments();
    } else if (index == 3) {
      return detailsTile(title, desc);
    } else if (index == 4) {
      if (desc.toLowerCase().contains('suggested usage')) {
        return usageTile(title, desc);
      }
      return ingredientsTile(title, desc);
    } else if (index == 5) {
      return ingredientsTile(title, desc);
    }
    return new ListTile(
      title: new Text(
        title,
        style: TextStyle(fontSize: 14.0),
      ),
      subtitle: new Text(
        desc,
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }

  Widget _buildBottomList(BuildContext context, DocumentSnapshot document) {
    String price = document['price'];
    if (document['price'] == null) {
      price = 'not available';
    }
    List<String> itemInfo = [document['brand'], price, document['loves']];
    for (dynamic d in document['details']) {
      itemInfo.add(d.toString());
    }
    itemInfo.add('comments');

    List<String> item = [
      'By',
      'Price',
      'Number of loves',
      'Details',
      'Details',
      'Details',
      'Comments'
    ];

    return new Expanded(
        child: ListView.builder(
      itemCount: itemInfo.length,
      itemBuilder: (context, index) {
        return _customListTile(index, item[index], itemInfo[index]);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    final overallTitle = new StreamBuilder(
        stream: Firestore.instance
            .collection("Products")
            .where("name", isEqualTo: widget.query)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          return _buildTitle(context, snapshot.data.documents[0]);
        });

    final overallHeader = new StreamBuilder(
        stream: Firestore.instance
            .collection("Products")
            .where("name", isEqualTo: widget.query)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('');
          return _buildHeaderList(context, snapshot.data.documents[0]);
        });

    final overallBottomList = new StreamBuilder(
        stream: Firestore.instance
            .collection("Products")
            .where("name", isEqualTo: widget.query)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('');
          return _buildBottomList(context, snapshot.data.documents[0]);
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
                  overallTitle,
                  new Container(
                      height: 250.0, width: _width, child: overallHeader),
                  overallBottomList,
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return body;
  }

  void writeComment(String item) {
    var map = new Map<String, dynamic>();
    map['item'] = item;
    map['user'] = profileName;
    map['comment'] = comment.text;
    map['timestamp'] = new Timestamp.now();
    Firestore.instance.collection('Comment').add(map);
  }
}
