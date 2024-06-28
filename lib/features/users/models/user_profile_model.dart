import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  final String uid;
  final String email;
  final String name;
  final String bio;
  final String link;
  final bool hasAvatar;
  final Timestamp? createdAt;
  int following;
  int followers;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.bio,
    required this.link,
    required this.hasAvatar,
    this.createdAt,
    required this.following,
    required this.followers,
  });

  UserProfileModel.empty()
      : uid = "",
        email = "",
        name = "",
        bio = "",
        link = "",
        hasAvatar = false,
        createdAt = null,
        following = 0,
        followers = 0;

  UserProfileModel.fromJson({
    required Map<String, dynamic> json,
    required String uid,
  })  : uid = json["uid"],
        email = json["email"],
        name = json["name"],
        bio = json["bio"],
        link = json["link"],
        hasAvatar = json["hasAvatar"] ?? false,
        createdAt = json["createdAt"],
        following = json["following"] ?? 0,
        followers = json["followers"] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "bio": bio,
      "link": link,
      "hasAvatar": hasAvatar,
      "createdAt": createdAt,
      "following": following,
      "followers": followers,
    };
  }

  UserProfileModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? bio,
    String? link,
    bool? hasAvatar,
    bool? isMine,
    Timestamp? createdAt,
    int? following,
    int? followers,
  }) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      link: link ?? this.link,
      hasAvatar: hasAvatar ?? this.hasAvatar,
      createdAt: createdAt ?? this.createdAt,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }
}
