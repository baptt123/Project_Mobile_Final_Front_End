import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/AppConfig.dart';
import '../models/post.dart';

class PostService {
   String apiUrl = "${AppConfig.baseUrl}";
  // URL của API để lấy thông tin bài đăng theo ID, sử dụng baseUrl từ AppConfig
  Future<Post> getPostById(String id) async {
    final response = await http.get(Uri.parse(apiUrl+'/api/post/get/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return Post.fromJson(data);
    } else {
      throw Exception('Failed to load post');
    }
  }
  Future<List<String>> getListImageById(List<String> listIdPost) async {
    List<String> images = [];

    for (String id in listIdPost) {
      try {
        final post = await getPostById(id); // Gọi hàm lấy post theo ID
        if (post.media != null) {
          images.add(post.media!); // Thêm URL ảnh nếu không null
        }
      } catch (e) {
        print('Error fetching post with ID $id: $e');
      }
    }

    return images;
  }
   // Cập nhật trạng thái bài viết
   Future<Map<String, dynamic>> updatePost(String postId,
       {bool? isLike, bool? isSaved}) async {
     final response = await http.put(
       Uri.parse('$apiUrl/posts/$postId'),
       headers: {'Content-Type': 'application/json'},
       body: json.encode({
         'isLike': isLike != null ? (isLike ? 1 : 0) : null,
         'isSaved': isSaved != null ? (isSaved ? 1 : 0) : null,
       }),
     );

     if (response.statusCode == 200) {
       return json.decode(response.body);
     } else {
       throw Exception('Failed to update post');
     }
   }
}

void main() async {
  final postService = PostService();
  List<String> postIds = ['6766469550108704fffc2d28', '6766469750108704fffc2d2a', '6766469650108704fffc2d29']; // Giả định danh sách ID bài viết

  try {
    List<String> imageUrls = await postService.getListImageById(postIds);
    print('Danh sách URL hình ảnh: $imageUrls');
  } catch (e) {
    print('Lỗi khi lấy hình ảnh: $e');
  }
}
//
// void main() async {
//   // Tạo instance của PostService
//   final postService = PostService();
//
//   // ID của bài đăng bạn muốn lấy từ API
//   String postId = '6766469750108704fffc2d2a'; // Thay thế bằng ID thật
//
//   try {
//     // Gọi phương thức để lấy bài đăng từ API
//     Post post = await postService.getPostById(postId);
//
//     // In thông tin bài đăng ra console
//     print('Post ID: ${post.id}');
//     print('Caption: ${post.caption}');
//     print('User Name: ${post.user.userName}');
//     print('Like Count: ${post.likeCount}');
//     print('Save Count: ${post.saveCount}');
//     print('Share Count: ${post.shareCount}');
//     print('Media: ${post.media}');
//
//     // Kiểm tra và in danh sách comments (nếu có)
//     if (post.comments.isNotEmpty) {
//       print('Comments: ${post.comments.join(', ')}');
//     } else {
//       print('No comments available');
//     }
//   } catch (e) {
//     // Xử lý khi có lỗi xảy ra (ví dụ: không kết nối được với API)
//     print('Error: $e');
//   }
// }
