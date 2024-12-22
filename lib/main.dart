import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quick_social/wigetforuser/login.dart';
void main() async {
  await GetStorage.init();
  await clearData();
  runApp(MyApp());
}
Future<void> clearData() async {
  final box = GetStorage();
  await box.erase();  // Xóa tất cả dữ liệu trong GetStorage khi ứng dụng khởi động lại
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Tắt chữ "debug"
      home: LoginScreen(), // Màn hình khởi động app
    );
  }
}
