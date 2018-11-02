import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  int preference = 0;
  int rating = 3;
  TextEditingController review = new TextEditingController();

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
      body: new ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          new Text('Do you want or need such an app?',
              style: new TextStyle(fontSize: 16.0)),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Radio(
                value: 0,
                groupValue: preference,
                onChanged: _handlePreference,
              ),
              new Text(
                'want',
              ),
              new Radio(
                value: 1,
                groupValue: preference,
                onChanged: _handlePreference,
              ),
              new Text(
                'need',
              ),
              new Radio(
                value: 2,
                groupValue: preference,
                onChanged: _handlePreference,
              ),
              new Text(
                'not at all',
              ),
            ],
          ),
          new Divider(),
          new Text('Rate your experience',
              style: new TextStyle(fontSize: 16.0)),
          new StarRating(
            size: 25.0,
            rating: rating,
            color: Colors.orange,
            borderColor: Colors.grey,
            starCount: 5,
            onRatingChanged: (rating) => setState(
                  () {
                    this.rating = rating;
                  },
                ),
          ),
          new Divider(),
          new ListTile(
            leading: const Icon(Icons.rate_review),
            title: new TextField(
              maxLength: 150,
              maxLines: null,
              controller: review,
              decoration: new InputDecoration(
                hintText: "Share your thoughts",
              ),
            ),
          ),
          new Divider(),
          new Text(
            "Thanks for the feedback!\n© 2018 Clarity by Slyfe",
            style: new TextStyle(fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future submit() async {
    var map = new Map<String, dynamic>();
    map['preference'] = preference;
    map['rating'] = rating;
    map['review'] = review.text;
    map['timestamp'] = new Timestamp.now();
    Firestore.instance.collection('Feedback').add(map);

    Navigator.pop(context);
  }

  void _handlePreference(int value) {
    setState(() {
      preference = value;
    });
  }
}

typedef void RatingChangeCallback(int rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final int rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;
  final Color borderColor;
  final double size;

  StarRating(
      {this.starCount = 5,
      this.rating = 0,
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
      onTap: onRatingChanged == null ? null : () => onRatingChanged(index + 1),
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
