import 'dart:async';

import 'package:flutter_w10_3th_x_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/models/thread_actions_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/models/thread_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/repos/threads_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 로그인, 로그아웃시 family providers 를 모두 invalidate 하기 위한 용도.
final List<String> threadActionsFamilyArguments = [];

class ThreadActionsViewModel
    extends FamilyAsyncNotifier<ThreadActionsModel, String> {
  late ThreadsRepository _threadsRepository;
  late AuthenticationRepository _authenticationRepository;

  late String _threadId;
  bool _isLiked = false;
  List<ThreadModel> _commentList = [];

  @override
  FutureOr<ThreadActionsModel> build(String arg) async {
    _threadId = arg;
    _threadsRepository = ref.read(threadsRepo);
    _authenticationRepository = ref.read(authRepo);

    _isLiked = await _isLikedThread();
    if (!threadActionsFamilyArguments.contains(_threadId)) {
      threadActionsFamilyArguments.add(_threadId);
    }
    // print(threadActionsFamilyArguments.length);
    return ThreadActionsModel(isLiked: _isLiked);
  }

  void addFakeComment(ThreadModel newThread) {
    _commentList.add(newThread);
    state = const AsyncValue.loading();
    state = AsyncValue.data(ThreadActionsModel(
      isLiked: _isLiked,
      comments: _commentList,
    ));
  }

  Future<void> likeThread() async {
    final user = _authenticationRepository.user;
    _isLiked = !_isLiked;
    state = AsyncValue.data(ThreadActionsModel(isLiked: _isLiked));
    await _threadsRepository.likeThread(_threadId, user!.uid);
  }

  Future<bool> _isLikedThread() async {
    final user = _authenticationRepository.user;
    return _threadsRepository.isLikedThread(_threadId, user!.uid);
  }

  Future<void> refresh() async {
    _isLiked = await _isLikedThread();
    fetchComments();
  }

  Future<List<ThreadModel>> fetchComments() async {
    // if (state.value?.comments != null) return state.value!.comments!;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        final result = await _threadsRepository.fetchComments(_threadId);
        final user = _authenticationRepository.user;

        if (result.docs.isNotEmpty) {
          _commentList = result.docs.map(
            (doc) {
              return ThreadModel.fromJson(
                json: doc.data(),
                uid: user?.uid,
              );
            },
          ).toList();
          return ThreadActionsModel(
            isLiked: _isLiked,
            comments: _commentList,
          );
        } else {
          return ThreadActionsModel(
            isLiked: _isLiked,
            comments: [],
          );
        }
      },
    );
    print("_commentList: $_commentList");
    return _commentList;
  }
}

final threadActionsProvider = AsyncNotifierProvider.family<
    ThreadActionsViewModel, ThreadActionsModel, String>(
  () => ThreadActionsViewModel(),
);
