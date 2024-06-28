import 'dart:async';

import 'package:flutter_w10_3th_x_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/users/repos/user_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowingCache {
  Set<String> myFollowing;
  Set<String> myUnfollowing;

  FollowingCache({
    required this.myFollowing,
    required this.myUnfollowing,
  });

  Map<String, dynamic> toJson() {
    return {
      "myFollowing": myFollowing,
      "myUnfollowing": myUnfollowing,
    };
  }
}

class IsFollowingViewModel extends AsyncNotifier<FollowingCache> {
  late UserRepository _userRepository;
  late AuthenticationRepository _authenticationRepository;
  late FollowingCache _followingCache;
  late String _uid;

  @override
  FutureOr<FollowingCache> build() {
    _userRepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);
    _uid = _authenticationRepository.user!.uid;

    _followingCache = FollowingCache(
      myFollowing: {},
      myUnfollowing: {},
    );
    return _followingCache;
  }

  Future<bool> isFollowing(String uid) async {
    if (uid == _uid) return true;
    if (_followingCache.myFollowing.contains(uid)) return true;
    if (_followingCache.myUnfollowing.contains(uid)) return false;

    final result = await _userRepository.isFollowing(_uid, uid);
    result
        ? _followingCache.myFollowing.add(uid)
        : _followingCache.myFollowing.remove(uid);
    state = AsyncData(_followingCache);
    return result;
  }

  void addFollowing(String uid) {
    _followingCache.myFollowing.add(uid);
    _followingCache.myUnfollowing.remove(uid);
    state = AsyncData(_followingCache);
  }

  void removeFollowing(String uid) {
    _followingCache.myFollowing.remove(uid);
    _followingCache.myUnfollowing.add(uid);
    state = AsyncData(_followingCache);
  }
}

final isFollowingProvider =
    AsyncNotifierProvider<IsFollowingViewModel, FollowingCache>(
  () => IsFollowingViewModel(),
);
