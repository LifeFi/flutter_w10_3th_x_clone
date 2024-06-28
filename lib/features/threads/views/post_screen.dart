import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/models/follow_data_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/view_models/follow_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/views/widgets/avatar.dart';
import 'package:flutter_w10_3th_x_clone/features/users/view_models/is_following_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/users/view_models/users_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/views/camera_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/view_models/post_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/view_models/settings_view_model.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

/* 
final Map<String, dynamic> user = {
  "id": random.integer(1000000),
  "name": faker.person.name(),
  "avatar": faker.image.image(
    keywords: ["avatar", "profile"],
    height: 80,
    width: 80,
    random: true,
  ),
};
 */
class PostScreen extends ConsumerStatefulWidget {
  static const String routeName = "post";
  static const String routeURL = "/post";

  final String commentOf;
  final String creator;
  final String creatorUid;
  final String content;

  const PostScreen({
    super.key,
    this.commentOf = "",
    this.creator = "",
    this.creatorUid = "",
    this.content = "",
  });

  @override
  PostScreenState createState() => PostScreenState();
}

class PostScreenState extends ConsumerState<PostScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<dynamic> _photos = [];
  final List<Uint8List> _previewPhotsForWeb = [];

  _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  _onPhotoTap() async {
    dynamic result;

    if (kIsWeb) {
      result = await ImagePicker().pickMultiImage();
    } else {
      result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const CameraScreen(),
        ),
      );
    }

    // print("result: $result");

    if (result == null) return;
    _photos.addAll([...result]);
    if (kIsWeb) {
      for (var photo in _photos) {
        final previewPhoto = await photo.readAsBytes();
        _previewPhotsForWeb.add(previewPhoto);
      }
    }
    // print(_photos);
    // debugPrint(result.toString());
    // if (_photos.isNotEmpty) print(_photos[0].path);
    setState(() {});
  }

  _onCancelTap() {
    Navigator.of(context).pop(false);
  }

  _onPostTap() {
    if (ref.watch(postThreadProvider).isLoading) return;

    ref.read(postThreadProvider.notifier).postThread(
          content: _controller.text,
          images: _photos.isNotEmpty ? _photos : [],
          commentOf: widget.commentOf,
        );
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(
      () {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isEnablePost() {
    return _controller.value.text.isNotEmpty;
  }

  _onDeleteTap(int index) {
    _photos.removeAt(index);
    if (kIsWeb) _previewPhotsForWeb.removeAt(index);
    setState(() {});
  }

  _onDeleteAllTap() {
    _photos.clear();
    if (kIsWeb) _previewPhotsForWeb.clear;
    setState(() {});
  }

  Future<void> _onFollowTap() async {
    await ref.read(followProvider.notifier).followUser(
          FollowDataModel(
            uid: widget.creatorUid,
            name: widget.creator,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context, ref.watch(settingsProvider).themeMode);
    final user = ref.read(usersProvider(null)).value;
    final isMine = user?.uid == widget.creatorUid;
    final isComment = widget.commentOf != "";
    final myFollowing = ref.watch(isFollowingProvider).value?.myFollowing;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: GestureDetector(
        onTap: _onScaffoldTap,
        child: Scaffold(
          appBar: AppBar(
            leadingWidth: 100,
            leading: GestureDetector(
                onTap: _onCancelTap,
                child: Container(
                  width: Sizes.size40,
                  padding: const EdgeInsets.only(
                    left: Sizes.size18,
                    top: Sizes.size18,
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontSize: Sizes.size18),
                  ),
                )),
            title: Text(
              isComment ? "New Comment" : "New thread",
              style: const TextStyle(
                fontSize: Sizes.size18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              ref.watch(postThreadProvider).isLoading
                  ? const CircularProgressIndicator.adaptive()
                  : Container(),
              Gaps.h20,
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                height: 0.5,
                color: Colors.grey.withOpacity(0.7),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size10,
            ),
            child: Stack(
              children: [
                ListView(
                  children: [
                    Gaps.v10,
                    if (isComment)
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: isMine
                                      ? () {}
                                      : (myFollowing != null &&
                                              myFollowing
                                                  .contains(widget.creatorUid))
                                          ? () {}
                                          : _onFollowTap,
                                  child: Avatar(
                                    size: 40,
                                    userId: widget.creatorUid,
                                    userName: widget.creator,
                                    hasFollowBtn: isMine
                                        ? false
                                        : (myFollowing != null &&
                                                myFollowing.contains(
                                                    widget.creatorUid))
                                            ? false
                                            : true,
                                  ),
                                ),
                                Expanded(
                                  child: VerticalDivider(
                                    color: Colors.grey.shade300,
                                    thickness: 2.5,
                                    indent: Sizes.size8,
                                    endIndent: Sizes.size8,
                                  ),
                                ),
                              ],
                            ),
                            Gaps.h10,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.creator,
                                  style: const TextStyle(
                                    fontSize: Sizes.size16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  widget.content,
                                  style: const TextStyle(
                                    fontSize: Sizes.size16,
                                  ),
                                ),
                                Gaps.v28,
                              ],
                            ),
                          ],
                        ),
                      ),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Avatar(
                                size: 40,
                                userId: user!.uid,
                                userName: user.name,
                                hasFollowBtn: false,
                              ),
                              Expanded(
                                child: VerticalDivider(
                                  color: Colors.grey.shade300,
                                  thickness: 2.5,
                                  indent: Sizes.size8,
                                  endIndent: Sizes.size8,
                                ),
                              ),
                              Avatar(
                                size: 16,
                                userId: user.uid,
                                hasFollowBtn: false,
                              ),
                            ],
                          ),
                          Gaps.h10,
                          Expanded(
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: const TextStyle(
                                        fontSize: Sizes.size16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextField(
                                      controller: _controller,
                                      autofocus: true,
                                      maxLines: null,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        hintText: "Start a thread...",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                    Gaps.v10,
                                    if (_photos.isNotEmpty)
                                      SizedBox(
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: [
                                            for (var index = 0;
                                                index < _photos.length;
                                                index++)
                                              Stack(
                                                children: [
                                                  Container(
                                                    width: 270,
                                                    height: 200,
                                                    margin:
                                                        const EdgeInsets.only(
                                                      top: 10,
                                                      right: 10,
                                                    ),
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: kIsWeb
                                                        ? Image.memory(
                                                            _previewPhotsForWeb[
                                                                index],
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.file(
                                                            File(_photos[index]
                                                                .path),
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                  Positioned(
                                                    top: Sizes.size16,
                                                    right: Sizes.size16,
                                                    child: GestureDetector(
                                                      onTap: () =>
                                                          _onDeleteTap(index),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        alignment:
                                                            Alignment.center,
                                                        width: Sizes.size24,
                                                        height: Sizes.size24,
                                                        decoration:
                                                            const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.grey,
                                                        ),
                                                        child: const FaIcon(
                                                          FontAwesomeIcons
                                                              .xmark,
                                                          color: Colors.white,
                                                          size: Sizes.size14,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                          ],
                                        ),
                                      )
                                    else
                                      Container(),
                                    Gaps.v10,
                                    GestureDetector(
                                      onTap: _onPhotoTap,
                                      child: const FaIcon(
                                        FontAwesomeIcons.paperclip,
                                        size: Sizes.size24,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Gaps.v40,
                                  ],
                                ),
                                if (_photos.isNotEmpty)
                                  Positioned(
                                    right: Sizes.size6,
                                    top: Sizes.size4,
                                    child: GestureDetector(
                                      onTap: () => _onDeleteAllTap(),
                                      child: const FaIcon(
                                        FontAwesomeIcons.xmark,
                                        color: Colors.grey,
                                        size: Sizes.size16,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gaps.v80,
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: isDark ? Colors.black : Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: Sizes.size20,
                      horizontal: Sizes.size20,
                    ),
                    // height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text("Anyone can reply"),
                        GestureDetector(
                          onTap: _isEnablePost() ? _onPostTap : null,
                          child: Text(
                            "Post",
                            style: TextStyle(
                              color: _isEnablePost()
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                              fontSize: Sizes.size18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
