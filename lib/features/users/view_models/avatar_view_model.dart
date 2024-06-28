import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/users/repos/user_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/users/view_models/users_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileAvatarViewModel extends AsyncNotifier<void> {
  late final UserRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(userRepo);
  }

  Future<void> uploadAvatar(XFile xfile) async {
    state = const AsyncValue.loading();
    final fileName = ref.read(authRepo).user!.uid;
    //final fileName = ref.read(usersProvider).value!.uid;
    // final fileName = ref.read(usersProvider).when(
    //       data: (data) => data.uid,
    //       error: (error, stackTrace) => null,
    //       loading: () => null,
    //     );

    state = await AsyncValue.guard(() async {
      if (kIsWeb) {
        // print(xfile);
        Uint8List fileData = await xfile.readAsBytes();
        // print(fileData);
        await _repository.uploadAvatar(fileData, fileName);
      } else {
        File file = File(xfile.path);
        // print(file);
        await _repository.uploadAvatar(file, fileName);
      }

      ref.read(usersProvider(null).notifier).onAvatarUpload();
    });
  }
}

final profileAvatarProvider =
    AsyncNotifierProvider<ProfileAvatarViewModel, void>(
  () => ProfileAvatarViewModel(),
);
