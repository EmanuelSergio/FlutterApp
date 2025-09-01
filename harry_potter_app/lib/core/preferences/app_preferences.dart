import 'package:hive_flutter/hive_flutter.dart';

abstract class AppPreferences {
  String? getSelectedHouse();
  Future<void> setSelectedHouse(String? house);

  String getSearchQuery();
  Future<void> setSearchQuery(String query);
}

class HiveAppPreferences implements AppPreferences {
  HiveAppPreferences();

  Box get _box => Hive.box('prefs');

  static const _kSelectedHouse = 'selected_house';
  static const _kSearchQuery = 'search_query';

  @override
  String? getSelectedHouse() => _box.get(_kSelectedHouse) as String?;

  @override
  Future<void> setSelectedHouse(String? house) async {
    if (house == null || house.isEmpty) {
      await _box.delete(_kSelectedHouse);
    } else {
      await _box.put(_kSelectedHouse, house);
    }
  }

  @override
  String getSearchQuery() => (_box.get(_kSearchQuery) as String?) ?? '';

  @override
  Future<void> setSearchQuery(String query) async =>
      _box.put(_kSearchQuery, query);
}
