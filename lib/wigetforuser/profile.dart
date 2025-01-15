import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quick_social/ui/followers.dart';
import 'package:quick_social/ui/following.dart';
import 'package:quick_social/wigetforuser/postwidget.dart';
import 'package:quick_social/wigetforuser/updateavatar.dart';
import 'package:quick_social/wigetforuser/updateinfor.dart';

import '../models/user.dart';
import '../service/postservice.dart';
import '../ui/FollowList.dart';
import 'login.dart';


// void main() {
//   runApp(const ProfileApp());
// }

class ProfileApp extends StatelessWidget {
  final String userId;
  const ProfileApp({required this.userId, Key? key}) : super(key: key);
  // const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProfileScreen(),
    );
  }
}
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String imageBackground = "https://hoanghamobile.com/tin-tuc/wp-content/uploads/2024/05/anh-mau-xanh-duong-42.jpg";
  User? currentUser; // Biến lưu trữ thông tin người dùng
  int selectedTabIndex = 0;
  PostService postService = new PostService();
  late List<String> postsImages =[] ;
String imagePath ="" ;
  late List<String> postShareImage = [
  ];
  late List<String> postSavedId = [];
  late List<String> postShareId = [];
  @override
  void initState() {
    super.initState();
    // Gọi _loadUser để tải dữ liệu người dùng và ảnh
    _loadUser();
  }

  Future<void> _loadUser() async {
    final box = GetStorage();
    String? userJsonString = box.read('user');
    if (userJsonString != null) {
      Map<String, dynamic> userJson = jsonDecode(userJsonString);
      setState(() {
        currentUser = User.fromJson(userJson);
      });
    postSavedId = currentUser!.postsSaved;
    postShareId = currentUser!.postsShared;
      // Chuyển đổi List<int> thành List<String>
      List<String> postIds = currentUser!.postsSaved.map((id) => id.toString()).toList();
    imagePath = currentUser!.profileImagePath;
      // Chờ hàm getListImageById trả về trước khi gán vào postsImages
      List<String> images = await postService.getListImageById(postIds);
      List<String> postImageSharesId = currentUser!.postsShared.map((id) => id.toString()).toList();
      List<String> imageShares = await postService.getListImageById(postImageSharesId);
      setState(() {
        postsImages = images;  // Cập nhật dữ liệu ảnh vào postsImages
        postShareImage = imageShares;  // Cập nhật dữ liệu ảnh vào postShareImage
      });
      // print("Image Path: $imagePath");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>  UpdateUserScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.group, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FollowPageList(currentUserId: currentUser!.id),
                ),
              );
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Background and profile picture
            Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  imageBackground,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),

                Positioned(
                  top: 100,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) =>  ChangeProfilePictureApp()),
                      );
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: currentUser?.profileImagePath?.isNotEmpty == true
                          ? NetworkImage(currentUser!.profileImagePath) as ImageProvider
                          : AssetImage('assets/img/avt.jpg'),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),

              ],
            ),
            const SizedBox(height: 30),
            // User information
            Text(
              currentUser?.fullName ?? 'Loading...',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '@${currentUser?.username ?? ''}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              currentUser?.email ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            // Followers and Following
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Điều hướng đến trang FollowersPageList
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FollowersPageList(currentUserId: currentUser?.id ?? ''),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        '${currentUser?.followersCount ?? 0}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text('Followers'),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                GestureDetector(
                  onTap: () {
                    // Điều hướng đến trang FollowingPageList (chưa được định nghĩa, nhưng sẽ tương tự FollowersPageList)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FriendsFollowingScreen(userId: currentUser?.id?? ''),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        '${currentUser?.followingCount ?? 0}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text('Following'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Tab bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedTabIndex = 0;
                    });
                  },
                  child: Text(
                    'Posts',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: selectedTabIndex == 0 ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedTabIndex = 1;
                    });
                  },
                  child: Text(
                    'Tagged',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: selectedTabIndex == 1 ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            buildPostsGrid(
              images: selectedTabIndex == 0 ? postsImages : postShareImage, postIds: postShareId,
            ),
          ],
        ),
      ),
    );
  }
  Widget buildPostsGrid({required List<String> images, required List<String> postIds}) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Điều hướng tới trang chi tiết bài viết và truyền ID bài viết
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SocialPostWidget(postId: postIds[index]),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(images[index]),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

}
