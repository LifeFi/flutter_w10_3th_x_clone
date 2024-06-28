import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/users/view_models/users_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/view_models/threads_view_model.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EmailLoginViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _repository;
  @override
  FutureOr<void> build() async {
    _repository = ref.read(authRepo);
  }

  Future<void> emailLogin(
    String email,
    String password,
    BuildContext context,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async => await _repository.emailSignIn(email, password),
    );
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

final emailLoginProvider = AsyncNotifierProvider<EmailLoginViewModel, void>(
  () => EmailLoginViewModel(),
);
