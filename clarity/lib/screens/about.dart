import 'package:flutter/material.dart';

class About extends StatelessWidget {
  final double _imageHeight = 256.0;

  @override
  Widget build(BuildContext context) => new Scaffold(
        //App Bar
        appBar: new AppBar(
          title: new Text(
            'About',
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
            _buildTopHeader(),
            _buildBottomPart(_imageHeight),
          ],
        ),
      );
}

Widget _buildImage(double _imageHeight) {
  return new ClipPath(
    clipper: new DialogonalClipper(),
    child: new Image.asset('./assets/succulent.jpg',
        fit: BoxFit.fitHeight,
        height: _imageHeight,
        colorBlendMode: BlendMode.srcOver,
        color: new Color.fromARGB(125, 0, 0, 0)),
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

Widget _buildTopHeader() {
  return new Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
    child: new Row(
      children: <Widget>[
        new Expanded(
          child: new Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: new ListView(
                children: <Widget>[
                  new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        '"Creating time,',
                        style: new TextStyle(
                            fontSize: 26.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      )),
                  new Padding(
                      padding: const EdgeInsets.only(left: 80.0),
                      child: new Text(
                        ' for the things that matter."',
                        style: new TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      )),
                  new Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 170.0),
                      child: new Text(
                        '-Slyfe',
                        style: new TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center,
                      )),
                ],
              )),
        ),
      ],
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
              'Our Inspiration',
              style: new TextStyle(fontSize: 30.0, color: Colors.black),
            )),
        new Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0),
            child: new Text(
              "From the beginning, we were inspired to make life smarter, "
                  "simpler and lazier. The internet gives us tons of data, but "
                  "not in a way that can be quickly absorbed.\n\nWe have the data,"
                  " so what we need are just tools that tell us exactly what we need "
                  "to know, when we want to know.\n\nThat's why Clarity was "
                  "created. It's an app designed to simplify your shopping "
                  "experience when buying any cosmetic or skincare product, "
                  "empowering you with the data to make the best choices you can.",
              style: new TextStyle(fontSize: 15.0, color: Colors.black),
            ))
      ],
    ),
  );
}
