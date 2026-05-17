import 'package:shared_preferences/shared_preferences.dart';
import 'package:tera_food/types/food_kind.dart';

/// 앱의 전반적인 설정을 관리하는 provider 클래스.
///
/// 앱 전체에서 공유되는 싱글톤 인스턴스를 제공하며, 앱의 설정 데이터를 관리한다. 현재는 기본 음식점 종류 설정을 관리하는 기능을 제공한다.
/// 인스턴스 사용을 위해서는 반드시 [getInstance] 메서드를 통해 인스턴스를 초기화하여 사용해야 한다.
class SettingsProvider {
  SettingsProvider._internal(this._pref);

  // 음식점 종류 설정 관리용 키
  static const String _defaultFoodKindKey = 'default_food_kind';

  // 즐겨찾는 음식점 목록 키
  static const String _favoriteFoodKey = 'favorite_food_names';

  static SettingsProvider? _instance;
  final SharedPreferences _pref;

  /// 앱에서 기본으로 표시할 음식점 종류를 설정한다.
  ///
  /// [foodKind]은 [FoodKind] 열거형의 값으로 전달되어야 한다.
  void setDefaultFoodKind(FoodKind foodKind) =>
      _pref.setString(_defaultFoodKindKey, foodKind.name);

  /// 즐겨찾는 음식점 목록을 업데이트 한다.
  ///
  /// [foodNames]를 통해 전달된 음식점 이름들의 목록을 즐겨찾기 설정 저장소에 저장한다.
  void updateFavoriteFoodList(Set<String> foodNames) =>
      _pref.setStringList(_favoriteFoodKey, foodNames.toList());

  /// 줄겨찾는 음식점 목록을 초기화 한다.
  ///
  /// 저장소에 등록된 즐겨찾는 음식점 목록에 대한 데이터를 삭제한다.
  void resetFavoriteFoodList() => _pref.remove(_favoriteFoodKey);

  /// 즐겨찾는 음식점 목록을 저장소에서 가져와 반환한다.
  Set<String> getFavoriteFoodList() =>
      _pref.getStringList(_favoriteFoodKey)?.toSet() ?? {};

  /// 앱에서 기본으로 표시할 음식점 종류를 반환한다.
  FoodKind getDefaultFoodKind() => FoodKind.values.byName(
    _pref.getString(_defaultFoodKindKey) ?? FoodKind.all.name,
  );

  /// [SettingsProvider] 의 인스턴스를 초기화 하는 정적 메서드이다.
  ///
  /// 이미 인스턴스 존재 시 존재하는 인스턴스를 반환하며, 없을 시 인스턴스를 새로 생성한다.
  static Future<SettingsProvider> getInstance() async =>
      SettingsProvider._instance ??
      SettingsProvider._internal(await SharedPreferences.getInstance());
}
