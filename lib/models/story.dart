class Story {
  String _id;
  int _idUser;
  String _imageStory;
  String _userName;

  String get id => _id;

  Story(this._id, this._idUser, this._imageStory, this._userName);

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }

  set id(String value) {
    _id = value;
  }

  int get idUser => _idUser;

  String get imageStory => _imageStory;

  set imageStory(String value) {
    _imageStory = value;
  }

  set idUser(int value) {
    _idUser = value;
  }

// Chuyển đổi Object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'idUser': _idUser,
      'imageStory': _imageStory,
      // 'caption': _caption,
      'userName': _userName
    };
  }

// Chuyển đổi JSON sang Object
  static Story fromJson(Map<String, dynamic> json) {
    return Story(json['id'], json['idUser'], json['imageStory'],
        json['userName'] ?? 'Vô danh'
        // json['caption'],
        );
  }
}
