class Story{
int? _id;
int? _idUser;
String _imageStory;

int? get id => _id;

Story(this._id, this._idUser, this._imageStory);

  set id(int? value) {
    _id = value;
  }

int? get idUser => _idUser;

String get imageStory => _imageStory;

  set imageStory(String value) {
    _imageStory = value;
  }

  set idUser(int? value) {
    _idUser = value;
  }
// Chuyển đổi Object sang JSON
Map<String, dynamic> toJson() {
  return {
    'id': _id,
    'idUser': _idUser,
    'imageStory': _imageStory,
    // 'caption': _caption,
  };
}
// Chuyển đổi JSON sang Object
  static Story fromJson(Map<String, dynamic> json) {
    return Story(
      json['id'],
      json['idUser'],
      json['imageStory'],
      // json['caption'],
    );
  }
}