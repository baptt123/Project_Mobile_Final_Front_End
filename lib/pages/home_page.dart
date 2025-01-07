// import 'package:flutter/material.dart';
// import 'package:quick_social/common/common.dart';
// import 'package:quick_social/models/models.dart';
// import 'package:quick_social/pages/pages.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   static Route<void> route() {
//     return MaterialPageRoute<void>(builder: (_) => const HomePage());
//   }
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int _pageIndex = 0;
//   late PageController _pageController = PageController();
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final pageView = _buildPageView();
//
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: context.responsive(
//         sm: pageView,
//         md: Row(
//           children: [
//             _navigationRail(context),
//             const VerticalDivider(width: 1, thickness: 1),
//             Flexible(child: pageView),
//           ],
//         ),
//       ),
//       bottomNavigationBar: context.isMobile ? _navigationBar(context) : null,
//     );
//   }
//
//   void _pageChanged(int value) {
//     if (_pageIndex == value && _pageController.hasClients) return;
//     setState(() => _pageIndex = value);
//     _pageController.jumpToPage(value);
//   }
//
//   Widget _buildPageView() {
//     _pageController = PageController(initialPage: _pageIndex);
//
//     return PageView(
//       controller: _pageController,
//       onPageChanged: _pageChanged,
//       children: [
//         const FeedPage(),
//         const NotificationsPage(),
//         ProfilePage(user: User.dummyUsers[0]),
//       ],
//     );
//   }
//
//   /// tablet & desktop screen
//   NavigationRail _navigationRail(BuildContext context) {
//     final theme = Theme.of(context);
//     final textTheme = theme.textTheme;
//     return NavigationRail(
//       selectedIndex: _pageIndex,
//       onDestinationSelected: _pageChanged,
//       extended: context.isDesktop,
//       labelType: context.isDesktop
//           ? NavigationRailLabelType.none
//           : NavigationRailLabelType.all,
//       selectedLabelTextStyle: textTheme.bodyMedium?.copyWith(
//         color: theme.colorScheme.primary,
//         fontWeight: FontWeight.bold,
//       ),
//       unselectedLabelTextStyle: textTheme.bodyMedium,
//       destinations: [
//         NavigationRailDestination(
//           icon: const Icon(Icons.home_outlined),
//           selectedIcon: Icon(
//             Icons.home,
//             color: theme.colorScheme.primary,
//           ),
//           label: const Text('Home'),
//         ),
//         NavigationRailDestination(
//           icon: const Icon(Icons.notifications_outlined),
//           selectedIcon: Icon(
//             Icons.notifications,
//             color: theme.colorScheme.primary,
//           ),
//           label: const Text('Notifications'),
//         ),
//         NavigationRailDestination(
//           icon: const Icon(Icons.person_outlined),
//           selectedIcon: Icon(
//             Icons.person,
//             color: theme.colorScheme.primary,
//           ),
//           label: const Text('Profile'),
//         ),
//       ],
//     );
//   }
//
//   /// mobile screen
//   NavigationBar _navigationBar(BuildContext context) {
//     final theme = Theme.of(context);
//     return NavigationBar(
//       labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
//       selectedIndex: _pageIndex,
//       height: 65,
//       onDestinationSelected: _pageChanged,
//       destinations: [
//         NavigationDestination(
//           icon: const Icon(Icons.home_outlined),
//           selectedIcon: Icon(
//             Icons.home,
//             color: theme.colorScheme.primary,
//           ),
//           label: 'Home',
//         ),
//         NavigationDestination(
//           icon: const Icon(Icons.notifications_outlined),
//           selectedIcon: Icon(
//             Icons.notifications,
//             color: theme.colorScheme.primary,
//           ),
//           label: 'Notifications',
//         ),
//         NavigationDestination(
//           icon: const Icon(Icons.person_outlined),
//           selectedIcon: Icon(
//             Icons.person,
//             color: theme.colorScheme.primary,
//           ),
//           label: 'Profile',
//         ),
//       ],
//     );
//   }
// }
//
//


// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:quick_social/pages/createnewpost.dart';
// import 'package:flutter_client_sse/flutter_client_sse.dart';
// import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
// import 'package:quick_social/pages/createstory.dart';
// import 'package:quick_social/pages/pages.dart';
// import 'package:quick_social/wigetforuser/profile.dart';
// import 'package:quick_social/common/common.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   static Route<void> route() {
//     return MaterialPageRoute<void>(builder: (_) => const HomePage());
//   }
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int _pageIndex = 0;
//   late PageController _pageController;
//   bool _hasNotification = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(initialPage: _pageIndex);
//     _startListeningForNotifications();
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   void _startListeningForNotifications() {
//     SSEClient.subscribeToSSE(
//       method: SSERequestType.GET,
//       url: 'http://192.168.5.248:8080/api/uploadfile/sse/upload',
//       header: {
//         "Accept": "text/event-stream",
//         "Cache-Control": "no-cache",
//       },
//     ).listen((event) {
//       if (event.data != null) {
//         setState(() {
//           _hasNotification = true;
//         });
//       }
//     });
//   }
// // 1. Listen for story uploads
//   void _startListeningForStoryUploads() {
//     SSEClient.subscribeToSSE(
//       method: SSERequestType.GET,
//       url: 'http://192.168.5.248:8080/api/uploadfile/sse/story',
//       header: {
//         "Accept": "text/event-stream",
//         "Cache-Control": "no-cache",
//       },
//     ).listen((event) {
//       if (event.data != null) {
//         setState(() {
//           _hasNewStory = true;
//         });
//       }
//     });
//   }
//
// // 2. Listen for likes
//   void _startListeningForLikes() {
//     SSEClient.subscribeToSSE(
//       method: SSERequestType.GET,
//       url: 'http://192.168.5.248:8080/api/uploadfile/sse/like',
//       header: {
//         "Accept": "text/event-stream",
//         "Cache-Control": "no-cache",
//       },
//     ).listen((event) {
//       if (event.data != null) {
//         setState(() {
//           _hasNewLike = true;
//           // You can also parse the event data to get specific like information
//           // final likeData = json.decode(event.data!);
//           // _lastLikeInfo = likeData;
//         });
//       }
//     });
//   }
//
// // 3. Listen for comments
//   void _startListeningForComments() {
//     SSEClient.subscribeToSSE(
//       method: SSERequestType.GET,
//       url: 'http://192.168.5.248:8080/api/uploadfile/sse/comment',
//       header: {
//         "Accept": "text/event-stream",
//         "Cache-Control": "no-cache",
//       },
//     ).listen((event) {
//       if (event.data != null) {
//         setState(() {
//           _hasNewComment = true;
//           // You can also parse the event data to get comment details
//           // final commentData = json.decode(event.data!);
//           // _lastCommentInfo = commentData;
//         });
//       }
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: context.responsive(
//         sm: _buildPageView(),
//         md: Row(
//           children: [
//             _navigationRail(),
//             const VerticalDivider(width: 1, thickness: 1),
//             Flexible(child: _buildPageView()),
//           ],
//         ),
//       ),
//       bottomNavigationBar: context.isMobile ? _navigationBar() : null,
//     );
//   }
//
//   void _pageChanged(int value) {
//     setState(() {
//       if (value == 1) _hasNotification = false;
//       _pageIndex = value;
//     });
//
//     if (_pageController.hasClients) {
//       _pageController.jumpToPage(value);
//     }
//   }
//
//   Widget _buildPageView() {
//     return PageView(
//       controller: _pageController,
//       onPageChanged: _pageChanged,
//       children: [
//         const FeedPage(),
//         const NotificationsPage(),
//         const ProfileApp(),
//         Createnewpost(),
//         Createstory(),
//       ],
//     );
//   }
//
//   NavigationRail _navigationRail() {
//     final theme = Theme.of(context);
//     final textTheme = theme.textTheme;
//
//     return NavigationRail(
//       selectedIndex: _pageIndex,
//       onDestinationSelected: _pageChanged,
//       extended: context.isDesktop,
//       labelType: context.isDesktop
//           ? NavigationRailLabelType.none
//           : NavigationRailLabelType.all,
//       selectedLabelTextStyle: textTheme.bodyMedium?.copyWith(
//         color: theme.colorScheme.primary,
//         fontWeight: FontWeight.bold,
//       ),
//       unselectedLabelTextStyle: textTheme.bodyMedium,
//       destinations: [
//         _railDestination(Icons.home_outlined, Icons.home, 'Home'),
//         _notificationRailDestination(),
//         _railDestination(Icons.person_outlined, Icons.person, 'Profile'),
//         _railDestination(Icons.post_add_outlined, Icons.post_add, 'Create Post'),
//         _railDestination(Icons.camera_alt_outlined, Icons.camera_alt, 'Create Story'),
//       ],
//     );
//   }
//
//   NavigationBar _navigationBar() {
//     final theme = Theme.of(context);
//     return NavigationBar(
//       labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
//       selectedIndex: _pageIndex,
//       height: 65,
//       onDestinationSelected: _pageChanged,
//       destinations: [
//         _navDestination(Icons.home_outlined, Icons.home, 'Home', theme),
//         _notificationNavDestination(theme),
//         _navDestination(Icons.person_outlined, Icons.person, 'Profile', theme),
//         _navDestination(Icons.post_add_outlined, Icons.post_add, 'Create Post', theme),
//         _navDestination(Icons.camera_alt_outlined, Icons.camera_alt, 'Create Story', theme),
//       ],
//     );
//   }
//
//   NavigationRailDestination _railDestination(
//       IconData icon, IconData selectedIcon, String label) {
//     final theme = Theme.of(context);
//     return NavigationRailDestination(
//       icon: Icon(icon),
//       selectedIcon: Icon(selectedIcon, color: theme.colorScheme.primary),
//       label: Text(label),
//     );
//   }
//
//   NavigationDestination _navDestination(
//       IconData icon, IconData selectedIcon, String label, ThemeData theme) {
//     return NavigationDestination(
//       icon: Icon(icon),
//       selectedIcon: Icon(selectedIcon, color: theme.colorScheme.primary),
//       label: label,
//     );
//   }
//
//   NavigationRailDestination _notificationRailDestination() {
//     return NavigationRailDestination(
//       icon: _notificationIcon(Icons.notifications_outlined),
//       selectedIcon: _notificationIcon(Icons.notifications, isSelected: true),
//       label: const Text('Notifications'),
//     );
//   }
//
//   NavigationDestination _notificationNavDestination(ThemeData theme) {
//     return NavigationDestination(
//       icon: _notificationIcon(Icons.notifications_outlined),
//       selectedIcon: _notificationIcon(Icons.notifications, isSelected: true),
//       label: 'Notifications',
//     );
//   }
//
//   Widget _notificationIcon(IconData icon, {bool isSelected = false}) {
//     final theme = Theme.of(context);
//     return Stack(
//       children: [
//         Icon(icon, color: isSelected ? theme.colorScheme.primary : null),
//         if (_hasNotification)
//           const Positioned(
//             right: 0,
//             top: 0,
//             child: CircleAvatar(
//               radius: 5,
//               backgroundColor: Colors.red,
//             ),
//           ),
//       ],
//     );
//   }
// }


/*
chinh sua them cho phan nhan su kien
 */

import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_social/pages/createnewpost.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:quick_social/pages/createstory.dart';
import 'package:quick_social/pages/pages.dart';
import 'package:quick_social/wigetforuser/profile.dart';
import 'package:quick_social/common/common.dart';

class HomePage extends StatefulWidget {
  final String? username;
  const HomePage({super.key, this.username});

  static Route<void> route({String? username}) {
    return MaterialPageRoute<void>(
        builder: (_) => HomePage(username: username)
    );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;
  late PageController _pageController;
  bool _hasNotification = false;
  bool _hasNewStory = false;
  bool _hasNewLike = false;
  bool _hasNewComment = false;
  bool _hasNewShare = false;
  bool _hasNewFollow = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
    _startListeningForSSE();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startListeningForSSE() {
    final sseEndpoints = [
      {
        'url': 'http://192.168.5.248:8080/api/uploadfile/sse/upload',
        'callback': () => _updateState(() => _hasNotification = true),
      },
      {
        'url': 'http://192.168.5.248:8080/api/uploadfile/sse/story',
        'callback': () => _updateState(() => _hasNewStory = true),
      },
      {
        'url': 'http://192.168.5.248:8080/api/uploadfile/sse/like',
        'callback': () => _updateState(() => _hasNewLike = true),
      },
      {
        'url': 'http://192.168.5.248:8080/api/uploadfile/sse/comment',
        'callback': () => _updateState(() => _hasNewComment = true),
      },
      {
        'url': 'http://192.168.5.248:8080/api/uploadfile/sse/share',
        'callback': () => _updateState(() => _hasNewShare = true),
      },
      {
        'url': 'http://192.168.5.248:8080/api/uploadfile/sse/follow',
        'callback': () => _updateState(() => _hasNewFollow = true),
      },
    ];

    for (var endpoint in sseEndpoints) {
      final url = endpoint['url'] as String?;

      if (url != null && url.isNotEmpty) {
        SSEClient.subscribeToSSE(
          method: SSERequestType.GET,
          url: url,
          header: {
            "Accept": "text/event-stream",
            "Cache-Control": "no-cache",
          },
        ).listen((event) {
          if (event.data != null) {
            endpoint['callback']?.call();
          }
        }, onError: (error) {
          debugPrint("Error on SSE for endpoint $url: $error");
        });
      } else {
        debugPrint("Error: Invalid URL for one of the endpoints");
      }
    }
  }

  void _updateState(VoidCallback callback) {
    if (mounted) {
      setState(callback);
    }
  }

  void _navigateToStory(int index) {
    if (index == 4) { // Index for Create Story
      if (widget.username != null && widget.username!.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Createstory(username: widget.username),
          ),
        );
      } else {
        // Handle case when username is null or empty
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username not available. Please login first.'),
          ),
        );
      }
    } else {
      _pageChanged(index);
    }
  }

  void _pageChanged(int value) {
    _updateState(() {
      if (value == 1) _hasNotification = false;
      _pageIndex = value;
    });

    if (_pageController.hasClients) {
      _pageController.jumpToPage(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: context.responsive(
        sm: _buildPageView(),
        md: Row(
          children: [
            _navigationRail(),
            const VerticalDivider(width: 1, thickness: 1),
            Flexible(child: _buildPageView()),
          ],
        ),
      ),
      bottomNavigationBar: context.isMobile ? _navigationBar() : null,
    );
  }

  Widget _buildPageView() {
    return PageView(
      controller: _pageController,
      onPageChanged: _pageChanged,
      physics: const NeverScrollableScrollPhysics(), // Disable swipe navigation
      children: [
        const FeedPage(),
        const NotificationsPage(),
        const ProfileApp(),
        Createnewpost(),
        Createstory(username: widget.username),
      ],
    );
  }

  NavigationRail _navigationRail() {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return NavigationRail(
      selectedIndex: _pageIndex,
      onDestinationSelected: _navigateToStory,
      extended: context.isDesktop,
      labelType: context.isDesktop
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.all,
      selectedLabelTextStyle: textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelTextStyle: textTheme.bodyMedium,
      destinations: [
        _railDestination(Icons.home_outlined, Icons.home, 'Home'),
        _notificationRailDestination(),
        _railDestination(Icons.person_outlined, Icons.person, 'Profile'),
        _railDestination(Icons.post_add_outlined, Icons.post_add, 'Create Post'),
        _railDestination(Icons.camera_alt_outlined, Icons.camera_alt, 'Create Story'),
      ],
    );
  }

  NavigationBar _navigationBar() {
    final theme = Theme.of(context);
    return NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      selectedIndex: _pageIndex,
      height: 65,
      onDestinationSelected: _navigateToStory,
      destinations: [
        _navDestination(Icons.home_outlined, Icons.home, 'Home', theme),
        _notificationNavDestination(theme),
        _navDestination(Icons.person_outlined, Icons.person, 'Profile', theme),
        _navDestination(Icons.post_add_outlined, Icons.post_add, 'Create Post', theme),
        _navDestination(Icons.camera_alt_outlined, Icons.camera_alt, 'Create Story', theme),
      ],
    );
  }

  NavigationRailDestination _railDestination(
      IconData icon, IconData selectedIcon, String label) {
    final theme = Theme.of(context);
    return NavigationRailDestination(
      icon: Icon(icon),
      selectedIcon: Icon(selectedIcon, color: theme.colorScheme.primary),
      label: Text(label),
    );
  }

  NavigationDestination _navDestination(
      IconData icon, IconData selectedIcon, String label, ThemeData theme) {
    return NavigationDestination(
      icon: Icon(icon),
      selectedIcon: Icon(selectedIcon, color: theme.colorScheme.primary),
      label: label,
    );
  }

  NavigationRailDestination _notificationRailDestination() {
    return NavigationRailDestination(
      icon: _notificationIcon(Icons.notifications_outlined),
      selectedIcon: _notificationIcon(Icons.notifications, isSelected: true),
      label: const Text('Notifications'),
    );
  }

  NavigationDestination _notificationNavDestination(ThemeData theme) {
    return NavigationDestination(
      icon: _notificationIcon(Icons.notifications_outlined),
      selectedIcon: _notificationIcon(Icons.notifications, isSelected: true),
      label: 'Notifications',
    );
  }

  Widget _notificationIcon(IconData icon, {bool isSelected = false}) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Icon(icon, color: isSelected ? theme.colorScheme.primary : null),
        if (_hasNotification || _hasNewStory || _hasNewLike || _hasNewComment || _hasNewShare || _hasNewFollow)
          const Positioned(
            right: 0,
            top: 0,
            child: CircleAvatar(
              radius: 5,
              backgroundColor: Colors.red,
            ),
          ),
      ],
    );
  }
}




