import 'package:flutter/material.dart';
import 'dart:async';
import 'database_helper.dart';
import 'note.dart';

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Feedback(),
    );
  }
}

class Feedback extends StatefulWidget {
  @override
  _FeedbackState createState() => new _FeedbackState();
}

class _FeedbackState extends State<Feedback> {
  double rating = 3.5;
  int starCount = 5;
  TextEditingController review = new TextEditingController();

  int radioValue = 0;
  String preference = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Feedback'),
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                submit();
              })
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Divider(height: 35.0),
          new Text('Do you want/need such an app?',
              style: new TextStyle(fontSize: 16.0)),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Radio(
                value: 0,
                groupValue: radioValue,
                onChanged: _handleRadioValueChange,
              ),
              new Text(
                'want',
              ),
              new Radio(
                value: 1,
                groupValue: radioValue,
                onChanged: _handleRadioValueChange,
              ),
              new Text(
                'need',
              ),
              new Radio(
                value: 2,
                groupValue: radioValue,
                onChanged: _handleRadioValueChange,
              ),
              new Text(
                'not at all',
              ),
            ],
          ),
          new Divider(height: 35.0),
          new Text('Rate your experience',
              style: new TextStyle(fontSize: 16.0)),
          new StarRating(
            size: 25.0,
            rating: rating,
            color: Colors.orange,
            borderColor: Colors.grey,
            starCount: starCount,
            onRatingChanged: (rating) => setState(
                  () {
                    this.rating = rating;
                  },
                ),
          ),
          new Divider(height: 35.0),
          new ListTile(
            leading: const Icon(Icons.rate_review),
            title: new TextField(
              maxLength: 150,
              maxLines: null,
              controller: review,
              decoration: new InputDecoration(
                hintText: "What was good, bad or can be improved",
              ),
            ),
          ),
          new Divider(height: 35.0),
          new Text("Thanks for the feedback!"),
        ],
      ),
    );
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      radioValue = value;

      switch (radioValue) {
        case 0:
          preference = 'want';
          break;
        case 1:
          preference = 'need';
          break;
        case 2:
          preference = 'not at all';
          break;
      }
    });
  }

  Future submit() async {
    List notes;
    var db = new DatabaseHelper();

    await db.saveNote(new Note(preference, rating.toString(), review.text));

    print('=== getAllNotes() ===');
    notes = await db.getAllNotes();
    notes.forEach((note) => print(note));

    Navigator.pop(context);
  }
}

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;
  final Color borderColor;
  final double size;

  StarRating(
      {this.starCount = 5,
      this.rating = .0,
      this.onRatingChanged,
      this.color,
      this.borderColor,
      this.size});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    double ratingStarSizeRelativeToScreen =
        MediaQuery.of(context).size.width / starCount;

    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: borderColor ?? Theme.of(context).buttonColor,
        size: size ?? ratingStarSizeRelativeToScreen,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
        size: size ?? ratingStarSizeRelativeToScreen,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
        size: size ?? ratingStarSizeRelativeToScreen,
      );
    }
    return new InkResponse(
      highlightColor: Colors.transparent,
      radius: (size ?? ratingStarSizeRelativeToScreen) / 2,
      onTap:
          onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: new Container(
        height: (size ?? ratingStarSizeRelativeToScreen) * 1.5,
        child: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      type: MaterialType.transparency,
      child: new Center(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: new List.generate(
            starCount,
            (index) => buildStar(context, index),
          ),
        ),
      ),
    );
  }
}
