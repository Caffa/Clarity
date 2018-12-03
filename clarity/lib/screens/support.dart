import 'package:flutter/material.dart';

class Support extends StatelessWidget {
  final double _imageHeight = 256.0;

  @override
  Widget build(BuildContext context) => new Scaffold(
        //App Bar
        appBar: new AppBar(
          title: new Text(
            'Support',
            style: new TextStyle(
              fontSize: Theme.of(context).platform == TargetPlatform.iOS
                  ? 17.0
                  : 20.0,
            ),
          ),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),

        //Content of tabs
        body: new Stack(
          children: <Widget>[
            _buildImage(_imageHeight),
            _buildBottomPart(_imageHeight),
          ],
        ),
      );
}

Widget _buildImage(double _imageHeight) {
  return new ClipPath(
    clipper: new DialogonalClipper(),
    child: new Image.asset(
      './assets/dog.jpg',
      fit: BoxFit.cover,
      height: _imageHeight,
    ),
  );
}

class DialogonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0.0, size.height - 60.0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

Widget _customListTile(String title, String desc) {
  return new ListTile(
    title: new Text(
      title,
      style: TextStyle(fontSize: 17.0),
    ),
    subtitle: new Text(
      desc,
      style: TextStyle(fontSize: 16.0),
    ),
  );
}

Widget _buildBottomPart(double _imageHeight) {
  return new Padding(
      padding: new EdgeInsets.only(top: _imageHeight),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: new Text(
                'Find us via',
                style: new TextStyle(fontSize: 30.0, color: Colors.black),
              )),
          new Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: _customListTile('Email', 'clarityslyfe@gmail.com')),
          new Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: _customListTile('Site', 'www.clarityslyfe.com')),
          new Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: _customListTile('Campaign', 'http://kck.st/2DK68bX')),
        ],
      ));
}
