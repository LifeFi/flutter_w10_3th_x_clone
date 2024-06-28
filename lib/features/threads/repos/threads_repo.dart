import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/models/thread_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThreadsRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final int _fetchThreadsLimit = 10;
  final int _searchThreadsLimit = 5;

  Future<QuerySnapshot<Map<String, dynamic>>> fetchThreads({
    String? uid,
    Timestamp? lastItemCreatedAt,
  }) async {
    // print("fetchThreads: $uid");
    // await Future.delayed(const Duration(seconds: 2));
    Query<Map<String, dynamic>> query;

    if (uid == null) {
      query = _db
          .collection("threads")
          .where("commentOf", isEqualTo: "")
          .orderBy("createdAt", descending: true)
          .limit(_fetchThreadsLimit);
    } else {
      query = _db
          .collection("threads")
          .where("commentOf", isEqualTo: "")
          .where("creatorUid", isEqualTo: uid)
          .orderBy("createdAt", descending: true)
          .limit(_fetchThreadsLimit);
    }
    if (lastItemCreatedAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastItemCreatedAt]).get();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchComments(
      String threadId) async {
    final query = _db
        .collection("threads")
        .where("commentOf", isEqualTo: threadId)
        .orderBy("createdAt", descending: false);

    final result = await query.get();
    // print("result @repo: $result");
    return result;
  }

  Future<String> postThread(ThreadModel data) async {
    final newPostRef = _db.collection("threads").doc();

    await newPostRef.set({
      ...data.toJson(),
      "createdAt": FieldValue.serverTimestamp(),
      "id": newPostRef.id,
    });
    return newPostRef.id;
  }

  Future<List<String>> uploadImageFiles(
      List<dynamic> images, String uid) async {
    List<String> downloadUrls = [];

    for (int index = 0; index < images.length; index++) {
      String fileName;
      UploadTask uploadTask;

      if (kIsWeb) {
        fileName = "000$index";
        print("fileName: $fileName");
      } else {
        fileName = images[index].path.split('/').last;
      }

      final fileRef = _storage.ref().child(
            "threads/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}$fileName",
          );
      print("fileRef: $fileRef");

      if (kIsWeb) {
        print("before uploadTask");
        uploadTask = fileRef.putData(images[index]);
        // await fileRef.putData(images[index] as Uint8List);
        print("await done!");
        // print("uploadTask: $uploadTask");
      } else {
        uploadTask = fileRef.putFile(images[index] as File);
      }

      await uploadTask.then((res) async {
        print("res: $res");
        if (res.metadata != null) {
          String downloadUrl = await res.ref.getDownloadURL();
          print(downloadUrl);
          downloadUrls.add(downloadUrl);
          print(downloadUrls);
        }
      });
    }
    print("downloadUrls: $downloadUrls");
    return downloadUrls;
  }

  Future<void> likeThread(String threadId, String uid) async {
    final query = _db.collection("likes").doc("${threadId}000$uid");
    final like = await query.get();

    if (!like.exists) {
      await query.set(
        {
          "createdAt": FieldValue.serverTimestamp(),
        },
      );
    } else {
      await query.delete();
    }
  }

  Future<bool> isLikedThread(String threadId, String uid) async {
    final query = _db.collection("likes").doc("${threadId}000$uid");
    final like = await query.get();

    if (like.exists) return true;
    return false;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> searchThreads({
    required String keyword,
    QueryDocumentSnapshot<Map<String, dynamic>>? lastItemQueryDocumnetSnapshot,
  }) async {
    print(keyword);
    // 이슈 사항
    // - 대소문자 구분되어 저장되는 것을 고려해야 함.
    // - 단어로 시작되는 것만 찾고 있음. 단어로 끝나는 것도 찾아야 함. / 파이어스토어 지원 안한다고 함.
    //
    // 해결 방법 후보
    // - 검색하고자 하는 필드를, 소문자로 변환해서 검색용으로 중복해서 저장해둔다.
    // - 키워드를 추출해서, 검색용 배열로 만들어 둔다. "keyword": ["사과", "바나나", "좋아"]
    // - 해시태그를 유저들이 적극적으로 활용하게 유도한다.
    // - 등
    //
    // tre - catch
    // try {}
    // catch (e) {
    //  if (e is FirebaseException) {
    //  }
    //  else {
    //    print("An error occurred: $e");
    //  }
    // }
    try {
      final query = _db
          .collection("threads")
          .where("content", isGreaterThanOrEqualTo: keyword)
          .where('content', isLessThan: '$keyword\uf8ff')
          .orderBy("content")
          // where 에 >, >=, <, <= 등의 조건을 사용한 경우
          // 1. 첫번째 orderby 에 where 와 같은 field 를 넣어야 한다고 함.
          // 2. where 에, 복합 field 사용은 안된다고 함.
          // .orderBy("createdAt", descending: true)
          .limit(_searchThreadsLimit);
    } catch (e) {
      if (e is FirebaseException) {
        print("FirebaseException Caught: ${e.message}");
      } else {
        print(e);
      }
    }

    final query = _db
        .collection("threads")
        .where("content", isGreaterThanOrEqualTo: keyword)
        .where('content', isLessThan: '$keyword\uf8ff')
        .orderBy("content")
        // where 에 >, >=, <, <= 등의 조건을 사용한 경우
        // 1. 첫번째 orderby 에 where 와 같은 field 를 넣어야 한다고 함.
        // 2. where 에, 복합 field 사용은 안된다고 함.
        // .orderBy("createdAt", descending: true)
        // .where(
        //   "createdAt",
        //   isLessThanOrEqualTo: FieldValue.serverTimestamp(),
        // )
        // .orderBy("createdAt", descending: true)
        .limit(_searchThreadsLimit);

    print("lastItemQueryDocumnetSnapshot: $lastItemQueryDocumnetSnapshot");
    if (lastItemQueryDocumnetSnapshot == null) {
      return query.get();
    } else {
      return query.startAfterDocument(lastItemQueryDocumnetSnapshot).get();
    }
  }
}

final threadsRepo = Provider((ref) => ThreadsRepository());

/* List<Map<String, dynamic>> data = [
    for (var i = 0; i < 20; i++)
      {
        "id": random.integer(1000000).toString(),
        "creatorUid": random.integer(1000000),
        "creator": faker.person.name(),
        "content": faker.lorem.sentence(),
        "images": [],
        "createdAt": Timestamp.now(),
        "comments": [],
        "likes": random.integer(1000),
        "replies": random.integer(1000),
        "isMine": false,
      }
  ]; */
