import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quick_social/wigetforuser/profile.dart';

import '../config/AppConfig.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class UpdateUserScreen extends StatefulWidget {
  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  User? currentUser;
  String? id;
  String? username;
  @override
  void initState() {
    super.initState();
    _loadUser();
  }
  Future<void> _loadUser() async {
    final box = GetStorage();
    String? userJsonString = box.read('user');
    if (userJsonString != null) {
      // Giải mã JSON thành đối tượng User
      Map<String, dynamic> userJson = jsonDecode(userJsonString);
      setState(() {
        currentUser = User.fromJson(userJson);
        id = currentUser?.id;
        username = currentUser?.username;
      });
      print("User name: " + (username ?? 'Username is null')); // In ra màn hình log
    }
  }


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  int _gender = 0; // 0: Nam, 1: Nữ

  Future<void> _updateUser() async {
    const String apiUrl = "${AppConfig.baseUrl}/api/user/update";

    // Tạo một Map để lưu trữ các dữ liệu đã nhập
    final Map<String, dynamic> data = {};
    if (id!= null) {
      data['id'] = id;
    }
    if (_emailController.text.trim().isNotEmpty) {
      data['email'] = _emailController.text.trim();
    }
    if (_fullNameController.text.trim().isNotEmpty) {
      data['fullName'] = _fullNameController.text.trim();
    }
    if (_gender == 0 || _gender == 1) {
      data['gender'] = _gender;
    }

    // Kiểm tra nếu không có dữ liệu nào được nhập
    if (data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có dữ liệu nào để cập nhật.')),
      );
      return;
    }

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật thông tin thành công!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(),
          ),
        );
        // Lưu lại thông tin người dùng vào storage
        setState(() {
          // _idController.clear();
          _emailController.clear();
          _fullNameController.clear();
        });

      } else {
        final errorMessage = jsonDecode(response.body)['message'] ?? 'Đã xảy ra lỗi';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $errorMessage')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi kết nối server: $error')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhật thông tin người dùng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Họ và tên',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text('Giới tính:', style: TextStyle(fontSize: 16)),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Nam'),
                    leading: Radio<int>(
                      value: 0,
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Nữ'),
                    leading: Radio<int>(
                      value: 1,
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateUser,
                child: Text('Cập nhật thông tin'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
