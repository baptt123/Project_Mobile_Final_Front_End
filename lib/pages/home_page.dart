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
  const HomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;
  late PageController _pageController;
  bool _hasNotification = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startListeningForNotifications() {
    SSEClient.subscribeToSSE(
      method: SSERequestType.GET,
    ).listen((event) {
      if (event.data != null) {
        setState(() {
    });
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
          ],
        ),
      ),
      bottomNavigationBar: context.isMobile ? _navigationBar() : null,
    );
  }

  void _pageChanged(int value) {
    setState(() {
      _pageIndex = value;
    });

    if (_pageController.hasClients) {
      _pageController.jumpToPage(value);
    }
  }

  Widget _buildPageView() {
    return PageView(
      controller: _pageController,
      onPageChanged: _pageChanged,
      children: [
        const FeedPage(),
        const NotificationsPage(),
        const ProfileApp(),
        Createnewpost(),
        Createstory(),
      ],
    );
  }

  NavigationRail _navigationRail() {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return NavigationRail(
      selectedIndex: _pageIndex,
      onDestinationSelected: _pageChanged,
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
      ],
    );
  }

  NavigationBar _navigationBar() {
    final theme = Theme.of(context);
    return NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      selectedIndex: _pageIndex,
      height: 65,
      onDestinationSelected: _pageChanged,
      destinations: [
        _navDestination(Icons.home_outlined, Icons.home, 'Home', theme),
        _notificationNavDestination(theme),
        _navDestination(Icons.person_outlined, Icons.person, 'Profile', theme),
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



        import 'package:flutter/cupertino.dart';
        import 'package:flutter/material.dart';
        import 'dart:convert';
        import 'package:quick_social/pages/createnewpost.dart';
        import 'package:flutter_client_sse/flutter_client_sse.dart';
        import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
        import 'package:quick_social/pages/createstory.dart';
        import 'package:quick_social/pages/pages.dart';
        import 'package:quick_social/wigetforuser/profile.dart';
        import 'package:quick_social/common/common.dart';

        class HomePage extends StatefulWidget {
        const HomePage({super.key});

        static Route<void> route() {
        return MaterialPageRoute<void>(builder: (_) => const HomePage());
        }

        @override
        State<HomePage> createState() => _HomePageState();
        }

        class _HomePageState extends State<HomePage> {
        int _pageIndex = 0;
        late PageController _pageController;

        // Notification states
        bool _hasNotification = false;
        bool _hasNewStory = false;
        bool _hasNewLike = false;
        bool _hasNewComment = false;
        bool _hasNewShare = false; // Thêm trạng thái cho thông báo chia sẻ

        // Thông tin chi tiết về thông báo chia sẻ mới nhất
        Map<String, dynamic>? _lastShareInfo;

        // API endpoint configuration
        static const String _baseUrl = 'http://192.168.5.248:8080/api/uploadfile/sse';
        static const Map<String, String> _headers = {
        "Accept": "text/event-stream",
        "Cache-Control": "no-cache",
        };

        @override
        void initState() {
        super.initState();
        _pageController = PageController(initialPage: _pageIndex);
        _initializeSSEListeners();
        }

        @override
        void dispose() {
        _pageController.dispose();
        super.dispose();
        }

        void _initializeSSEListeners() {
        _startListeningForNotifications();
        _startListeningForStoryUploads();
        _startListeningForLikes();
        _startListeningForComments();
        _startListeningForShares(); // Thêm lắng nghe sự kiện chia sẻ
        }

        void _startListeningForNotifications() {
        _subscribeToSSE('upload', (data) {
        setState(() => _hasNotification = true);
        });
        }

        void _startListeningForStoryUploads() {
        _subscribeToSSE('story', (data) {
        setState(() => _hasNewStory = true);
        });
        }

        void _startListeningForLikes() {
        _subscribeToSSE('like', (data) {
        setState(() {
        _hasNewLike = true;
        if (data != null) {
        final likeData = json.decode(data);
        // Xử lý dữ liệu like ở đây nếu cần
        }
        });
        });
        }

        void _startListeningForComments() {
        _subscribeToSSE('comment', (data) {
        setState(() {
        _hasNewComment = true;
        if (data != null) {
        final commentData = json.decode(data);
        // Xử lý dữ liệu comment ở đây nếu cần
        }
        });
        });
        }

        // Thêm phương thức lắng nghe sự kiện chia sẻ
        void _startListeningForShares() {
        _subscribeToSSE('share', (data) {
        setState(() {
        _hasNewShare = true;
        if (data != null) {
        _lastShareInfo = json.decode(data);
        // Có thể hiển thị thông báo popup hoặc xử lý dữ liệu chia sẻ ở đây
        _showShareNotification(_lastShareInfo!);
        }
        });
        });
        }

        // Hiển thị thông báo popup khi có người chia sẻ bài viết
        void _showShareNotification(Map<String, dynamic> shareInfo) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Text(
        '${shareInfo['sharerName'] ?? 'Someone'} shared your post "${shareInfo['postTitle'] ?? ''}"'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
        label: 'View',
        onPressed: () {
        // Chuyển đến trang thông báo và hiển thị chi tiết
        _pageController.jumpToPage(1);
        },
        ),
        ),
        );
        }

        void _subscribeToSSE(String endpoint, Function(String?) onData) {
        SSEClient.subscribeToSSE(
        method: SSERequestType.GET,
        url: '$_baseUrl/$endpoint',
        header: _headers,
        ).listen((event) {
        if (event.data != null) {
        onData(event.data);
        }
        }, onError: (error) {
        debugPrint('SSE Error for $endpoint: $error');
        });
        }

        void _resetNotifications() {
        setState(() {
        _hasNotification = false;
        _hasNewStory = false;
        _hasNewLike = false;
        _hasNewComment = false;
        _hasNewShare = false; // Reset trạng thái thông báo chia sẻ
        _lastShareInfo = null; // Reset thông tin chia sẻ
        });
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
        Expanded(child: _buildPageView()),
        ],
        ),
        ),
        bottomNavigationBar: context.isMobile ? _navigationBar() : null,
        );
        }

        void _pageChanged(int value) {
        setState(() {
        if (value == 1) _resetNotifications();
        _pageIndex = value;
        });

        if (_pageController.hasClients) {
        _pageController.jumpToPage(value);
        }
        }

        Widget _buildPageView() {
        return PageView(
        controller: _pageController,
        onPageChanged: _pageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: [
        const FeedPage(),
        const NotificationsPage(),
        const ProfileApp(),
        Createnewpost(),
        Createstory(),
        ],
        );
        }

        NavigationRail _navigationRail() {
        final theme = Theme.of(context);
        final textTheme = theme.textTheme;

        return NavigationRail(
        selectedIndex: _pageIndex,
        onDestinationSelected: _pageChanged,
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
        _railDestination(
        Icons.post_add_outlined, Icons.post_add, 'Create Post'),
        _railDestination(
        Icons.camera_alt_outlined, Icons.camera_alt, 'Create Story'),
        ],
        );
        }

        NavigationBar _navigationBar() {
        final theme = Theme.of(context);
        return NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: _pageIndex,
        height: 65,
        onDestinationSelected: _pageChanged,
        destinations: [
        _navDestination(Icons.home_outlined, Icons.home, 'Home', theme),
        _notificationNavDestination(theme),
        _navDestination(Icons.person_outlined, Icons.person, 'Profile', theme),
        _navDestination(
        Icons.post_add_outlined, Icons.post_add, 'Create Post', theme),
        _navDestination(
        Icons.camera_alt_outlined, Icons.camera_alt, 'Create Story', theme),
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
        final hasAnyNotification = _hasNotification ||
        _hasNewStory ||
        _hasNewLike ||
        _hasNewComment ||
        _hasNewShare;

        return Stack(
        children: [
        Icon(icon, color: isSelected ? theme.colorScheme.primary : null),
        if (hasAnyNotification)
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
