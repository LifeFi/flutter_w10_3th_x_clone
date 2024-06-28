import 'package:flutter_riverpod/flutter_riverpod.dart';

class HasAvatarViewModel extends Notifier<void> {
  late List<String> _hasNoAvatarList;

  @override
  void build() {
    _hasNoAvatarList = [];
  }

  void addHasNoAvatar(String uid) {
    if (_hasNoAvatarList.contains(uid)) return;
    _hasNoAvatarList.add(uid);
  }

  void removeHasNoAvatar(String uid) {
    if (!_hasNoAvatarList.contains(uid)) return;
    _hasNoAvatarList.remove(uid);
  }

  bool hasAvatar(String uid) {
    if (_hasNoAvatarList.contains(uid)) return false;
    return true;
  }
}

final hasAvatarProvider = NotifierProvider<HasAvatarViewModel, void>(
  () => HasAvatarViewModel(),
);
