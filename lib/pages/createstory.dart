import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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
      home: CreateNewStory(),
    );
  }
}

class CreateNewStory extends StatefulWidget {
  @override
  CreateNewStoryState createState() => CreateNewStoryState();
}

class CreateNewStoryState extends State<CreateNewStory> {
  File? _image; // Lưu trữ file ảnh đã chọn

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                            SnackBar(content: Text('Vui lòng chọn ảnh để chia sẻ')),
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
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadFile(File file) async {
    var uri = Uri.parse('http://192.168.67.107:8080/api/uploadfile/uploadfilestory');
    var request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath(
      'file',
      file.path
    ));

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
