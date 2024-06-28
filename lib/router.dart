import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/views/interests_screen_part1.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/views/login_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/views/sign_up_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/main_navigation/main_navigation_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/main_navigation/main_navigation_shell.dart';
import 'package:flutter_w10_3th_x_clone/features/search/views/search_result_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/views/privacy_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/views/settings_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/models/thread_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/views/thread_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/users/views/user_profile_screen.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider(
  (ref) {
    // ref.watch(authState);
    return GoRouter(
      initialLocation: "/home",
      redirect: (context, state) {
        print("state.matchedLocation: ${state.matchedLocation}");

        final isLoggedIn = ref.read(authRepo).isLoggedIn;
        if (!isLoggedIn) {
          // 7.0.0 에서 subloc => matchedLocation 으로 renamed

          if (state.matchedLocation != SignUpScreen.routeURL &&
              state.matchedLocation != LoginScreen.routeURL) {
            return SignUpScreen.routeURL;
          }
        }

        return null;
      },
      routes: [
        GoRoute(
          name: SignUpScreen.routeName,
          path: SignUpScreen.routeURL,
          builder: (context, state) => const SignUpScreen(),
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
        ShellRoute(
            builder: (context, state, child) {
              return MainNavigationShell(child: child);
            },
            routes: [
              GoRoute(
                name: MainNavigationScreen.routeName,
                path: "/:tab(home|search|activity|profile)",
                builder: (context, state) {
                  final tab = state.pathParameters["tab"]!;

                  return MainNavigationScreen(tab: tab);
                },
              ),
              GoRoute(
                name: ThreadScreen.routeName,
                path: ThreadScreen.routeURL,
                // path: "/profile/:uid",
                builder: (context, state) {
                  final threadId = state.pathParameters["threadId"]!;
                  final threadData = state.extra as ThreadModel;

                  // print("profile: $uid");
                  return ThreadScreen(
                    id: threadId,
                    creator: threadData.creator,
                    creatorUid: threadData.creatorUid,
                    content: threadData.content,
                    images: threadData.images,
                    commentOf: threadData.commentOf,
                    likes: threadData.likes,
                    replies: threadData.replies,
                    createdAt: threadData.createdAt!.toDate(),
                  );
                },
              ),
              GoRoute(
                name: UserProfileScreen.routeName,
                path: UserProfileScreen.routeURL,
                // path: "/profile/:uid",
                builder: (context, state) {
                  final uid = state.pathParameters["uid"];
                  // print("profile: $uid");
                  return UserProfileScreen(uid: uid);
                },
              ),
              GoRoute(
                name: SearchResultScreen.routeName,
                path: SearchResultScreen.routeURL,
                builder: (context, state) {
                  final keyword = state.pathParameters["keyword"]!;
                  // print("search: $keyword");
                  return SearchResultScreen(keyword: keyword);
                },
              ),
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
                ],
              ),
            ])
      ],
    );
  },
);
