import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/home/views/widgets/feeds_data.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final Map<String, dynamic> user = {
  "id": random.integer(1000000),
  "name": faker.person.name(),
  // "avatar": faker.image.image(
  //   keywords: ["avatar", "profile"],
  //   height: 80,
  //   width: 80,
  //   random: true,
  // ),
  "avatar": getImage(),
};

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _controller = TextEditingController();

  _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  _onCancelTap() {
    Navigator.of(context).pop(false);
  }

  _onPostTap() {
    feedsData.post(
      id: user["id"],
      name: user["name"],
      avatar: user["avatar"],
      content: _controller.text,
    );

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: GestureDetector(
        onTap: _onScaffoldTap,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
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
            title: const Text(
              "New thread",
              style: TextStyle(
                fontSize: Sizes.size18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size10,
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    const Divider(
                      thickness: 0.5,
                    ),
                    Gaps.v10,
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.5,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: Sizes.size20,
                                  foregroundImage: NetworkImage(user["avatar"]),
                                ),
                              ),
                              Expanded(
                                child: VerticalDivider(
                                  color: Colors.grey.shade300,
                                  thickness: 2.5,
                                  indent: Sizes.size10,
                                  endIndent: Sizes.size10,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.5,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: Sizes.size8,
                                  foregroundImage: NetworkImage(user["avatar"]),
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: Sizes.size8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Gaps.h10,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user["name"],
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
                                  cursorColor: Theme.of(context).primaryColor,
                                ),
                                Gaps.v10,
                                const FaIcon(
                                  FontAwesomeIcons.paperclip,
                                  size: Sizes.size24,
                                  color: Colors.grey,
                                ),
                                Gaps.v40,
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                  bottom: Sizes.size20,
                  left: Sizes.size10,
                  right: Sizes.size10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
