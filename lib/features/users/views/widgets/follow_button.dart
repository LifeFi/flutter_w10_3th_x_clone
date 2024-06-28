import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/view_models/settings_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/models/follow_data_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/view_models/follow_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/users/view_models/is_following_view_model.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowButton extends ConsumerStatefulWidget {
  final String uid;
  final String name;
  final double width;
  final double height;
  final bool isStrong;

  const FollowButton({
    super.key,
    required this.uid,
    required this.name,
    this.isStrong = false,
    this.width = 100.0,
    this.height = 40.0,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FollowButtonState();
}

class _FollowButtonState extends ConsumerState<FollowButton> {
  bool _isLoading = false;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      setState(() {
        _isLoading = true;
      });
      _isFollowing =
          await ref.read(isFollowingProvider.notifier).isFollowing(widget.uid);

      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _onFollowTap() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    if (_isFollowing) {
      await ref.read(followProvider.notifier).unfollowUser(
            FollowDataModel(
              uid: widget.uid,
              name: widget.name,
            ),
          );
      ref.read(isFollowingProvider.notifier).removeFollowing(widget.uid);
    } else {
      await ref.read(followProvider.notifier).followUser(
            FollowDataModel(
              uid: widget.uid,
              name: widget.name,
            ),
          );
      ref.read(isFollowingProvider.notifier).addFollowing(widget.uid);
    }
    _isFollowing = !_isFollowing;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context, ref.watch(settingsProvider).themeMode);

    return GestureDetector(
      onTap: _onFollowTap,
      child: Container(
        width: widget.width,
        height: widget.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.size10),
          border: Border.all(color: Colors.grey.withOpacity(0.7)),
          color: widget.isStrong && !_isLoading && !_isFollowing
              ? (isDark ? Colors.white : Colors.black)
              : (isDark ? Colors.black : Colors.white),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : _isFollowing
                ? Text("Following",
                    style: TextStyle(
                      fontSize: Sizes.size16,
                      color: Colors.grey.withOpacity(0.7),
                      fontWeight: widget.isStrong ? FontWeight.bold : null,
                    ))
                : Text("Follow",
                    style: TextStyle(
                      fontSize: Sizes.size16,
                      color: widget.isStrong && !_isLoading && !_isFollowing
                          ? (isDark ? Colors.black : Colors.white)
                          : (isDark ? Colors.white : Colors.black),
                      fontWeight: widget.isStrong ? FontWeight.bold : null,
                    )),
      ),
    );
  }
}
