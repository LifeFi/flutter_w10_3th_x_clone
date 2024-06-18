import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/views/create_account_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/users/views/privacy_screen.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = "settings";
  static const String routeURL = "settings";

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  _onBackTap() {
    Navigator.of(context).pop();
  }

  _onPrivacyTap() {
    context.goNamed(
      PrivacyScreen.routeName,
      pathParameters: {"tab": "profile"},
    );
  }

  _onLogoutTap() {
    context.goNamed(CreateAccountScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: Sizes.size80,
        leading: Navigator.canPop(context)
            ? GestureDetector(
                onTap: _onBackTap,
                child: const Row(
                  children: [
                    Gaps.h10,
                    FaIcon(
                      FontAwesomeIcons.chevronLeft,
                      size: Sizes.size16,
                    ),
                    Text(
                      " Back",
                      style: TextStyle(fontSize: Sizes.size18),
                    ),
                  ],
                ),
              )
            : Container(),
        title: const Text(
          "Settings",
          style: TextStyle(fontSize: Sizes.size18, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          Divider(
            indent: Sizes.size10,
            endIndent: Sizes.size10,
            color: Colors.grey.shade300,
          ),
          const ListTile(
            title: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.userPlus,
                  size: Sizes.size18,
                ),
                Gaps.h10,
                Text(
                  "Follow and invite friends",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                  ),
                ),
              ],
            ),
          ),
          const ListTile(
            title: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.bell,
                  size: Sizes.size18,
                ),
                Gaps.h10,
                Text(
                  "Notifications",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: _onPrivacyTap,
            title: const Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.lock,
                  size: Sizes.size18,
                ),
                Gaps.h10,
                Text(
                  "Privacy",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                  ),
                ),
              ],
            ),
          ),
          const ListTile(
            title: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.circleUser,
                  size: Sizes.size18,
                ),
                Gaps.h10,
                Text(
                  "Account",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                  ),
                ),
              ],
            ),
          ),
          const ListTile(
            title: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.lifeRing,
                  size: Sizes.size18,
                ),
                Gaps.h10,
                Text(
                  "Help",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                  ),
                ),
              ],
            ),
          ),
          const AboutListTile(
            applicationName: "Flutter w10 Study",
            applicationVersion: "ver. d29/70",
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.circleInfo,
                  size: Sizes.size18,
                ),
                Gaps.h10,
                Text(
                  "About",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            indent: Sizes.size10,
            endIndent: Sizes.size10,
            color: Colors.grey.shade300,
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    kIsWeb
                        ? showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Log out"),
                              content: const Text(
                                  "Are you sure? \n ( Platrofm: Web)"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("No"),
                                ),
                                TextButton(
                                  onPressed: _onLogoutTap,
                                  child: const Text("Yes"),
                                )
                              ],
                            ),
                          )
                        : Platform.isIOS
                            ? showCupertinoModalPopup(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                  title: const Text("Log out"),
                                  content: Text(
                                      "Are you sure? \n ( Platrofm: ${Platform.operatingSystem})"),
                                  actions: [
                                    CupertinoDialogAction(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("No"),
                                    ),
                                    CupertinoDialogAction(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Yes"),
                                    )
                                  ],
                                ),
                              )
                            : showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Log out"),
                                  content: Text(
                                      "Are you sure? \n ( Platrofm: ${Platform.operatingSystem})"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("No"),
                                    ),
                                    TextButton(
                                      onPressed: _onLogoutTap,
                                      child: const Text("Yes"),
                                    )
                                  ],
                                ),
                              );
                  },
                  child: Text(
                    "Log out",
                    style: TextStyle(
                      fontSize: Sizes.size16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
