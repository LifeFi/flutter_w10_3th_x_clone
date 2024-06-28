import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/models/thread_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/repos/threads_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThreadsViewModel extends FamilyAsyncNotifier<List<ThreadModel>, String?> {
  late ThreadsRepository _threadsRepository;
  late AuthenticationRepository _authenticationRepository;
  late String? _uid;

  List<ThreadModel> _list = [];

  Future<List<ThreadModel>> _fetchThreads({
    String? uid,
    Timestamp? lastItemCreatedAt,
  }) async {
    final result = await _threadsRepository.fetchThreads(
      uid: uid,
      lastItemCreatedAt: lastItemCreatedAt,
    );
    final user = _authenticationRepository.user;

    final threads = result.docs.map(
      (doc) {
        return ThreadModel.fromJson(
          json: doc.data(),
          uid: user?.uid,
        );
      },
    ).toList();

    return threads;
  }

  Future<void> fetchNextItems() async {
    // await Future.delayed(const Duration(seconds: 2));
    if (_list.isEmpty) return;
    final nextItems =
        await _fetchThreads(uid: _uid, lastItemCreatedAt: _list.last.createdAt);
    _list = [..._list, ...nextItems];
    state = AsyncValue.data(_list);
  }

  void addFakeThread(ThreadModel newThread) {
    _list.insert(0, newThread);
    state = AsyncValue.data(_list);
  }

  @override
  FutureOr<List<ThreadModel>> build(String? arg) async {
    _threadsRepository = ref.read(threadsRepo);
    _authenticationRepository = ref.read(authRepo);
    _uid = arg;
    _list = await _fetchThreads(uid: _uid, lastItemCreatedAt: null);

    return _list;
  }

  Future<void> refresh() async {
    // state = const AsyncValue.loading();
    _list = await _fetchThreads(uid: _uid, lastItemCreatedAt: null);
    state = AsyncValue.data(_list);
  }
}

final threadsProvider =
    AsyncNotifierProvider.family<ThreadsViewModel, List<ThreadModel>, String?>(
  () => ThreadsViewModel(),
);
