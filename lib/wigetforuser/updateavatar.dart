import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:quick_social/wigetforuser/profile.dart';
import '../config/AppConfig.dart';
import '../models/user.dart';

class ChangeProfilePictureApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Đổi ảnh đại diện"),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: _ChangeProfilePictureWidget(),
        ),
      ),
    );
  }
}

class _ChangeProfilePictureWidget extends StatefulWidget {
  @override
  _ChangeProfilePictureWidgetState createState() =>
      _ChangeProfilePictureWidgetState();
}

class _ChangeProfilePictureWidgetState extends State<_ChangeProfilePictureWidget> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  static const String apiUrl = "${AppConfig.baseUrl}/api/uploadfile/updateavatar";
  User? currentUser;
  String? id;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }
  Future<void> updateProfileImagePath(String newPath) async {
    final box = GetStorage();
    String? userJsonString = box.read('user');

    if (userJsonString != null) {
      // Chuyển đổi JSON thành đối tượng User
      Map<String, dynamic> userJson = jsonDecode(userJsonString);
      User user = User.fromJson(userJson);

      // Cập nhật profileImagePath
      user.profileImagePath = newPath;

      // Ghi lại vào local storage
      box.write('user', jsonEncode(user.toJson()));

      // Tải lại thông tin người dùng để cập nhật giao diện (nếu cần)
      await _loadUser();

      print('Profile image path updated successfully: $newPath');
    } else {
      print('No user data found in local storage.');
    }
  }

  // Tải thông tin người dùng từ GetStorage
  Future<void> _loadUser() async {
    final box = GetStorage();
    String? userJsonString = box.read('user');
    if (userJsonString != null) {
      Map<String, dynamic> userJson = jsonDecode(userJsonString);
      setState(() {
        currentUser = User.fromJson(userJson);
        id = currentUser?.id;
      });
    }
  }

  // Chọn ảnh từ thư viện
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Hàm gọi API để cập nhật ảnh đại diện
  Future<void> _updateAvatar() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hãy chọn ảnh trước khi tiếp tục")),
      );
      return;
    }

    try {
      final uri = Uri.parse("$apiUrl/$id"); // truyền `id` qua URL
      var request = http.MultipartRequest('PUT', uri);

      // Lấy mime type của ảnh
      String? mimeType = lookupMimeType(_selectedImage!.path);
      if (mimeType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Không thể xác định loại ảnh")),
        );
        return;
      }

      // Thêm file vào request
      var file = await http.MultipartFile.fromPath(
        'file', // Đây là tên field mà API yêu cầu, phải trùng với tên trong @RequestParam("file")
        _selectedImage!.path,
        contentType: MediaType.parse(mimeType),
      );

      request.files.add(file);

      // Gửi yêu cầu PUT với ID và ảnh
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('$responseBody');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ảnh đại diện đã được cập nhật")),
        );
          updateProfileImagePath(responseBody);
          await _loadUser();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  ProfileScreen()),
        );
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Update failed with status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cập nhật ảnh thất bại: $responseBody")),
        );
      }
    } catch (e) {
      print('Error uploading avatar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi tải ảnh đại diện")),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage:
            _selectedImage != null ? FileImage(_selectedImage!) : null,
            child: _selectedImage == null
                ? Icon(
              Icons.person,
              size: 80,
              color: Colors.grey[300],
            )
                : null,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.photo_library),
                label: Text("Chọn từ thư viện"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
              SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _updateAvatar,
                icon: Icon(Icons.upload),
                label: Text("Cập nhật ảnh"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
