class StoryDTO {
  final int id;
  final int idUser;
  final String imageStory;
  final String userName;
  // Constructor
  StoryDTO({
    required this.id,
    required this.idUser,
    required this.imageStory,
    required this.userName
  });

  // Chuyển đổi JSON sang Object
  factory StoryDTO.fromJson(Map<String, dynamic> json) {
    return StoryDTO(
      id: json['id'] as int,
      idUser: json['idUser'] as int,
      imageStory: json['imageStory'] as String,
      userName: json['userName'] as String
    );
  }

  // Chuyển Object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idUser': idUser,
      'imageStory': imageStory,
      'userName':userName
    };
  }
}
