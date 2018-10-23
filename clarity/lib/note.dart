class Note {
  int _id;
  String _title;
  String _preference;
  String _description;
  String _timestamp;

  Note(this._preference, this._title, this._description);

  Note.map(dynamic obj) {
    this._id = obj['id'];
    this._title = obj['rating'];
    this._preference = obj['preference'];
    this._description = obj['review'];
    this._timestamp = obj['timestamp'];
  }

  int get id => _id;

  String get title => _title;

  String get preference => preference;

  String get description => _description;

  String get timestamp => _timestamp;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['preference'] = _preference;
    map['rating'] = _title;
    map['review'] = _description;
    if (_timestamp != null) {
      map['timestamp'] = _timestamp;
    }

    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._preference = map['preference'];
    this._title = map['rating'];
    this._description = map['review'];
    this._timestamp = map['timestamp'];
  }
}
