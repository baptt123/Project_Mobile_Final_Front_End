import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../config/AppConfig.dart';
import '../models/user.dart';
import 'home_page.dart';

void main() {
  runApp(Createstory());
}

class Createstory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upload Image Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // Pop the current route if there's a previous route
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    // Navigate to home if there's no previous route
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  }
                },
              );
            },
          ),
          title: Text('Create Story'),
        ),
        body: CreateNewStory(),
      ),
    );
  }
}

class CreateNewStory extends StatefulWidget {
  @override
  CreateNewStoryState createState() => CreateNewStoryState();
}

class CreateNewStoryState extends State<CreateNewStory> {
  File? _image; // Lưu trữ file ảnh đã chọn
  User? currentUser; // Biến để lưu thông tin người dùng
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  // Hàm để lấy thông tin người dùng từ GetStorage
  Future<void> _loadUser() async {
    final box = GetStorage();
    String? userJsonString = box.read('user');
    if (userJsonString != null) {
      // Giải mã JSON thành đối tượng User
      Map<String, dynamic> userJson = jsonDecode(userJsonString);
      currentUser = User.fromJson(userJson);
      userName = currentUser?.username;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Image Picker',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Icon(Icons.battery_full, color: Colors.white),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: _image == null
                      ? GestureDetector(
                    onTap: _showPickerMenu,
                    child: Icon(
                      Icons.add_circle,
                      color: Colors.blue,
                      size: 100,
                    ),
                  )
                      : Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _showPickerMenu,
                      icon: Icon(Icons.photo_camera),
                      label: Text("Chọn Ảnh"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (_image != null) {
                          await _uploadFile(_image!);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Vui lòng chọn ảnh để chia sẻ')),
                          );
                        }
                      },
                      icon: Icon(Icons.upload),
                      label: Text("Upload"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPickerMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Chọn ảnh'),
                onTap: () {
                  _pickImage();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadFile(File file) async {
    if (userName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không tìm thấy thông tin người dùng.')),
      );
      return;
    }

    var uri =
    Uri.parse('${AppConfig.baseUrl}'+'${AppConfig.uploadStoryURL}');
    final request = http.MultipartRequest('POST', uri)
      ..fields['userName'] = userName!
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

    var response = await request.send();
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ảnh đã được chia sẻ thành công!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi khi chia sẻ ảnh')),
      );
    }
  }
}
