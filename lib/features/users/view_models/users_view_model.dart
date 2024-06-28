import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/users/models/user_profile_model.dart';
import 'package:flutter_w10_3th_x_clone/features/users/repos/user_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsersViewModel extends FamilyAsyncNotifier<UserProfileModel, String?> {
  late UserRepository _usersRepository;
  late AuthenticationRepository _authenticationRepository;
  late String? _uid;

  @override
  FutureOr<UserProfileModel> build(String? arg) async {
    // await Future.delayed(const Duration(seconds: 5)); // 테스트 위함
    _usersRepository = ref.watch(userRepo);
    _authenticationRepository = ref.watch(authRepo);
    _uid = arg;

    if (_authenticationRepository.isLoggedIn) {
      final user = _authenticationRepository.user;
      final profile = await _usersRepository.findProfile(_uid ?? user!.uid);

      if (profile != null) {
        return UserProfileModel.fromJson(
          json: profile,
          uid: user!.uid,
        );
      }
    }
    return UserProfileModel.empty();
  }

  Future<UserProfileModel?> findProfile(String uid) async {
    final profile = await _usersRepository.findProfile(uid);
    if (profile != null) {
      return UserProfileModel.fromJson(
        json: profile,
        uid: uid,
      );
    }
    return null;
  }

  Future<void> createProfile(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }
    state = const AsyncValue.loading();

    final profile = UserProfileModel(
      hasAvatar: false,
      uid: credential.user!.uid,
      email: credential.user!.email ?? "anon@anon.com",
      name: credential.user!.displayName ??
          (credential.user!.email?.split("@")[0] ?? "anon"),
      bio: "undefined",
      link: "undefined",
      following: 0,
      followers: 0,
    );
    await _usersRepository.createProfile(profile);
    state = AsyncValue.data(profile);
  }

  Future<void> onAvatarUpload() async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(hasAvatar: true));
    await _usersRepository.updateUser(state.value!.uid, {"hasAvatar": true});
  }
}

final usersProvider =
    AsyncNotifierProvider.family<UsersViewModel, UserProfileModel, String?>(
  () => UsersViewModel(),
);
