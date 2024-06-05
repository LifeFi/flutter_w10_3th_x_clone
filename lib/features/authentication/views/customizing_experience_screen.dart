import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomizingExperienceScreen extends StatefulWidget {
  const CustomizingExperienceScreen({super.key});

  @override
  State<CustomizingExperienceScreen> createState() =>
      _CustomizingExperienceState();
}

class _CustomizingExperienceState extends State<CustomizingExperienceScreen> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FaIcon(
          FontAwesomeIcons.twitter,
          size: Sizes.size36,
          color: Theme.of(context).primaryColor,
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
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Twitter uses this data to personalize your experience. this web browsing history will never be stored with your name, email, or phone number.",
                    style: TextStyle(
                      fontSize: Sizes.size18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                CupertinoSwitch(
                  value: _isAgreed,
                  onChanged: (value) {
                    setState(
                      () {
                        _isAgreed = value;
                      },
                    );
                  },
                ),
              ],
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
                    color: _isAgreed ? Colors.black : Colors.grey,
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
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
