import 'package:cloud_firestore/cloud_firestore.dart';

class ThreadModel {
  String id;
  String creatorUid;
  String creator;
  String content;
  List<String> images;
  Timestamp? createdAt;
  String commentOf;
  List<CommentModel> comments;
  int likes;
  int replies;
  bool? isMine;

  ThreadModel({
    required this.id,
    required this.creatorUid,
    required this.creator,
    required this.content,
    required this.images,
    this.createdAt,
    required this.commentOf,
    required this.comments,
    required this.likes,
    required this.replies,
    this.isMine,
  });

  ThreadModel.fromJson({
    required Map<String, dynamic> json,
    String? uid,
  })  : id = json["id"],
        creatorUid = json["creatorUid"],
        creator = json["creator"],
        content = json["content"],
        images = json["images"] != null && json["images"].length != 0
            ? (json["images"] as List)
                .map(
                  (image) => image.toString(),
                )
                .toList()
            : [],
        createdAt = json["createdAt"],
        commentOf = json["commentOf"] ?? "",
        comments = json["comments"] != null && json["comments"].length != 0
            ? (json["comments"] as List).map((comment) {
                return CommentModel.fromJson(json: comment);
              }).toList()
            : [],
        likes = json["likes"],
        replies = json["replies"],
        isMine = uid != null ? json["creatorUid"] == uid : false;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "creatorUid": creatorUid,
      "creator": creator,
      "content": content,
      "images": images,
      "createdAt": createdAt,
      "commentOf": commentOf,
      "comments": comments != []
          ? comments.map((comment) => comment.toJson()).toList()
          : [],
      "likes": likes,
      "replies": replies,
    };
  }

  ThreadModel copyWith({
    String? id,
    String? creatorUid,
    String? creator,
    String? content,
    List<String>? images,
    Timestamp? createdAt,
    String? commentOf,
    List<CommentModel>? comments,
    int? likes,
    int? replies,
    bool? isMine,
  }) {
    return ThreadModel(
      id: id ?? this.id,
      creatorUid: creatorUid ?? this.creatorUid,
      creator: creator ?? this.creator,
      content: content ?? this.content,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      commentOf: commentOf ?? this.commentOf,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
      replies: replies ?? this.replies,
      isMine: isMine ?? this.isMine,
    );
  }
}

class CommentModel {
  String id;
  String creatorUid;
  String creator;
  String content;
  Timestamp? createdAt;

  CommentModel({
    required this.id,
    required this.creatorUid,
    required this.creator,
    required this.content,
    this.createdAt,
  });

  CommentModel.fromJson({
    required Map<String, dynamic> json,
  })  : id = json["id"],
        creatorUid = json["creatorUid"],
        creator = json["creator"],
        content = json["content"],
        createdAt = json["createdAt"];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "creatorUid": creatorUid,
      "creator": creator,
      "content": content,
      "createdAt": createdAt,
    };
  }
}
