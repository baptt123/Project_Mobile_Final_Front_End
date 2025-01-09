// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
//
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
//
// import '../model/message.dart';
//
//
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Simple Chat App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ChatScreen(),
//     );
//   }
// }
//
// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final List<String> _messages = [];
//   late WebSocketChannel _channel;
//   final ImagePicker _picker = ImagePicker();
//   final Random _random = Random();
//
//   @override
//   void initState() {
//     super.initState();
//     _channel = WebSocketChannel.connect(
//         Uri.parse('ws://192.168.67.104:8080/chat')
//     );
//
//     // Lắng nghe tin nhắn từ WebSocket server
//     _channel.stream.listen((message) {
//       setState(() {
//         _messages.add("Other: $message");
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _channel.sink.close(status.goingAway);
//     super.dispose();
//   }
//
//   void _sendMessage() {
//     if (_controller.text.isNotEmpty) {
//       Message message = Message(
//           _random.nextInt(1000),
//           _controller.text,
//           DateTime.now(),
//           _random.nextInt(500),
//           _random.nextInt(300)
//       );
//       String messageResult = jsonEncode(message);
//       _channel.sink.add(messageResult);
//       setState(() {
//         _messages.add("You: ${_controller.text}");
//         _controller.clear();
//       });
//     }
//   }
//
//   // Hàm chọn và gửi file
//   Future<void> _pickFile() async {
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Chọn phương tiện'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: Icon(Icons.photo),
//                 title: Text('Chọn ảnh'),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   _pickMediaFromSource(ImageSource.gallery, isVideo: false);
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.video_library),
//                 title: Text('Chọn video'),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   _pickMediaFromSource(ImageSource.gallery, isVideo: true);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _pickMediaFromSource(ImageSource source, {bool isVideo = false}) async {
//     final XFile? file = isVideo
//         ? await _picker.pickVideo(source: source)
//         : await _picker.pickImage(source: source);
//
//     if (file != null) {
//       File selectedFile = File(file.path);
//       List<int> bytes = await selectedFile.readAsBytes();
//       String base64File = base64Encode(bytes);
//
//       // Tạo message cho file
//       Message message = Message(
//           _random.nextInt(1000),
//           base64File,
//           DateTime.now(),
//           _random.nextInt(500),
//           _random.nextInt(300)
//       );
//       String messageResult = jsonEncode(message);
//
//       // Gửi file qua WebSocket
//       _channel.sink.add(messageResult);
//
//       setState(() {
//         _messages.add("You: ${isVideo ? 'Sent a video' : 'Sent an image'}");
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat App'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(_messages[index]),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(
//                       hintText: 'Enter your message...',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.photo_library),
//                   onPressed: _pickFile,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
