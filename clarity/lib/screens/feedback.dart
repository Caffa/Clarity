import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class Feedback extends StatefulWidget {
  @override
  FeedbackState createState() => new FeedbackState();
}

class FeedbackState extends State<Feedback> {
  int preference = 0;
  int rating = 3;
  TextEditingController review = new TextEditingController();

  @override
  Widget build(BuildContext context) => new Scaffold(
        //App Bar
        appBar: new AppBar(
          title: new Text(
            'Feedback',
            style: new TextStyle(
              fontSize: Theme.of(context).platform == TargetPlatform.iOS
                  ? 17.0
                  : 20.0,
            ),
          ),
          actions: <Widget>[
            new IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  submit();
                })
          ],
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),

        //Content of tabs
        body: new ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          children: <Widget>[
            new ListTile(
              leading: const Icon(Icons.question_answer),
              title: new Text("How do you find this app?",
                  style: new TextStyle(fontSize: 16.0)),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Radio(
                  value: 0,
                  groupValue: preference,
                  onChanged: _handlePreference,
                ),
                new Text(
                  'want it',
                ),
                new Radio(
                  value: 1,
                  groupValue: preference,
                  onChanged: _handlePreference,
                ),
                new Text(
                  'need it',
                ),
                new Radio(
                  value: 2,
                  groupValue: preference,
                  onChanged: _handlePreference,
                ),
                new Text(
                  'not much',
                ),
              ],
            ),
            new Divider(),
            new ListTile(
              leading: const Icon(Icons.stars),
              title: new Text('Rate your experience',
                  style: new TextStyle(fontSize: 16.0)),
            ),
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
              "Thanks for the feedback!",
              style: new TextStyle(fontSize: 14.0),
              textAlign: TextAlign.center,
            ),
            new Text(
              "© 2018 Clarity by Slyfe",
              style: new TextStyle(fontSize: 12.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

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
