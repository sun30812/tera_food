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

  static SettingsProvider? _instance;
  final SharedPreferences _pref;

  /// 앱에서 기본으로 표시할 음식점 종류를 설정한다.
  ///
  /// [foodKind]은 [FoodKind] 열거형의 값으로 전달되어야 한다.
  void setDefaultFoodKind(FoodKind foodKind) =>
      _pref.setString(_defaultFoodKindKey, foodKind.name);

  /// 앱에서 기본으로 표시할 음식점 종류를 반환한다.
  FoodKind getDefaultFoodKind() => FoodKind.values.byName(
    _pref.getString(_defaultFoodKindKey) ?? FoodKind.all.name,
  );

  static Future<SettingsProvider> getInstance() async =>
      SettingsProvider._instance ??
      SettingsProvider._internal(await SharedPreferences.getInstance());
}
