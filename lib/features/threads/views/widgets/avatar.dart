import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/view_models/settings_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/view_models/has_avatar_view_model.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Avatar extends ConsumerWidget {
  final double size;
  final String userId;
  final String userName;
  final bool hasFollowBtn;

  const Avatar({
    super.key,
    this.size = Sizes.size40,
    required this.userId,
    this.userName = "",
    this.hasFollowBtn = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = isDarkMode(context, ref.watch(settingsProvider).themeMode);
    final hasAvatar = ref.read(hasAvatarProvider.notifier).hasAvatar(userId);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: size,
          width: size,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            color: Colors.grey.shade300,
          ),
          child: hasAvatar
              ? Image.network(
                  imageUrl(
                    "avatars/$userId",
                  ),
                  errorBuilder: (context, error, stackTrace) {
                    ref.read(hasAvatarProvider.notifier).addHasNoAvatar(userId);
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.size4,
                        ),
                        child: Text(
                          userName,
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                        ),
                      ),
                    );
                  },
                  fit: BoxFit.cover,
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.size4,
                    ),
                    child: Text(
                      userName,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                    ),
                  ),
                ),
        ),
        if (hasFollowBtn)
          Positioned(
            right: -size * 0.1,
            bottom: -size * 0.1,
            child: CircleAvatar(
              radius: size * 0.35,
              backgroundColor: isDark ? Colors.black : Colors.white,
              child: CircleAvatar(
                radius: size * 0.27,
                backgroundColor: isDark ? Colors.white : Colors.black,
                child: FaIcon(
                  FontAwesomeIcons.plus,
                  color: isDark ? Colors.black : Colors.white,
                  size: size * 0.35,
                ),
              ),
            ),
          )
      ],
    );
  }
}
