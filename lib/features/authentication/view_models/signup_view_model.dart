import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/views/interests_screen_part1.dart';
import 'package:flutter_w10_3th_x_clone/features/users/view_models/users_view_model.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;
  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  Future<void> emailSignUp(BuildContext context) async {
    state = const AsyncValue.loading();
    final form = ref.read(signUpForm);
    final users = ref.read(usersProvider(null).notifier);

    state = await AsyncValue.guard(() async {
      final userCredential = await _authRepo.emailSignUp(
        form["email"],
        form["password"],
      );
      await users.createProfile(userCredential);
    });
    if (!context.mounted) return;
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      await resetProviders(ref);
      if (context.mounted) {
        context.goNamed(InterestsScreenPart1.routeName);
      }
    }
  }
}

final signUpForm = StateProvider((ref) => {});

final signUpProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
