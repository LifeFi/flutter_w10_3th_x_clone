import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/view_models/settings_view_model.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';

class AgreeScreen extends ConsumerStatefulWidget {
  const AgreeScreen({super.key});

  @override
  AgreeScreenState createState() => AgreeScreenState();
}

class AgreeScreenState extends ConsumerState<AgreeScreen> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context, ref.watch(settingsProvider).themeMode);
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/images/thread.svg',
          width: 32,
          height: 32,
          colorFilter: ColorFilter.mode(
            isDark ? Colors.white : Colors.black,
            BlendMode.srcIn,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v32,
            const Text(
              "Customize your experince",
              style: TextStyle(
                  fontSize: Sizes.size32, fontWeight: FontWeight.w800),
            ),
            Gaps.v16,
            const Text(
              "Track where you see Twitter content across the web",
              style: TextStyle(
                  fontSize: Sizes.size20, fontWeight: FontWeight.w700),
            ),
            Gaps.v12,
            SwitchListTile(
              value: _isAgreed,
              onChanged: (value) {
                setState(
                  () {
                    _isAgreed = value;
                  },
                );
              },
              title: const Text(
                "Twitter uses this data to personalize your experience. this web browsing history will never be stored with your name, email, or phone number.",
                style: TextStyle(
                  fontSize: Sizes.size16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              activeColor: isDark ? Colors.white : Colors.black,
              thumbColor: MaterialStateProperty.all(
                isDark ? Colors.black : Colors.white,
              ),
            ),
            Gaps.v20,
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "By signing up, you agree to our",
                  ),
                  TextSpan(
                    text: "Terms",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const TextSpan(
                    text: ", ",
                  ),
                  TextSpan(
                    text: "Privacy Policy",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const TextSpan(
                    text: ", and ",
                  ),
                  TextSpan(
                    text: "Cookie Use",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const TextSpan(
                    text:
                        ". Twitter may use your contact information, including your email address and phone number for purposes oulined in our Privacy Policy. ",
                  ),
                  TextSpan(
                    text: "Learn more",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              style: const TextStyle(
                fontSize: Sizes.size14,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
              child: GestureDetector(
                onTap: _isAgreed
                    ? () => Navigator.pop(context, _isAgreed)
                    : () => {},
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: Sizes.size64,
                  // width: Sizes.size96,
                  alignment: const Alignment(0, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: !_isAgreed
                        ? Colors.grey
                        : isDark
                            ? Colors.white
                            : Colors.black,
                  ),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      color: !_isAgreed
                          ? Colors.white
                          : isDark
                              ? Colors.black
                              : Colors.white,
                      fontSize: Sizes.size24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
