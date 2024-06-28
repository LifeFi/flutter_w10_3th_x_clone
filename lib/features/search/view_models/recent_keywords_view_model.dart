import 'package:flutter_w10_3th_x_clone/features/search/repos/recent_keywords_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentKeywordsViewModel extends Notifier<List<String>> {
  final RecentKeywordsRepository _repository;
  late List<String> _list;

  RecentKeywordsViewModel(this._repository);

  @override
  List<String> build() {
    _list = _repository.getRecentKeywords();
    print("build!!");
    return _list;
  }

  void addKeyword(String newKeyword) {
    _list.insert(0, newKeyword);
    _repository.setRecentKeywords(_list);
    state = [..._list];
    print("added!!");
  }

  void removeKeyword(String keyword) {
    _list.remove(keyword);
    _repository.setRecentKeywords(_list);
    state = [..._list];
  }

  void removeAllKeywords() {
    _list.clear();
    _repository.setRecentKeywords(_list);
    state = [];
  }
}

final recentKeywordsProvider =
    NotifierProvider<RecentKeywordsViewModel, List<String>>(
  // main.dart 에서 override
  () => throw UnimplementedError(),
);
