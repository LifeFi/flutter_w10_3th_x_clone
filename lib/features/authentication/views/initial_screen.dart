import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/views/create_account_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/views/login_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

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
          horizontal: Sizes.size36,
        ),
        child: Column(
          children: [
            Gaps.v72,
            const Text(
              "See what's happening in the world right now.",
              style: TextStyle(
                  fontSize: Sizes.size28, fontWeight: FontWeight.w700),
            ),
            Gaps.v72,
            Container(
              height: Sizes.size60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
                borderRadius: BorderRadius.circular(Sizes.size32),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.google,
                    size: Sizes.size24,
                  ),
                  Gaps.h12,
                  Text(
                    "Continue with Google",
                    style: TextStyle(
                      fontSize: Sizes.size20,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Gaps.v10,
            Container(
              height: Sizes.size60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
                borderRadius: BorderRadius.circular(Sizes.size32),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.apple,
                    size: Sizes.size32,
                  ),
                  Gaps.h12,
                  Text(
                    "Continue with Apple",
                    style: TextStyle(
                      fontSize: Sizes.size20,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Gaps.v20,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Divider(
                    thickness: 1,
                    indent: Sizes.size12,
                    endIndent: Sizes.size12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "or",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    color: Colors.grey.shade800,
                  ),
                ),
                const Expanded(
                  child: Divider(
                    thickness: 1,
                    indent: Sizes.size12,
                    endIndent: Sizes.size12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Gaps.v5,
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateAccountScreen(),
                ),
              ),
              child: Container(
                height: Sizes.size60,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(Sizes.size32),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Create Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Sizes.size20,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Gaps.v16,
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: "By signing up, you agree our "),
                  TextSpan(
                    text: " Terms",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const TextSpan(text: ", "),
                  TextSpan(
                    text: "Privacy Policy",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const TextSpan(text: ", and "),
                  TextSpan(
                    text: "Cookie Use",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const TextSpan(text: ".")
                ],
                style: const TextStyle(
                  fontSize: Sizes.size18,
                ),
              ),
            ),
            Gaps.v36,
            Row(
              children: [
                const Text(
                  "have an account already? ",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  ),
                  child: Text(
                    "Log in",
                    style: TextStyle(
                      fontSize: Sizes.size16,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
