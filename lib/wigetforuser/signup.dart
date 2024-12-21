import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../config/AppConfig.dart';




import 'forgotpassword.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool rememberMe = false;
  String? selectedGender = 'Nam';
  bool showPassword = false;
  final TextEditingController _usernameController  =  TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  Future<void> _register() async {
    final String username = _usernameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String fullName = _fullNameController.text;
    final String gender = _genderController.text == '1' ? 'Nam' : 'Nữ';


    // Kiểm tra dữ liệu hợp lệ
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        fullName.isEmpty) {
      _showMessage('Vui lòng điền đầy đủ thông tin');
      return;
    }

    // Gửi yêu cầu API
    const String apiUrl = "${AppConfig.baseUrl}/api/user/signup";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'fullName': fullName,
          'gender': gender,
        }),
      );

      if (response.statusCode == 200) {
          _showMessage('Đăng ký thành công');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
      } else {
        _showMessage('Tài khoản hoặc mật khẩu đã có người sử dụng, vui lòng thay đổi');
      }
    } catch (error) {
      _showMessage('Đã xảy ra lỗi: $error');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
                        "Create Account",
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
                  //FullName
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'User name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Password TextField
                  // Email TextField

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
                  // Remember Me and Sign In button
                  // RadioListTile for selecting gender
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
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Full name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Password TextField
                  // Password TextField
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text('Nam'),
                          value: 'Nam',
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value;
                              _genderController.text = '1'; // Giá trị cho Nam
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text('Nữ'),
                          value: 'Nữ',
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value;
                              _genderController.text = '0'; // Giá trị cho Nữ
                            });
                          },
                        ),
                      ),
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
                      Text("Hiển thị mật khẩu "),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                    ),
                    onPressed:_register,
                    child: Icon(Icons.arrow_forward),
                  ),
                  SizedBox(height: 8),
                  // Sign Up and Forgot Password links
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=> LoginScreen()));
                        },
                        child: Text(
                          "Đăng nhập",
                          style: TextStyle(decoration: TextDecoration.underline),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=> ForgotPassword()));
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

