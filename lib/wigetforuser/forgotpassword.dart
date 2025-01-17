import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/AppConfig.dart';
import 'confirmpassword.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
class ForgotPassword extends StatefulWidget {
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  Future<void> _sendCode() async {
    final String email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng nhập email")),
      );
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email không hợp lệ")),
      );
      return;
    }

    const String apiUrl = "${AppConfig.baseUrl}/api/sendmail"; // Replace with your actual API URL
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'recipient': email,
        'subject':"Lấy lại mật khẩu email"
        }),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mã xác nhận đã gửi đến email của bạn")),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmPassWord(email: email),
        ),
      );
      // if (response.statusCode == 200) {
      //   final responseData = jsonDecode(response.body);
      //   if (responseData['status'] == "success") {
      //
      //   } else {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text("Không thể gửi email. Thử lại sau.")),
      //     );
      //   }
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("Email không tồn tại hoặc lỗi hệ thống")),
      //   );
      // }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã xảy ra lỗi: $error")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top background with online image
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Stack(
                children: [
                  // Background image from an online link
                  Positioned.fill(
                    child: Image.network(
                      'https://link-to-your-image.com/image.jpg', // backGroundImage
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Text(
                        "Quên Mật Khẩu",
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
              child: Form(

                child: Column(
                  children: [
                    // Email TextField
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      ),
                      onPressed: _sendCode,
                      child: Text(
                        "Gửi yêu cầu",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 8),
                    // Back to Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                          child: Text(
                            "Trở về đăng nhập",
                            style: TextStyle(decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
