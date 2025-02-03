import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:quick_social/pages/createnewpost.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:quick_social/pages/createstory.dart';
import 'package:quick_social/pages/pages.dart';
import 'package:quick_social/pages/search.dart';
import 'package:quick_social/wigetforuser/nontificationui.dart';
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

  // Trạng thái thông báo
  bool _hasNotification = false;
  bool _hasNewComment = false;

  // Thông tin chi tiết về thông báo bình luận mới nhất
  Map<String, dynamic>? _lastCommentInfo;

  // API SSE Endpoint
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

  // Thiết lập SSE để lắng nghe sự kiện mới từ server
  void _initializeSSEListeners() {
    SSEClient.subscribeToSSE(
      url: _baseUrl,
      method: SSERequestType.GET,
      headers: _headers,
    ).listen((event) {
      if (event.data != null && event.data!.isNotEmpty) {
        Map<String, dynamic> data = jsonDecode(event.data!);
        _handleSSEEvent(data);
      }
    }, onError: (error) {
      debugPrint("❌ SSE Error: $error");
    });
  }

  // Xử lý dữ liệu nhận được từ SSE
  void _handleSSEEvent(Map<String, dynamic> data) {
    if (!mounted) return;

    String eventType = data['eventType'] ?? '';

    switch (eventType) {
      case 'new_comment':
        _handleNewCommentNotification(data);
        break;
      default:
        debugPrint("ℹ️ Event không xác định: $eventType");
    }
  }

  // Xử lý thông báo bình luận mới
  void _handleNewCommentNotification(Map<String, dynamic> commentData) {
    setState(() {
      _hasNotification = true;
      _hasNewComment = true;
      _lastCommentInfo = commentData;
    });

    _showCommentNotification(commentData);
  }

  // Hiển thị thông báo popup khi có bình luận mới
  void _showCommentNotification(Map<String, dynamic> commentData) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${commentData['commenterName'] ?? 'Someone'} commented: "${commentData['commentText'] ?? ''}"',
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            _pageController.jumpToPage(1);
          },
        ),
      ),
    );
  }

  void _resetNotifications() {
    setState(() {
      _hasNotification = false;
      _hasNewComment = false;
      _lastCommentInfo = null;
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
        NotificationScreenUI(),
        const ProfileScreen(),
        Createnewpost(),
        Createstory(),
        UserSearchScreen()
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
        _railDestination(Icons.post_add_outlined, Icons.post_add, 'Create Post'),
        _railDestination(Icons.camera_alt_outlined, Icons.camera_alt, 'Create Story'),
        _railDestination(Icons.search, Icons.search, 'Search')
      ],
    );
  }

  NavigationRailDestination _notificationRailDestination() {
    return NavigationRailDestination(
      icon: _notificationIcon(Icons.notifications_outlined),
      selectedIcon: _notificationIcon(Icons.notifications, isSelected: true),
      label: const Text('Notifications'),
    );
  }

  Widget _notificationIcon(IconData icon, {bool isSelected = false}) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Icon(icon, color: isSelected ? theme.colorScheme.primary : null),
        if (_hasNotification)
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
