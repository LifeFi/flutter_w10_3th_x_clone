import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/models/thread_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/repos/threads_repo.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchViewModel extends AsyncNotifier<List<ThreadModel>> {
  late ThreadsRepository _threadsRepository;
  late AuthenticationRepository _authenticationRepository;
  late String? _uid;
  List<ThreadModel> _list = [];
  String _lastSearchKeyword = "";
  bool _isLastSearchNext = false;
  late QueryDocumentSnapshot<Map<String, dynamic>>?
      _lastItemQueryDocumnetSnapshot;

  @override
  FutureOr<List<ThreadModel>> build() {
    _threadsRepository = ref.read(threadsRepo);
    _authenticationRepository = ref.read(authRepo);
    _uid = _authenticationRepository.user?.uid;

    return _list;
  }

  Future<List<ThreadModel>> searchThreads(
      BuildContext context, String keyword) async {
    _isLastSearchNext = false;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await _threadsRepository.searchThreads(
        keyword: keyword,
        lastItemQueryDocumnetSnapshot: null,
      );
      _lastItemQueryDocumnetSnapshot = result.docs.last;

      final threads = result.docs.map(
        (doc) {
          return ThreadModel.fromJson(
            json: doc.data(),
            uid: _uid,
          );
        },
      ).toList();
      if (threads.isNotEmpty) {
        threads.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      }

      _list = threads;
      return _list;
    });
    if (state.hasError && context.mounted) {
      showFirebaseErrorSnack(context, state.error);
    }
    _lastSearchKeyword = keyword;
    print("_lastSearchKeyword: $_lastSearchKeyword");
    print(_list.length);
    return _list;
  }

  Future<List<ThreadModel>> searchNextThreads(String keyword) async {
    print(_list.length);
    if (_isLastSearchNext) return _list;
    if (_lastSearchKeyword != keyword) {
      _list = [];
      _lastItemQueryDocumnetSnapshot = null;
      _isLastSearchNext = false;
    }
    print(_list.length);

    final result = await _threadsRepository.searchThreads(
      keyword: keyword,
      lastItemQueryDocumnetSnapshot: _lastItemQueryDocumnetSnapshot,
    );

    if (result.docs.isNotEmpty) {
      _lastItemQueryDocumnetSnapshot = result.docs.last;

      final threads = result.docs.map(
        (doc) {
          return ThreadModel.fromJson(
            json: doc.data(),
            uid: _uid,
          );
        },
      ).toList();

      threads.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      _list = [..._list, ...threads];
      state = AsyncValue.data(_list);
    } else {
      _isLastSearchNext = true;
    }

    _lastSearchKeyword = keyword;
    // print("_lastSearchKeyword: $_lastSearchKeyword");
    // print(_list.length);
    return _list;
  }
}

final searchProvider =
    AsyncNotifierProvider<SearchViewModel, List<ThreadModel>>(
  () => SearchViewModel(),
);
