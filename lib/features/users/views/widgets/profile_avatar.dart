import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/users/view_models/avatar_view_model.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileAvatar extends ConsumerWidget {
  final String name;
  final String uid;
  final bool hasAvatar;
  final bool canUpload;

  const ProfileAvatar({
    super.key,
    required this.name,
    required this.uid,
    required this.hasAvatar,
    required this.canUpload,
  });

  Future<void> _onAvatarTap(WidgetRef ref) async {
    final xfile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxHeight: 150,
      maxWidth: 150,
    );
    if (xfile != null) {
      ref.read(profileAvatarProvider.notifier).uploadAvatar(xfile);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(profileAvatarProvider).isLoading;
    return GestureDetector(
      onTap: isLoading || !canUpload ? null : () => _onAvatarTap(ref),
      child: isLoading
          ? Container(
              width: Sizes.size32,
              height: Sizes.size32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator.adaptive(),
            )
          : CircleAvatar(
              radius: Sizes.size32,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: hasAvatar
                  ? NetworkImage(
                      // %2F 는 / 의 16진수 표현이다.
                      imageUrl("avatars/$uid", isCached: true),
                      // NetworkImage 가 기본적으로 캐싱을 하기 때문에, refresh를 위해 uri 에 랜덤한 문자열을 추가했음.
                    )
                  : null,
              child: hasAvatar
                  ? null
                  : Text(
                      name,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                    ),
            ),
    );
  }
}
