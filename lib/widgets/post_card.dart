// import 'package:flutter/material.dart';
// import 'package:quick_social/common/common.dart';
// import 'package:quick_social/models/models.dart';
// import 'package:quick_social/pages/pages.dart';
// import 'package:quick_social/widgets/widgets.dart';
//
// class PostCard extends StatelessWidget {
//   const PostCard({
//     super.key,
//     required this.post,
//   });
//
//   final Post post;
//
//   @override
//   Widget build(BuildContext context) {
//     final mobileCard = _mobileCard(context);
//     final tabletCard = _tabletCard(context);
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: context.responsive<Widget>(
//         sm: mobileCard,
//         md: tabletCard,
//       ),
//     );
//   }
//
//   Widget _mobileCard(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         ListTile(
//           onTap: () => context.push(route: ProfilePage.route(post.owner)),
//           leading: CircleAvatar(
//             backgroundImage: NetworkImage(post.owner.profileImage),
//           ),
//           title: Text(
//             post.owner.username,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           subtitle: Text(
//             post.location,
//             style: textTheme.bodySmall,
//           ),
//           trailing: IconButton(
//             onPressed: () {},
//             icon: const Icon(Icons.more_vert),
//           ),
//         ),
//         SizedBox(
//           width: double.infinity,
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//             child: Text(post.caption),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//           child: _postImage(),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: _postButtons(),
//         ),
//       ],
//     );
//   }
//
//   Widget _tabletCard(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: IntrinsicHeight(
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: _postImage(),
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         ListTile(
//                           onTap: () {
//                             context.push(route: ProfilePage.route(post.owner));
//                           },
//                           contentPadding: EdgeInsets.zero,
//                           leading: CircleAvatar(
//                             backgroundImage:
//                                 NetworkImage(post.owner.profileImage),
//                           ),
//                           title: Text(
//                             post.owner.username,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           subtitle: Text(
//                             post.location,
//                             style: textTheme.bodySmall?.copyWith(
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 16),
//                           child: Text(post.caption),
//                         ),
//                       ],
//                     ),
//                     _postButtons(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _postImage() {
//     return Image.network(
//       post.postImage,
//       fit: BoxFit.fitWidth,
//       loadingBuilder: (ctx, child, progress) {
//         if (progress == null) return child;
//         return const AspectRatio(
//           aspectRatio: 16 / 9,
//           child: LoadingImageWidget(),
//         );
//       },
//       errorBuilder: (ctx, _, __) {
//         return const AspectRatio(
//           aspectRatio: 16 / 9,
//           child: ErrorImageWidget(),
//         );
//       },
//     );
//   }
//
//   Widget _postButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Expanded(
//           child: _ToggleButton(
//             isActive: post.isLiked,
//             count: post.likeCount,
//             iconData: Icons.favorite_outline,
//             activeIconData: Icons.favorite,
//           ),
//         ),
//         Expanded(
//           child: _CommentButton(post: post),
//         ),
//         Expanded(
//           child: _ToggleButton(
//             isActive: post.isSaved,
//             count: post.saveCount,
//             iconData: Icons.bookmark_add_outlined,
//             activeIconData: Icons.bookmark_added,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _CommentButton extends StatefulWidget {
//   const _CommentButton({required this.post});
//
//   final Post post;
//
//   @override
//   State<_CommentButton> createState() => _CommentButtonState();
// }
//
// class _CommentButtonState extends State<_CommentButton> {
//   late int _commentCount;
//
//   @override
//   void initState() {
//     super.initState();
//     _commentCount = widget.post.comments.length;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PostButton(
//       icon: const Icon(Icons.chat_bubble_outline),
//       text: _commentCount.toString(),
//       onTap: () => CommentsBottomSheet.showCommentsBottomSheet(
//         context,
//         post: widget.post,
//       ).then((_) {
//         // update comment count
//         setState(() => _commentCount = widget.post.comments.length);
//       }),
//     );
//   }
// }
//
// /// Like and Save button
// class _ToggleButton extends StatefulWidget {
//   const _ToggleButton({
//     this.count = 122,
//     required this.iconData,
//     required this.activeIconData,
//     required this.isActive,
//   });
//
//   final IconData iconData;
//   final IconData activeIconData;
//   final int count;
//   final bool isActive;
//
//   @override
//   State<_ToggleButton> createState() => _ToggleButtonState();
// }
//
// class _ToggleButtonState extends State<_ToggleButton>
//     with AutomaticKeepAliveClientMixin {
//   late bool _isActive;
//   late int _count;
//
//   @override
//   void initState() {
//     super.initState();
//     _count = widget.count;
//     _isActive = widget.isActive;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     final theme = Theme.of(context);
//
//     return PostButton(
//       icon: Icon(
//         _isActive ? widget.activeIconData : widget.iconData,
//         color: _isActive ? theme.colorScheme.primary : null,
//       ),
//       text: _count.toString(),
//       onTap: () {
//         setState(() {
//           _isActive = !_isActive;
//           _isActive ? _count++ : _count--;
//         });
//       },
//     );
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }
import 'package:flutter/material.dart';
import 'package:quick_social/common/build_context_extension.dart';
import 'package:quick_social/widgets/loading_image_widget.dart';
import 'package:quick_social/widgets/error_image_widget.dart';

