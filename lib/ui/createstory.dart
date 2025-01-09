import 'dart:io';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upload Media Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _file; // Lưu trữ file đã chọn (ảnh hoặc video)
  bool _isVideo = false; // Đánh dấu file là video hay không
  VideoPlayerController? _videoController;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
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
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Media Picker',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Icon(Icons.battery_full, color: Colors.white),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: _file == null
                      ? GestureDetector(
                    onTap: _showPickerMenu,
                    child: Icon(
                      Icons.add_circle,
                      color: Colors.blue,
                      size: 100,
                    ),
                  )
                      : _isVideo
                      ? _videoController != null &&
                      _videoController!.value.isInitialized
                      ? AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
                      : CircularProgressIndicator()
                      : Image.file(
                    _file!,
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
                      label: Text("Chọn Media"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (_file != null) {
                          await _uploadFile(_file!, _isVideo);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Vui lòng chọn file để chia sẻ')),
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
                  _pickMedia(isVideo: false);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.video_library),
                title: Text('Chọn video'),
                onTap: () {
                  _pickMedia(isVideo: true);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickMedia({required bool isVideo}) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    if (isVideo) {
      pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    } else {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }

    if (pickedFile != null) {
      setState(() {
        _file = File(pickedFile!.path);
        _isVideo = isVideo;
      });

      if (isVideo) {
        _videoController = VideoPlayerController.file(_file!)
          ..initialize().then((_) {
            setState(() {});
            _videoController!.play();
          });
      }
    }
  }

  Future<void> _uploadFile(File file, bool isVideo) async {
    var uri = Uri.parse('http://192.168.67.104:8080/api/getdata/uploadfilestory');
    var request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath(
      'file',
      file.path,
      contentType: MediaType(isVideo ? 'video' : 'image', isVideo ? 'mp4' : 'jpeg'),
    ));

    var response = await request.send();
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File đã được chia sẻ thành công!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi khi chia sẻ file')),
      );
    }
  }
}
