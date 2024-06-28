import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/views/sign_up_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/common/widgets/theme_config.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/view_models/settings_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/views/privacy_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/users/view_models/users_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/view_models/threads_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  static const String routeName = "settings";
  static const String routeURL = "/settings";

  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends ConsumerState<SettingsScreen> {
  _onBackTap() {
    context.pop();
    // context.go("/profile");
  }

  _onPrivacyTap() {
    /* context.goNamed(
      PrivacyScreen.routeName,
      pathParameters: {"tab": "profile"},
    ); */
    context.pushNamed(PrivacyScreen.routeName);
  }

  _onLogoutTap() {
    ref.read(authRepo).signOut();
    // Rivierpod Provider 초기화
    // ref.invalidate(usersProvider);
    // ref.invalidate(threadsProvider);
    context.go("/signup");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            color: Colors.grey.withOpacity(0.7),
          ),
          ListTile(
            title: Row(
              children: [
                FaIcon(
                  ref.watch(settingsProvider).themeMode == ThemeMode.system
                      ? FontAwesomeIcons.gear
                      : ref.watch(settingsProvider).themeMode == ThemeMode.light
                          ? FontAwesomeIcons.lightbulb
                          : FontAwesomeIcons.solidMoon,
                  size: Sizes.size18,
                ),
                Gaps.h10,
                const Text(
                  "Theme Mode(ing...)",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                  ),
                ),
              ],
            ),
            trailing: DropdownButton(
              value: ref.watch(settingsProvider).themeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text("System"),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text("Light Theme"),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text("Dark Theme"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  ref
                      .read(settingsProvider.notifier)
                      .setThemeMode(value as ThemeMode);
                });
              },
            ),
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
            color: Colors.grey.withOpacity(0.7),
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
                                      onPressed: _onLogoutTap,
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
