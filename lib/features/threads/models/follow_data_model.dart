import 'package:cloud_firestore/cloud_firestore.dart';

class FollowDataModel {
  String uid;
  String name;
  Timestamp? followedAt;

  FollowDataModel({
    required this.uid,
    required this.name,
    this.followedAt,
  });

  FollowDataModel.fromJson({
    required Map<String, dynamic> json,
    required String userId,
    bool? isFollowing,
  })  : uid = userId,
        name = json["name"],
        followedAt = json["followedAt"];

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
    };
  }
}
