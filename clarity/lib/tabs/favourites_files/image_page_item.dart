import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'image_page_transformer.dart';
import 'image_item.dart';

class ImagePageItem extends StatelessWidget {
  ImagePageItem({
    @required this.item,
    @required this.pageVisibility,
  });

  final ImageItem item;
  final PageVisibility pageVisibility;

  @override
  Widget build(BuildContext context) {
    var image = Image.network(
      item.imageUrl,
      fit: BoxFit.scaleDown,
      alignment: FractionalOffset(
        0.5 + (pageVisibility.pagePosition / 3),
        0.5,
      ),
    );

    return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 8.0,
        ),
        child: Material(
          color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            elevation: 2.0,
            child: image));
  }
}
