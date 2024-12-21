import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:quick_social/pages/home_page.dart';
import 'package:quick_social/wigetforuser/forgotpassword.dart';
import 'package:quick_social/wigetforuser/profile.dart';
import 'package:quick_social/wigetforuser/signup.dart';

import '../config/AppConfig.dart';
import '../models/user.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  bool showPassword = false;


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    String username = _emailController.text.trim();
    String password = _passwordController.text.trim();

    const String apiUrl = "${AppConfig.baseUrl}/api/user/signin";
    try {
      // Gửi yêu cầu POST với dữ liệu JSON
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['id'] != null) {
          // Tạo đối tượng User từ dữ liệu server trả về
          final user = User.fromJson(responseData);
          // Xóa mật khẩu để tránh lưu trữ
          user.password = '';
          // Lưu thông tin người dùng vào local storage
          final box = GetStorage();
          box.write('user', jsonEncode(user.toJson()));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Đăng nhập thành công!")),
          );

          // Chuyển hướng đến màn hình khác (ShowUser)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  HomePage()),
          );
        } else {
          // Trường hợp thông tin không hợp lệ
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sai tài khoản hoặc mật khẩu, vui lòng thử lại!")),
          );
        }
      } else {
        // Xử lý các mã lỗi khác từ máy chủ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sai tài khoản hoặc mật khẩu, vui lòng thử lại!")),
        );
      }
    } catch (e, stackTrace) {
      debugPrint("Error: $e");
      debugPrint("Stack Trace: $stackTrace");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top colorful background
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 150,
                      height: 150,
                      color: Colors.lightBlue,
                    ),
                  ),
                  Positioned(
                    top: 100,
                    right: 0,
                    child: Container(
                      width: 150,
                      height: 150,
                      color: Colors.amber,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Text(
                        "Welcome Back",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'User name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText: !showPassword,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value!;
                          });
                        },
                      ),
                      Text("Nhớ mật khẩu"),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: showPassword,
                        onChanged: (value) {
                          setState(() {
                            showPassword = value!;
                          });
                        },
                      ),
                      Text("Hiện thị mật khẩu "),
                    ],
                  ),
                  Container(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.blue, width: 1),
                        ),
                        padding: EdgeInsets.all(20),
                      ),
                      onPressed: _login,
                      child: Text("Đăng nhập"),
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpScreen()),
                          );
                        },
                        child: Text(
                          "Đăng kí",
                          style: TextStyle(decoration: TextDecoration.underline),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPassword()),
                          );
                        },
                        child: Text(
                          "Quên mật khẩu",
                          style: TextStyle(decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
