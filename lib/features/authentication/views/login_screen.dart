import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/view_models/google_login_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/views/email_login_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/views/sign_up_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/view_models/settings_view_model.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerWidget {
  static const String routeName = "login";
  static const String routeURL = "/login";

  const LoginScreen({super.key});

  void _onSignUpTap(BuildContext context) {
    context.goNamed(SignUpScreen.routeName);
  }

  void _onEmailLogin(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const EmailLoginScreen(),
    ));
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
              "Log in",
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
            GestureDetector(
              onTap: () => _onEmailLogin(context),
              child: Container(
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
                    Icon(
                      Icons.email_outlined,
                      size: Sizes.size32,
                    ),
                    Gaps.h12,
                    Text(
                      "Use email & password",
                      style: TextStyle(
                        fontSize: Sizes.size20,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                const Text(
                  "haven't an account yet? ",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                  ),
                ),
                GestureDetector(
                  onTap: () => _onSignUpTap(context),
                  child: Text(
                    "Sign Up",
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
