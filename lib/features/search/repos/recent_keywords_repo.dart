import 'package:shared_preferences/shared_preferences.dart';

class RecentKeywordsRepository {
  static const String _recentSearchKeywords = "_recentSearchKeywords";

  final SharedPreferences _preferences;

  RecentKeywordsRepository(this._preferences);

  Future<void> setRecentKeywords(List<String> keywords) async {
    //enum 을 index로 다루는 방법
    await _preferences.setStringList(_recentSearchKeywords, keywords);
  }

  List<String> getRecentKeywords() {
    return _preferences.getStringList(_recentSearchKeywords) ?? [];
  }
}
