import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_w10_3th_x_clone/constants/enum.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/models/follow_data_model.dart';
import 'package:flutter_w10_3th_x_clone/features/users/models/user_profile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _strorage = FirebaseStorage.instance;
  final int _followUsersFetchLimit = 10;

  // create profile
  Future<void> createProfile(UserProfileModel profile) async {
    final newProfileRef = _db.collection("users").doc(profile.uid);
    await newProfileRef.set({
      ...profile.toJson(),
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  // get profile
  Future<Map<String, dynamic>?> findProfile(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    return doc.data();
  }

  // update profile
  // - update avatar
  // - update bio
  // - update

  // Upload Avatar
  Future<void> uploadAvatar(dynamic fileData, String fileName) async {
    final fileRef = _strorage.ref().child("avatars/$fileName");

    if (kIsWeb) {
      await fileRef.putData(fileData);
    } else {
      await fileRef.putFile(fileData as File);
    }
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).update(data);
  }

  Future<void> followUser(FollowDataModel userA, FollowDataModel userB) async {
    final query =
        _db.collection("following").doc("${userA.uid}000${userB.uid}");
    final following = await query.get();

    if (!following.exists) {
      await query.set({"followedAt": FieldValue.serverTimestamp()});
      // A유저의 followings 목록에 B유저 추가.
      // 이미 존재하는 경우는? 체크 필요.
      final queryA = _db
          .collection("users")
          .doc(userA.uid)
          .collection("following")
          .doc(userB.uid);

      await queryA.set({
        "name": userB.name,
        "followedAt": FieldValue.serverTimestamp(),
      });

      // B유저의 follower 목록에 A유저 추가.
      final queryB = _db
          .collection("users")
          .doc(userB.uid)
          .collection("followers")
          .doc(userA.uid);

      await queryB.set({
        "name": userA.name,
        "followedAt": FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> unfollowUser(
      FollowDataModel userA, FollowDataModel userB) async {
    final query =
        _db.collection("following").doc("${userA.uid}000${userB.uid}");
    final following = await query.get();

    if (following.exists) {
      await query.delete();

      // A유저의 followings 목록에서 B유저 제거.
      final queryA = _db
          .collection("users")
          .doc(userA.uid)
          .collection("following")
          .doc(userB.uid);

      await queryA.delete();

      // B유저의 follower 목록에서 A유저 제거.
      final queryB = _db
          .collection("users")
          .doc(userB.uid)
          .collection("followers")
          .doc(userA.uid);

      await queryB.delete();
    }
  }

//유저 A가 유저 B를 Following 하고 있는지 체크
  Future<bool> isFollowing(String userIdA, String userIdB) async {
    final query = _db.collection("following").doc("${userIdA}000$userIdB");
    final following = await query.get();
    return following.exists;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchFollow({
    required FollowType fetchType,
    required String uid,
    Timestamp? lastUserFollowedAt,
  }) async {
    final query = _db
        .collection("users")
        .doc(uid)
        .collection(
            fetchType == FollowType.followers ? "followers" : "following")
        .orderBy("followedAt", descending: true)
        .limit(_followUsersFetchLimit);

    if (lastUserFollowedAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastUserFollowedAt]).get();
    }
  }

/* 
  Future<QuerySnapshot<Map<String, dynamic>>> fetchFollowing({
    required String uid,
    Timestamp? lastUserFollowedAt,
  }) async {
    final query = _db
        .collection("users")
        .doc(uid)
        .collection("following")
        .orderBy("followedAt", descending: true)
        .limit(_followUsersFetchLimit);

    if (lastUserFollowedAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastUserFollowedAt]).get();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchFollowers({
    required String uid,
    Timestamp? lastUserFollowedAt,
  }) async {
    final query = _db
        .collection("users")
        .doc(uid)
        .collection("followers")
        .orderBy("followedAt", descending: true);

    if (lastUserFollowedAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastUserFollowedAt]).get();
    }
  }
 */
}

final userRepo = Provider(
  (ref) => UserRepository(),
);
