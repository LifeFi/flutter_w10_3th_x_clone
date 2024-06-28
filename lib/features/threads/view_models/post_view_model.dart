import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/view_models/thread_actions_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/users/view_models/users_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/models/thread_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/repos/threads_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/view_models/threads_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostViewModel extends AsyncNotifier<void> {
  late final ThreadsRepository _threadsRepository;

  @override
  FutureOr<void> build() {
    _threadsRepository = ref.read(threadsRepo);
    // _usersRepository = ref.read(userRepo);
    // _authenticationRepository = ref.read(authRepo);
  }

  Future<String> postThread({
    required String content,
    required List<dynamic> images,
    String commentOf = "",
  }) async {
    final user = ref.read(usersProvider(null)).value;
    String docId = "";

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (user == null) return;

      List<String> imageUrls;
      if (kIsWeb) {
        // 이미지 repo 로 넘어 갔을때, Future 가 넘어가면서 계속 결과가 안나오는 문제가 있었음.
        // await Future.wait(futures)를 사용하여, 확실하게 값을 받아서 넘겨줘 해결함.
        final futures =
            images.map((xfile) async => await xfile.readAsBytes()).toList();
        final fileDataList = await Future.wait(futures);

        // print("fileDataList: $fileDataList");
        imageUrls =
            await _threadsRepository.uploadImageFiles(fileDataList, user.uid);
      } else {
        final fileList = images.map((xfile) => File(xfile.path)).toList();
        imageUrls =
            await _threadsRepository.uploadImageFiles(fileList, user.uid);
      }

      // print(imageUrls);
      final newThread = ThreadModel(
        id: "",
        creatorUid: user.uid,
        creator: user.name,
        content: content,
        images: imageUrls,
        commentOf: commentOf,
        comments: [],
        likes: 0,
        replies: 0,
      );
      docId = await _threadsRepository.postThread(newThread);
      print("commentOf: $commentOf");
      if (commentOf != "") {
        ref
            .read(threadActionsProvider(commentOf).notifier)
            .addFakeComment(newThread.copyWith(
              id: docId,
              isMine: true,
              createdAt: Timestamp.now(),
            ));
      } else {
        ref
            .read(threadsProvider(null).notifier)
            .addFakeThread(newThread.copyWith(
              id: docId,
              isMine: true,
              createdAt: Timestamp.now(),
            ));
        ref
            .read(threadsProvider(newThread.creatorUid).notifier)
            .addFakeThread(newThread.copyWith(
              id: docId,
              isMine: true,
              createdAt: Timestamp.now(),
            ));
      }

      return;
    });

    // ref.read(threadsProvider(null).notifier).refresh();
    return docId;
  }
}

final postThreadProvider = AsyncNotifierProvider<PostViewModel, void>(
  () => PostViewModel(),
);
