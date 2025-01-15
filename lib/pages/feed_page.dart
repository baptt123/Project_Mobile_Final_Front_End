// import 'package:flutter/material.dart';
// import 'package:quick_social/models/models.dart';
// import 'package:quick_social/widgets/widgets.dart';
//
// class FeedPage extends StatelessWidget {
//   const FeedPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return Scaffold(
//       appBar: _appBar(theme),
//       body: ResponsivePadding(
//         child: ListView(
//           children: [
//             SizedBox(
//               height: 110,
//               child: ListView.builder(
//                 itemCount: UserStory.dummyUserStories.length,
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 itemBuilder: (_, index) {
//                   return Padding(
//                     padding: EdgeInsets.only(
//                       left: index == 0 ? 4 : 0,
//                       right: index == UserStory.dummyUserStories.length - 1
//                           ? 4
//                           : 0,
//                     ),
//                     // child: UserStoryTile(index: index),
//                   );
//                 },
//               ),
//             ),
//             ListView.separated(
//               itemCount: Post.dummyPosts.length,
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               separatorBuilder: (_, index) {
//                 return const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   child: Divider(height: 4),
//                 );
//               },
//               itemBuilder: (_, index) => PostCard(post: Post.dummyPosts[index]),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   AppBar _appBar(ThemeData theme) {
//     return AppBar(
//       automaticallyImplyLeading: false,
//       flexibleSpace: ResponsivePadding(
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const AppLogo(),
//                 IconButton(
//                   onPressed: () {},
//                   icon: Icon(
//                     Icons.send_sharp,
//                     color: theme.colorScheme.primary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



// feed page
// import 'package:flutter/material.dart';
// import 'package:quick_social/api/callingapi.dart';
// import 'package:quick_social/widgets/post_card.dart';
//
// import '../dto/postdto.dart';
// import '../widgets/layout/responsive_padding.dart';
//
// class FeedPage extends StatefulWidget {
//   const FeedPage({super.key});
//
//   @override
//   State<FeedPage> createState() => _FeedPageState();
// }
//
// class _FeedPageState extends State<FeedPage> {
//   List<PostDTO> _posts = []; // Danh sách bài đăng
//   bool _isLoading = true; // Trạng thái loading
//   String? _error; // Lỗi nếu có
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchPosts();
//   }
//
//   Future<void> _fetchPosts() async {
//     try {
//       final posts = await CallingAPI.fetchPosts(); // Gọi API
//       setState(() {
//         _posts = posts; // Cập nhật danh sách bài đăng
//         _isLoading = false; // Tắt loading
//       });
//     } catch (e) {
//       setState(() {
//         _error = 'Failed to load posts: $e'; // Xử lý lỗi
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return Scaffold(
//       appBar: _appBar(theme),
//       body: ResponsivePadding(
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator()) // Loading
//             : _error != null
//             ? Center(child: Text(_error!)) // Hiển thị lỗi
//             : ListView.separated(
//           itemCount: _posts.length,
//           separatorBuilder: (_, __) => const Divider(),
//           itemBuilder: (_, index) => PostCard(post: _posts[index]), // Hiển thị dữ liệu
//         ),
//       ),
//     );
//   }
//
//   AppBar _appBar(ThemeData theme) {
//     return AppBar(
//       automaticallyImplyLeading: false,
//       flexibleSpace: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Feed', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//               IconButton(
//                 onPressed: () {},
//                 icon: Icon(Icons.send_sharp, color: theme.colorScheme.primary),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:quick_social/api/callingapi.dart';
import 'package:quick_social/models/story.dart';
import 'package:story/story_page_view.dart'; // Thư viện story
import '../models/post.dart';
import '../widgets/post_card.dart';
import '../widgets/layout/responsive_padding.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Story> _stories = []; // Danh sách stories
  List<Post> _posts = []; // Danh sách posts
  bool _isLoadingStories = true; // Trạng thái loading stories
  bool _isLoadingPosts = true; // Trạng thái loading posts
  String? _errorStories; // Lỗi story
  String? _errorPosts; // Lỗi post

  @override
  void initState() {
    super.initState();
    _fetchStories();
    _fetchPosts();
  }

  // Gọi API để lấy stories
  Future<void> _fetchStories() async {
    try {
      final stories = await CallingAPI.fetchStories();
      setState(() {
        _stories = stories;
        _isLoadingStories = false;
      });
    } catch (e) {
      setState(() {
        _errorStories = 'Failed to load stories: $e';
        _isLoadingStories = false;
      });
    }
  }

  // Gọi API để lấy posts
  Future<void> _fetchPosts() async {
    try {
      final posts = await CallingAPI.fetchPosts();
      setState(() {
        _posts = posts;
        _isLoadingPosts = false;
      });
    } catch (e) {
      setState(() {
        _errorPosts = 'Failed to load posts: $e';
        _isLoadingPosts = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _appBar(theme),
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchStories();
          await _fetchPosts();
        },
        child: ResponsivePadding(
          child: ListView(
            children: [
              // Story Section
              SizedBox(
                height: 110,
                child: _isLoadingStories
                    ? const Center(child: CircularProgressIndicator()) // Loading
                    : _errorStories != null
                    ? Center(child: Text(_errorStories!)) // Lỗi
                    : _stories.isEmpty
                    ? const Center(child: Text('No stories available'))
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _stories.length,
                  itemBuilder: (_, index) {
                    final Story story = _stories[index];
                    return GestureDetector(
                      onTap: () => _openStoryView(context, index),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: story.imageStory.isNotEmpty
                                ? NetworkImage(story.imageStory)
                                : const AssetImage('assets/img/post.jpg') as ImageProvider,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            story.fullName ?? 'Vô danh',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Post Section
              _isLoadingPosts
                  ? const Center(child: CircularProgressIndicator())
                  : _errorPosts != null
                  ? Center(child: Text(_errorPosts!))
                  : _posts.isEmpty
                  ? const Center(child: Text('No posts available'))
                  : ListView.separated(
                itemCount: _posts.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (_, index) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 4),
                ),
                itemBuilder: (_, index) => PostCard(post: _posts[index]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar(ThemeData theme) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Feed',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.send_sharp, color: theme.colorScheme.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openStoryView(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryPageView(
          itemBuilder: (context, pageIndex, storyIndex) {
            final story = _stories[pageIndex];
            return Stack(
              children: [
                Container(
                  color: Colors.black,
                  child: Center(
                    child: Image.network(
                      story.imageStory,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/img/post.jpg', fit: BoxFit.cover);
                      },
                    ),
                  ),
                ),
                // Hiển thị username ở góc trái trên
                Positioned(
                  top: 16,
                  left: 16,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: story.imageStory.isNotEmpty
                            ? NetworkImage(story.imageStory)
                            : const AssetImage('assets/img/post.jpg') as ImageProvider,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        story.fullName ?? 'Vô danh',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          storyLength: (pageIndex) => 1, // Mỗi người dùng có 1 story
          pageLength: _stories.length,
          onPageLimitReached: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}





