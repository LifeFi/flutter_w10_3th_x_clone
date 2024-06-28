import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/users/view_models/users_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/view_models/threads_view_model.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GoogleLoginViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<void> build() {
    _authenticationRepository = ref.read(authRepo);
  }

  Future<void> googleLogin(BuildContext context) async {
    state = const AsyncValue.loading();
    final users = ref.read(usersProvider(null).notifier);

    state = await AsyncValue.guard(() async {
      final userCredential =
          await _authenticationRepository.signInWithGoogle(context);
      if (userCredential != null && userCredential.user != null) {
        final existUser = await users.findProfile(userCredential.user!.uid);

        if (existUser == null) {
          await users.createProfile(userCredential);
          debugPrint("Made new Profile from google login!");
        }
      }
    });

    print(state.error);
    if (state.hasError && context.mounted) {
      showFirebaseErrorSnack(context, state.error);
    } else if (context.mounted) {
      // ref.container.refresh(authRepo);
      await resetProviders(ref);
      if (context.mounted) {
        context.go("/home");
      }
    }
  }
}

final googleLoginProvider = AsyncNotifierProvider<GoogleLoginViewModel, void>(
  () => GoogleLoginViewModel(),
);
