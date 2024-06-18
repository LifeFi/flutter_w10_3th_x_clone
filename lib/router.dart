import 'package:flutter_w10_3th_x_clone/features/authentication/views/create_account_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/views/interests_screen_part1.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/views/login_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/main_navigation/main_navigation_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/users/views/privacy_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/users/views/settings_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: "/home",
  redirect: (context, state) {
    if (state.fullPath == "") {
      return "/home";
    }
    return null;
  },
  routes: [
    GoRoute(
      name: CreateAccountScreen.routeName,
      path: CreateAccountScreen.routeURL,
      builder: (context, state) => const CreateAccountScreen(),
    ),
    GoRoute(
      name: LoginScreen.routeName,
      path: LoginScreen.routeURL,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: InterestsScreenPart1.routeName,
      path: InterestsScreenPart1.routeURL,
      builder: (context, state) => const InterestsScreenPart1(),
    ),
    GoRoute(
        name: MainNavigationScreen.routeName,
        path: "/:tab(home|search|activity|profile)",
        builder: (context, state) {
          final tab = state.pathParameters["tab"]!;
          return MainNavigationScreen(tab: tab);
        },
        routes: [
          GoRoute(
              name: SettingsScreen.routeName,
              path: SettingsScreen.routeURL,
              builder: (context, state) => const SettingsScreen(),
              routes: [
                GoRoute(
                  name: PrivacyScreen.routeName,
                  path: PrivacyScreen.routeURL,
                  builder: (context, state) => const PrivacyScreen(),
                )
              ]),
        ]),
  ],
);
