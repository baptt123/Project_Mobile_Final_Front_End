
import 'package:flutter/material.dart';
import 'package:quick_social/api/callingapi.dart';
import 'package:quick_social/models/story.dart';
import 'package:quick_social/pages/search.dart';
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
                onPressed: () {
                  // Chuyển hướng sang trang tìm kiếm
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserSearchScreen()),
                  );
                },
                icon: Icon(Icons.search, color: theme.colorScheme.primary),
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





