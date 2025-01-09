class Friend {
  String id;
  String fullName;
  String? profileImagePath;
  bool isFavorite;// Không cần nullable vì đã có giá trị mặc định
  bool isFollowing;

  // Constructor
  Friend({
    required this.id,
    required this.fullName,
    this.profileImagePath,
    this.isFavorite = false,
    this.isFollowing = false,
  });
  bool isFriend(Friend other) {
    // Kiểm tra xem nếu ID của bạn là trong danh sách followers của người kia
    return other.isFollowing && this.isFollowing;
  }

  // Chuyển đối tượng Friend sang JSON (gửi lên server)
  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'fullname': fullName,
      'profileImagePath': profileImagePath,
      'isFavorite': isFavorite,
      'isFollowing': isFollowing,
    };
  }

  // Tạo đối tượng Friend từ JSON (Nhận từ dữ liệu từ server)
  factory Friend.fromJSON(Map<String, dynamic> json) {
    return Friend(
      id: json['id'].toString(),
      fullName: json['fullname']?.toString() ??'Vô Danh',
      profileImagePath: json['profileImagePath'] as String?,  // Có thể là null
      isFavorite: json['isFavorite'] ?? false,   // Nếu không có thì mặc định là false
      isFollowing: json['isFollowing'] ?? false, // Đảm bảo là false nếu không có giá trị
    );
  }
}
