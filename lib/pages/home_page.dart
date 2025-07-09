import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:quick_social/common/common.dart';
import 'package:quick_social/config/AppConfig.dart';
import 'package:quick_social/pages/createnewpost.dart';
import 'package:quick_social/pages/createstory.dart';
import 'package:quick_social/pages/pages.dart';
import 'package:quick_social/pages/search.dart';
import 'package:quick_social/wigetforuser/nontificationui.dart';
import 'package:quick_social/wigetforuser/profile.dart';
import '../api/callingapi.dart';

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
  StreamSubscription<SSEModel>? _sseSubscription;
  bool _hasNotification = false;
  bool _hasNewStory = false;
  bool _hasNewLike = false;
  bool _hasNewComment = false;
  bool _hasNewShare = false;
  Map<String, dynamic>? _lastShareInfo;

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
    try {
      _sseSubscription = SSEClient.subscribeToSSE(
        method: SSERequestType.GET,
        url: AppConfig.sseUrl,
        header: AppConfig.sseHeaders,
      ).listen(
            (SSEModel event) {
          if (event.data != null) {
            final Map<String, dynamic> data = jsonDecode(event.data!);
            final String eventType = data['event'] ?? '';

            if (!mounted) return;

            setState(() {
              switch (eventType) {
                case 'new_story':
                  _hasNewStory = true;
                  break;
                case 'new_like':
                  _hasNewLike = true;
                  break;
                case 'new_comment':
                  _hasNewComment = true;
                  break;
                case 'new_share':
                  _hasNewShare = true;
                  _lastShareInfo = data;
                  _showShareNotification(_lastShareInfo!);
                  break;
                default:
                  _hasNotification = true;
              }
            });
          }
        },
        onError: (error) {
          print('❌ SSE error: $error');
        },
      );
    } catch (e) {
      print('SSE Exception: $e');
    }
  }


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
            _pageController.jumpToPage(1);
          },
        ),
      ),
    );
  }

  void _resetNotifications() {
    setState(() {
      _hasNotification = false;
      _hasNewStory = false;
      _hasNewLike = false;
      _hasNewComment = false;
      _hasNewShare = false;
      _lastShareInfo = null;
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
        _navDestination(Icons.post_add_outlined, Icons.post_add, 'Create Post', theme),
        _navDestination(Icons.camera_alt_outlined, Icons.camera_alt, 'Create Story', theme),
        _navDestination(Icons.search, Icons.search, 'Search', theme)
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
