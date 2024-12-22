class Friend {
  String id;
  String name;
  String? profileImageUrl;
  bool isFavorite;// Không cần nullable vì đã có giá trị mặc định
  bool isFollowing;

  // Constructor
  Friend({
    required this.id,
    required this.name,
    this.profileImageUrl,
    this.isFavorite = false,
    this.isFollowing = false,
  });

  // Chuyển đối tượng Friend sang JSON (gửi lên server)
  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'isFavorite': isFavorite,
      'isFollowing': isFollowing,
    };
  }

  // Tạo đối tượng Friend từ JSON (Nhận từ dữ liệu từ server)
  factory Friend.fromJSON(Map<String, dynamic> json) {
    return Friend(
      id: json['id'].toString(),
      name: json['name'],
      profileImageUrl: json['profileImageUrl'],  // Có thể là null
      isFavorite: json['isFavorite'] ?? false,   // Nếu không có thì mặc định là false
      isFollowing: json['isFollowing'] ?? false, // Đảm bảo là false nếu không có giá trị
    );
  }
}
