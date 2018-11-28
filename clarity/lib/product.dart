import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String brand;
  final String name;
  final String price;
  final String loves;
  final List<dynamic> images;
  final List<dynamic> details;

  final DocumentReference reference;

  Product.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['brand'] != null),
        assert(map['name'] != null),
        //assert(map['price'] != null),
        assert(map['loves'] != null),
        //assert(map['image'] != null),
        assert(map['details'] != null),
        brand = map['brand'],
        name = map['name'],
        price = map['price'],
        loves = map['loves'],
        images = map['images'],
        details = map['details'];

  Product.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Product<$brand:$name:$price:$loves$images:$details>";
}
