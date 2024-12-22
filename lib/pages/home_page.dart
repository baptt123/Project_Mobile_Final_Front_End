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
import 'package:flutter/material.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:quick_social/common/common.dart';
import 'package:quick_social/models/models.dart';
import 'package:quick_social/pages/pages.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:quick_social/wigetforuser/profile.dart'; // Thêm thư viện SSE

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
  late PageController _pageController = PageController();
  bool _hasNotification = false; // Biến cờ để hiển thị chấm đỏ

  @override
  void initState() {
    super.initState();
    _startListeningForNotifications(); // Lắng nghe sự kiện từ server
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Lắng nghe sự kiện SSE từ server
  void _startListeningForNotifications() {
    SSEClient.subscribeToSSE(
      method: SSERequestType.GET,
      url: 'http://192.168.5.248:8080/api/uploadfile/sse/upload', // URL của server SSE
      header: {
        "Accept": "text/event-stream",
        "Cache-Control": "no-cache",
      },
    ).listen((event) {
      if (event.data != null) {
        setState(() {
          _hasNotification = true; // Đánh dấu có thông báo mới
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageView = _buildPageView();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: context.responsive(
        sm: pageView,
        md: Row(
          children: [
            _navigationRail(context),
            const VerticalDivider(width: 1, thickness: 1),
            Flexible(child: pageView),
          ],
        ),
      ),
      bottomNavigationBar: context.isMobile ? _navigationBar(context) : null,
    );
  }

  void _pageChanged(int value) {
    setState(() {
      if (value == 1) {
        // Reset thông báo khi chuyển sang tab Notifications
        _hasNotification = false;
      }
      _pageIndex = value;
    });

    if (_pageController.hasClients) {
      _pageController.jumpToPage(value);
    }
  }

  Widget _buildPageView() {
    _pageController = PageController(initialPage: _pageIndex);

    return PageView(
      controller: _pageController,
      onPageChanged: _pageChanged,
      children: const [
        FeedPage(),
        NotificationsPage(),
        ProfileApp()
      ],
    );
  }

  /// tablet & desktop screen
  NavigationRail _navigationRail(BuildContext context) {
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
        NavigationRailDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: Icon(
            Icons.home,
            color: theme.colorScheme.primary,
          ),
          label: const Text('Home'),
        ),
        NavigationRailDestination(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined),
              if (_hasNotification)
                Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.red,
                  ),
                ),
            ],
          ),
          selectedIcon: Icon(
            Icons.notifications,
            color: theme.colorScheme.primary,
          ),
          label: const Text('Notifications'),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.person_outlined),
          selectedIcon: Icon(
            Icons.person,
            color: theme.colorScheme.primary,
          ),
          label: const Text('Profile'),
        ),
      ],
    );
  }

  /// mobile screen
  NavigationBar _navigationBar(BuildContext context) {
    final theme = Theme.of(context);
    return NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      selectedIndex: _pageIndex,
      height: 65,
      onDestinationSelected: _pageChanged,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: Icon(
            Icons.home,
            color: theme.colorScheme.primary,
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined),
              if (_hasNotification)
                Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.red,
                  ),
                ),
            ],
          ),
          selectedIcon: Icon(
            Icons.notifications,
            color: theme.colorScheme.primary,
          ),
          label: 'Notifications',
        ),
        NavigationDestination(
          icon: const Icon(Icons.person_outlined),
          selectedIcon: Icon(
            Icons.person,
            color: theme.colorScheme.primary,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}


