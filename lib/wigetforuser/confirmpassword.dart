import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/AppConfig.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class ConfirmPassWord extends StatefulWidget {
  _ConfirmPassWordScreen createState() => _ConfirmPassWordScreen();
  final String email;

  ConfirmPassWord({required this.email});
}

class _ConfirmPassWordScreen extends State<ConfirmPassWord> {
  @override
  void initState() {
    super.initState();
    _emailController =
        TextEditingController(text: widget.email); // Gán giá trị email
  }

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();
  TextEditingController _newPassControllerText = new TextEditingController();
  TextEditingController _confirmPassController = new TextEditingController();

  Future<void> _confirmPassWord() async {
    String email =  _emailController.text;
    String code =  _codeController.text;
    String newPass =  _newPassControllerText.text;
    String confirmPass =  _confirmPassController.text;
    if (email.isEmpty ||
        code.isEmpty ||
        newPass.isEmpty ||
        confirmPass.isEmpty ||
        newPass!= confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng điền đầy đủ thông tin!")),
      );
    }
    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mật khẩu mới và xác nhận mật khẩu phải trùng nhau!")),
      );
      return;
    }
    const String apiUrl = "${AppConfig.baseUrl}/api/user/changewithcode";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailController.text,
          "code": _codeController.text,
          "newPassword": _newPassControllerText.text,
        }),
      );
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Đổi mật khẩu thành công, quay lại giao diện đăng nhập")),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Mã xác nhận không đúng hoặc đã hết hạn!")),
        );
      }
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
                      'https://link-to-your-image.com/image.jpg',
                      // backGroundImage
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
              child: Column(
                children: [
                  // email
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: TextFormField(
                      controller: _emailController, // Hiển thị email đã nhập
                      decoration: InputDecoration(
                        labelText: 'Nhập email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  // new Password
                  Padding(
                    padding: const EdgeInsets.only(top: 16), // Khoảng cách trên
                    child: TextFormField(
                      controller: _newPassControllerText,
                      decoration: InputDecoration(
                        labelText: 'Nhập mật khẩu mới',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16), // Khoảng cách trên
                    child: TextFormField(
                      controller: _confirmPassController,
                      decoration: InputDecoration(
                        labelText: 'Xác nhận mật khẩu',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16), // Khoảng cách trên
                    child: TextFormField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        labelText: 'Nhập mã',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    ),
                    onPressed: _confirmPassWord,
                    child: Text(
                      "Thay đổi mật khẩu",
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
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text(
                          "Trở về đăng nhập",
                          style:
                              TextStyle(decoration: TextDecoration.underline),
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