import '../models/post.dart';
import 'comments_bottom_sheet.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    });

    final Post post;

    @override
    Widget build(BuildContext context) {
    final mobileCard = _mobileCard(context);
    final tabletCard = _tabletCard(context);

    return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: context.responsive<Widget>(
    sm: mobileCard,
    md: tabletCard,
    ),
    );
    }

    Widget _mobileCard(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
    ListTile(
    // onTap: () => context.push(route: ProfilePage.route(post.user)),
    leading: CircleAvatar(
    backgroundImage: NetworkImage(post.user.profileImagePath),
    ),
    title: Text(
    post.user.userName,
    style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    subtitle: Text(
    'Location here',
    // Nếu có trường location trong model, có thể thêm vào đây
    style: textTheme.bodySmall,
    ),
    trailing: IconButton(
    onPressed: () {},
    icon: const Icon(Icons.more_vert),
    ),
    ),
    SizedBox(
    width: double.infinity,
    child: Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
    child: Text(post.caption),
    ),
    ),
    Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    child: _postImage(),
    ),
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: _postButtons(context),
    ),
    ],
    );
    }

    Widget _tabletCard(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: IntrinsicHeight(
    child: Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Expanded(
    child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: _postImage(),
    ),
    ),
    Expanded(
    child: Padding(
    padding: const EdgeInsets.only(left: 16),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
    ListTile(
    onTap: () {
    // context.push(route: ProfilePage.route(post.user));
    },
    contentPadding: EdgeInsets.zero,
    leading: CircleAvatar(
    backgroundImage:
    NetworkImage(post.user.profileImagePath),
    ),
    title: Text(
    post.user.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          subtitle: Text(
                            'Location here',
                            style: textTheme.bodySmall?.copyWith(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(post.caption),
                        ),
                      ],
                    ),
                    _postButtons(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _postImage() {
    return Image.network(
      post.media,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        return const Center(child: Icon(Icons.broken_image, size: 48));
      },
    );
  }

  Widget _postButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(
            post.isLiked == 1 ? Icons.favorite : Icons.favorite_border,
            color: post.isLiked == 1 ? Colors.red : null,
          ),
          onPressed: () {
            print("Liked post: ${post.id}");
          },
          tooltip: "Like",
        ),
        IconButton(
          icon: const Icon(Icons.comment_outlined),
          onPressed: () {
            CommentsBottomSheet.showCommentsBottomSheet(context, post: post);
          },
          tooltip: "Comment",
        ),
      ],
    );
  }
}