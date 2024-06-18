import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/common/widgets/more_modalbottomsheet.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Thread extends StatelessWidget {
  final String name;
  final String avatar;
  final bool isMe;
  final DateTime createdAt;
  final String content;
  final List<String> images;
  final List<dynamic> comments;
  final int likes;

  const Thread({
    super.key,
    required this.name,
    required this.avatar,
    required this.isMe,
    required this.createdAt,
    required this.content,
    required this.images,
    required this.comments,
    required this.likes,
  });

  void _onMoreTap(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      elevation: 0,
      context: context,
      builder: (context) => const MoreModalbottomsheet(),
      backgroundColor: Colors.white,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Sizes.size16),
          topRight: Radius.circular(Sizes.size16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Stack(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.only(
                    right: Sizes.size10,
                  ),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.network(
                    avatar,
                    fit: BoxFit.cover,
                  ),
                ),
                isMe
                    ? Container()
                    : const Positioned(
                        right: 3,
                        bottom: -3,
                        child: CircleAvatar(
                          radius: Sizes.size14,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: Sizes.size11,
                            backgroundColor: Colors.black,
                            child: FaIcon(
                              FontAwesomeIcons.plus,
                              color: Colors.white,
                              size: Sizes.size14,
                            ),
                          ),
                        ),
                      )
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: Sizes.size16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        diffTimeString(createdAt),
                        style: TextStyle(
                          fontSize: Sizes.size16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Gaps.h10,
                      GestureDetector(
                        onTap: () => _onMoreTap(context),
                        child: const FaIcon(
                          FontAwesomeIcons.ellipsis,
                          size: Sizes.size16,
                        ),
                      )
                    ],
                  ),
                  Text(
                    content,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                    style: const TextStyle(
                      fontSize: Sizes.size16,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 40,
                margin: const EdgeInsets.only(
                  right: Sizes.size10,
                ),
                child: comments.isEmpty || likes == 0
                    ? null
                    : const VerticalDivider(
                        thickness: 2,
                        indent: 8,
                        endIndent: 15,
                      ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (images.isNotEmpty)
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const SizedBox(
                          width: 270,
                          height: 200,
                        ),
                        Positioned(
                          left: -80,
                          width: 500,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Gaps.h80,
                                for (var image in images)
                                  Container(
                                    width: 270,
                                    height: 200,
                                    margin: const EdgeInsets.only(
                                      top: 10,
                                      right: 10,
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Image.network(
                                      image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                Gaps.h96,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Sizes.size20,
                    ),
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.heart,
                          size: Sizes.size20,
                        ),
                        Gaps.h10,
                        FaIcon(
                          FontAwesomeIcons.comment,
                          size: Sizes.size20,
                        ),
                        Gaps.h10,
                        FaIcon(
                          FontAwesomeIcons.retweet,
                          size: Sizes.size20,
                        ),
                        Gaps.h10,
                        FaIcon(
                          FontAwesomeIcons.paperPlane,
                          size: Sizes.size18,
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40,
                  margin: const EdgeInsets.only(
                    right: Sizes.size10,
                  ),
                ),
                if (comments.length > 2) ...[
                  Positioned(
                    right: 4,
                    bottom: 2,
                    child: Container(
                      width: 24,
                      height: 24,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.network(
                        comments[0]["avatar"],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 30,
                    bottom: -10,
                    child: Container(
                      width: 20,
                      height: 20,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.network(
                        comments[1]["avatar"],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 12,
                    bottom: -20,
                    child: Container(
                      width: 14,
                      height: 14,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Image.network(
                        comments[2]["avatar"],
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ] else if (comments.length == 2) ...[
                  Positioned(
                    right: 24,
                    bottom: -10,
                    child: Container(
                      width: 20,
                      height: 20,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.network(
                        comments[0]["avatar"],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: -12,
                    child: Container(
                      width: 24,
                      height: 24,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 6,
                    bottom: -10,
                    child: Container(
                      width: 20,
                      height: 20,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.network(
                        comments[1]["avatar"],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ] else if (comments.length == 1)
                  Positioned(
                    right: 24,
                    bottom: -10,
                    child: Container(
                      width: 20,
                      height: 20,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.network(
                        comments[0]["avatar"],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
            ),
            Text(
              "${comments.length} replies ・ $likes likes",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: Sizes.size16,
              ),
            ),
          ],
        ),
        Gaps.v10,
        const Divider(),
        Gaps.v10,
      ],
    );
  }
}
