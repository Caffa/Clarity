class Note {
  int _id;
  String _title;
  String _image;

  Note(this._title, this._image);

  Note.map(dynamic obj) {
    this._id = obj['id'];
    this._title = obj['title'];
    this._image = obj['image'];
  }

  int get id => _id;

  String get title => _title;

  String get image => _image;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['image'] = _image;

    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._image = map['image'];
  }
}
