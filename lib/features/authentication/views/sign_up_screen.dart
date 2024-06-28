import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/view_models/google_login_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/view_models/settings_view_model.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/views/login_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/views/create_account_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends ConsumerWidget {
  static const String routeName = "signup";
  static const String routeURL = "/signup";

  const SignUpScreen({super.key});

  _onCreateAccountTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateAccountScreen(),
      ),
    );
  }

  _onLoginTap(BuildContext context) {
    context.goNamed(LoginScreen.routeName);
  }

  void _onGoogleLogin(BuildContext context, WidgetRef ref) {
    ref.read(googleLoginProvider.notifier).googleLogin(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            GestureDetector(
              onTap: () => _onGoogleLogin(context, ref),
              child: Stack(
                children: [
                  Container(
                    height: Sizes.size60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade400,
                      ),
                      borderRadius: BorderRadius.circular(Sizes.size32),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
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
                  if (ref.watch(googleLoginProvider).isLoading)
                    const Positioned(
                        left: Sizes.size6,
                        top: 0,
                        bottom: 0,
                        child: CircularProgressIndicator.adaptive())
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
              onTap: () => _onCreateAccountTap(context),
              child: Container(
                height: Sizes.size60,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white : Colors.black,
                  borderRadius: BorderRadius.circular(Sizes.size32),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Create Account",
                      style: TextStyle(
                        color: isDark ? Colors.black : Colors.white,
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
            const Spacer(),
            Row(
              children: [
                const Text(
                  "have an account already? ",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                  ),
                ),
                GestureDetector(
                  onTap: () => _onLoginTap(context),
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
            Gaps.v60,
          ],
        ),
      ),
    );
  }
}
