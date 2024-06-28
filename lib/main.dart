import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_w10_3th_x_clone/features/search/repos/recent_keywords_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/search/view_models/recent_keywords_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/repos/settings_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/view_models/settings_view_model.dart';
import 'package:flutter_w10_3th_x_clone/firebase_options.dart';
import 'package:flutter_w10_3th_x_clone/router.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  // context.push 시에 url 을 바꿔주기 위해, GoRouter 8.0 이전과 동일하게 작동하도록 세팅.
  //
  GoRouter.optionURLReflectsImperativeAPIs = true;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final preferences = await SharedPreferences.getInstance();
  final settingsRepository = SettingsRepository(preferences);
  final recentKeywordsRepository = RecentKeywordsRepository(preferences);

  runApp(
    ProviderScope(
      overrides: [
        settingsProvider.overrideWith(
          () => SettingsViewModel(settingsRepository),
        ),
        recentKeywordsProvider.overrideWith(
          () => RecentKeywordsViewModel(recentKeywordsRepository),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      debugShowCheckedModeBanner: false,
      themeMode: ref.watch(settingsProvider).themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        textTheme: Typography.blackMountainView,
        primaryColor: const Color(0xFF4A98E9),
        scaffoldBackgroundColor: Colors.white,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF4A98E9),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        bottomAppBarTheme: const BottomAppBarTheme(
          color: Colors.white,
        ),
        listTileTheme: const ListTileThemeData(
          textColor: Colors.black,
          iconColor: Colors.black,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          modalBackgroundColor: Colors.white,
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.black,
          indicatorColor: Colors.black,
          unselectedLabelColor: Colors.grey.shade600,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        textTheme: Typography.whiteMountainView,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFF4A98E9),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF4A98E9),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.black,
        ),
        bottomAppBarTheme: const BottomAppBarTheme(
          color: Colors.black,
        ),
        listTileTheme: const ListTileThemeData(
          textColor: Colors.white,
          iconColor: Colors.white,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          modalBackgroundColor: Colors.grey.shade900,
        ),
        tabBarTheme: TabBarTheme(
          overlayColor: const MaterialStatePropertyAll(Colors.black),
          labelColor: Colors.white,
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade600,
        ),
      ),
    );
  }
}
