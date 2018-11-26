import 'package:flutter/material.dart';
import 'favourites_files/favourite_item.dart';
import 'favourites_files/database_helper.dart';
import '../results.dart';

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => new _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  List<Note> items = new List();
  DatabaseHelper db = new DatabaseHelper();

  @override
  void initState() {
    super.initState();

    db.getAllNotes().then((notes) {
      setState(() {
        notes.forEach((note) {
          items.add(Note.fromMap(note));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return items.length == 0 ? buildEmpty() : buildFaveList();
  }

  Widget buildEmpty() {
    return new Container(
      child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Icon(Icons.favorite, size: 150.0, color: Colors.black12),
            new Text('No favourites added')
          ]),
    );
  }

  Widget buildFaveList() {
    return ListView.builder(
        itemCount: items.length,
        padding: const EdgeInsets.all(15.0),
        itemBuilder: (context, position) {
          return Column(
            children: <Widget>[
              ListTile(
                  title: Text('${items[position].title}',
                      style: TextStyle(fontSize: 16.0)),
                  leading: new Container(
                      width: 50.0,
                      height: 50.0,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(items[position].image),
                            fit: BoxFit.fill),
                      )),
                  trailing: new IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () =>
                          _deleteNote(context, items[position], position)),
                  onTap: () => _navigateToNote(items[position])),
              Divider(height: 20.0)
            ],
          );
        });
  }

  void _deleteNote(BuildContext context, Note note, int position) async {
    db.deleteNote(note.id).then((notes) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToNote(Note note) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ResultsPage(query: note.title))).then((_) {
      setState(() {
        db.getAllNotes().then((notes) {
          setState(() {
            items.clear();
            notes.forEach((note) {
              items.add(Note.fromMap(note));
            });
          });
        });
      });
    });
  }
}
