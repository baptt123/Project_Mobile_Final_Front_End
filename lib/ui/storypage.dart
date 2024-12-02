import 'package:app_chat/calling_api/CallingAPI.dart';
import 'package:flutter/material.dart';
import 'package:story/story_page_view.dart';
import 'package:app_chat/model/story.dart';
class StoryPage extends StatefulWidget   {
  const StoryPage({Key? key}) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late Future<List<Story>> futureStories;

  @override
  void initState() {
    super.initState();
    futureStories = CallingAPI.fetchStories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stories'),
      ),
      body: FutureBuilder<List<Story>>(
        future: futureStories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final stories = snapshot.data!;
            return StoryPageView(
              itemBuilder: (context, pageIndex, storyIndex) {
                final story = stories[storyIndex];
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        story.imageStory,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              },
              pageLength: 1, // Số trang (nếu nhóm theo user thì thay đổi)
              storyLength: (_) => stories.length,
              onPageLimitReached: () {
                Navigator.pop(context);
              },
            );
          } else {
            return const Center(child: Text('No stories available'));
          }
        },
      ),
    );
  }
}
