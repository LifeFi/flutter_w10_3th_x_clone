import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_w10_3th_x_clone/constants/enum.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/models/follow_data_model.dart';
import 'package:flutter_w10_3th_x_clone/features/users/repos/user_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/users/view_models/is_following_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/users/view_models/users_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowViewModel extends AsyncNotifier<List<FollowDataModel>> {
  late AuthenticationRepository _authenticationRepository;
  late UserRepository _userRepository;
  List<FollowDataModel> _list = [];
  String _uid = "";

  Future<List<FollowDataModel>> fetchFollow({
    required FollowType fetchType,
    String? uid,
    Timestamp? lastUserFollowedAt,
  }) async {
    // print(uid ?? _uid);
    // print("uid: $uid");
    // print("_uid: $_uid");
    final result = await _userRepository.fetchFollow(
      fetchType: fetchType,
      uid: uid ?? _uid,
      lastUserFollowedAt: lastUserFollowedAt,
    );

    // final futures = result.docs.map(
    final users = result.docs.map(
      (doc) {
        // user 가 following 을 fetch 할때, isFollowing 목록에 추가.
        if (fetchType == FollowType.following && uid == null || uid == _uid) {
          ref.read(isFollowingProvider.notifier).addFollowing(_uid);
        }
        return FollowDataModel.fromJson(
          json: doc.data(),
          userId: doc.id,
        );
      },
    ).toList();

    // final users = await Future.wait(futures);
    return users;
  }

/* 
  Future<List<FollowDataModel>> fetchFollowing({
    String? uid,
    Timestamp? lastUserFollowedAt,
  }) async {
    // print(uid ?? _uid);
    // print("uid: $uid");
    // print("_uid: $_uid");
    final result = await _userRepository.fetchFollowing(
      uid: uid ?? _uid,
      lastUserFollowedAt: lastUserFollowedAt,
    );

    final futures = result.docs.map(
      (doc) async {
        if (uid == null || uid == _uid) {
          ref.read(isFollowingProvider.notifier).addFollowing(_uid);
        }
        return FollowDataModel.fromJson(
          json: doc.data(),
          userId: doc.id,
        );
      },
    ).toList();
    final users = await Future.wait(futures);

    return users;
  }

  Future<List<FollowDataModel>> fetchFollowers({
    String? uid,
    Timestamp? lastUserFollowedAt,
  }) async {
    final result = await _userRepository.fetchFollowers(
      uid: uid ?? _uid,
      lastUserFollowedAt: lastUserFollowedAt,
    );

    final users = result.docs.map(
      (doc) {
        return FollowDataModel.fromJson(
          json: doc.data(),
          userId: doc.id,
        );
      },
    ).toList();

    return users;
  }
 */
  @override
  FutureOr<List<FollowDataModel>> build() async {
    _authenticationRepository = ref.read(authRepo);
    _userRepository = ref.read(userRepo);
    _uid = _authenticationRepository.user!.uid;
    // _list = await fetchFollowing();
    _list = await fetchFollow(fetchType: FollowType.following);

    return _list;
  }

  Future<void> followUser(FollowDataModel userB) async {
    await _userRepository.followUser(
      FollowDataModel(
        uid: _uid,
        name: ref.read(usersProvider(null)).value!.name,
      ),
      userB,
    );
    ref.read(isFollowingProvider.notifier).addFollowing(userB.uid);
  }

  Future<void> unfollowUser(FollowDataModel userB) async {
    await _userRepository.unfollowUser(
      FollowDataModel(
        uid: _uid,
        name: ref.read(usersProvider(null)).value!.name,
      ),
      userB,
    );
    ref.read(isFollowingProvider.notifier).removeFollowing(userB.uid);
  }
}

final followProvider =
    AsyncNotifierProvider<FollowViewModel, List<FollowDataModel>>(
  () => FollowViewModel(),
);
