import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:video_player/video_player.dart';

void main() {
  runApp(Createnewpost());
}

class Createnewpost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CreatePostWidget(),
          ),
        ),
      ),
    );
  }
}

class CreatePostWidget extends StatefulWidget {
  @override
  _CreatePostWidgetState createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  File? _selectedFile;
  final ImagePicker _picker = ImagePicker();
  final String _uploadUrl = 'http://192.168.67.106:8080/api/uploadfile/uploadfile';
  String _fileType = "image";
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  VideoPlayerController? _videoController;
  double _currentPosition = 0.0;
  double _videoDuration = 1.0;
  bool _isPlaying = false;

  // Chọn ảnh hoặc video từ thư viện
  Future<void> _pickFile() async {
    // Hiển thị hộp thoại để chọn ảnh hoặc video
    final pickedFile = await showDialog<File>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Media"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                final pickedVideo = await _picker.pickVideo(source: ImageSource.gallery);
                Navigator.of(context).pop(File(pickedVideo!.path));
              },
              child: Text("Video"),
            ),
            TextButton(
              onPressed: () async {
                final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                Navigator.of(context).pop(File(pickedImage!.path));
              },
              child: Text("Image"),
            ),
          ],
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        _selectedFile = pickedFile;
        _fileType = pickedFile.path.endsWith('.mp4') ? "video" : "image";
      });

      if (_fileType == "video") {
        _videoController = VideoPlayerController.file(_selectedFile!)
          ..initialize().then((_) {
            setState(() {
              _videoDuration = _videoController!.value.duration.inSeconds.toDouble();
            });
            _videoController!.play();
            _isPlaying = true;
          });
      }
    }
  }

  // Upload file lên server
  Future<void> _uploadFile() async {
    if (_selectedFile == null || _captionController.text.isEmpty || _userNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a file and provide caption and username")),
      );
      return;
    }

    final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl))
      ..fields['caption'] = _captionController.text
      ..fields['userName'] = _userNameController.text
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          _selectedFile!.path,
        ),
      );

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Upload successful');
      setState(() {
        _selectedFile = null;
        _captionController.clear();
        _userNameController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Post uploaded successfully!")),
      );
    } else {
      print('Upload failed');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed")),
      );
    }
  }

  // Tua video
  void _seekForward() {
    final currentPosition = _videoController?.value.position ?? Duration.zero;
    final newPosition = currentPosition + Duration(seconds: 10);
    _videoController?.seekTo(newPosition);
  }

  void _seekBackward() {
    final currentPosition = _videoController?.value.position ?? Duration.zero;
    final newPosition = currentPosition - Duration(seconds: 10);
    _videoController?.seekTo(newPosition);
  }

  // Tạm dừng hoặc phát video
  void _togglePlayPause() {
    if (_videoController != null && _videoController!.value.isPlaying) {
      _videoController!.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      _videoController?.play();
      setState(() {
        _isPlaying = true;
      });
    }
  }

  // Cập nhật vị trí video
  void _updatePosition() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      setState(() {
        _currentPosition = _videoController!.value.position.inSeconds.toDouble();
      });
    }
  }

  @override
  void dispose() {
    if (_videoController != null) {
      _videoController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: 400,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create Post",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _captionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Write Here",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(
                hintText: "Enter your username",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image, color: Colors.grey),
                  onPressed: _pickFile,
                ),
                Spacer(),
              ],
            ),
            SizedBox(height: 16),
            if (_selectedFile != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _fileType == "image"
                    ? Image.file(
                  _selectedFile!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : _videoController != null && _videoController!.value.isInitialized
                    ? Column(
                  children: [
                    AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.replay_10),
                          onPressed: _seekBackward,
                        ),
                        IconButton(
                          icon: Icon(Icons.forward_10),
                          onPressed: _seekForward,
                        ),
                        IconButton(
                          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                          onPressed: _togglePlayPause,
                        ),
                      ],
                    ),
                    Slider(
                      min: 0.0,
                      max: _videoDuration,
                      value: _currentPosition,
                      onChanged: (double value) {
                        setState(() {
                          _currentPosition = value;
                        });
                        _videoController?.seekTo(Duration(seconds: value.toInt()));
                      },
                    ),
                  ],
                )
                    : Container(),
              ),
            Row(
              children: [
                DropdownButton<String>(
                  value: "Public",
                  items: ["Public", "Friends", "Only Me"]
                      .map((String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  ))
                      .toList(),
                  onChanged: (value) {},
                ),
                Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text("Cancel", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: _uploadFile,
                  child: Text("Publish"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
