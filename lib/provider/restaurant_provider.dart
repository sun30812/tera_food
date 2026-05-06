import 'package:tera_food/provider/model/food.dart';
import 'package:tera_food/provider/settings_provider.dart';
import 'package:tera_food/types/food_kind.dart';
import 'package:tera_food/types/food_preference.dart';

/// 음식점 데이터를 비동기로 제공하는 provider 클래스.
///
/// [FoodKind]별 음식점 목록을 포함하는 데이터를 관리하며, 앱 전체에서 공유되는 싱글톤 인스턴스를 제공한다.
/// 인스턴스 초기화 필요 시 반드시 [getSampleInstance] 메서드를 통해 데이터를 초기화하여 인스턴스를 생성해야 한다.
class RestaurantProvider {
  RestaurantProvider._internal(this._foodData, this._defaultFoodKind);

  /// [Food]으로 작성된 음식점 목록을 [FoodKind]별로 매핑한 데이터.
  final Map<FoodKind, List<Food>>? _foodData;

  final FoodKind? _defaultFoodKind;

  static RestaurantProvider? _instance;

  FoodKind get defaultFoodKind => _defaultFoodKind ?? FoodKind.all;

  /// [foodKind]에 해당하는 음식점 목록을 [Food] 형으로 반환한다.
  ///
  /// 만일 모든 음식 종류를 의마하는 [FoodKind.all]이 전달되면 모든 음식점 목록을 하나의 리스트로 반환한다.
  List<Food> foods(FoodKind foodKind, {bool showOnlyFavorite = false}) {
    if (foodKind == FoodKind.all) {
      return _foodData?.values
              .expand((foods) => foods)
              .where(
                (food) =>
                    !showOnlyFavorite || food.preference == FoodPreference.like,
              )
              .toList() ??
          [];
    }
    return _foodData?[foodKind]
            ?.where(
              (food) =>
                  !showOnlyFavorite || food.preference == FoodPreference.like,
            )
            .toList() ??
        [];
  }

  /// 특정 음식점에 대한 선호도 정보를 업데이트한다.
  ///
  /// [food]에 해당하는 음식점의 선호도를 [preference]로 변경하여 업데이트한다.
  ///
  /// ## 참고
  /// - [Food]
  /// - [FoodPreference]
  void updatePreference({
    required Food food,
    required FoodPreference preference,
  }) {
    _foodData?.update(food.foodKind, (oldFoods) {
      List<Food> newFoods = [];

      for (final oldFood in oldFoods) {
        if (oldFood.foodName == food.foodName) {
          newFoods.add(oldFood.copyWith(preference: preference));
        } else {
          newFoods.add(oldFood);
        }
      }
      return newFoods;
    });
  }

  /// 싱글톤 인스턴스가 아직 생성되지 않은 경우, 데이터를 초기화하여 인스턴스를 생성한다.
  ///
  /// 해당 데이터는 Sample 이며, 추후 Firebase 를 이용하여 정보를 가져올 예정이다.
  static Future<RestaurantProvider> getSampleInstance() async {
    if (_instance == null) {
      final settingsProvider = await SettingsProvider.getInstance();
      final internalData = {
        FoodKind.noodle: [
          Food(foodName: "고스락 칼국수", foodKind: FoodKind.noodle),
          Food(foodName: "짬뽕혁명", foodKind: FoodKind.noodle),
          Food(foodName: "찐짜짬뽕", foodKind: FoodKind.noodle),
          Food(foodName: "퍼틴", foodKind: FoodKind.noodle),
          Food(foodName: "오한수우육명가", foodKind: FoodKind.noodle),
          Food(foodName: "큐슈울트라아멘", foodKind: FoodKind.noodle),
          Food(foodName: "오백국수", foodKind: FoodKind.noodle),
        ],
        FoodKind.rice: [
          Food(foodName: "진상", foodKind: FoodKind.rice),
          Food(foodName: "유쾌한 비빔밥", foodKind: FoodKind.rice),
          Food(foodName: "한솥 도시락", foodKind: FoodKind.rice),
          Food(foodName: "얌샘김밥", foodKind: FoodKind.rice),
          Food(foodName: "모모유부", foodKind: FoodKind.rice),
          Food(foodName: "한창회관", foodKind: FoodKind.rice),
          Food(foodName: "한끼의 정석 dine", foodKind: FoodKind.rice),
          Food(foodName: "정담은 한상", foodKind: FoodKind.rice),
          Food(foodName: "장금이한식뷔페", foodKind: FoodKind.rice),
        ],
        FoodKind.bread: [
          Food(foodName: "뉴욕 버거", foodKind: FoodKind.bread),
          Food(foodName: "목동버거", foodKind: FoodKind.bread),
          Food(foodName: "베이글 트리", foodKind: FoodKind.bread),
        ],
        FoodKind.soup: [
          Food(foodName: "본설렁탕", foodKind: FoodKind.soup),
          Food(foodName: "일품양평해장국", foodKind: FoodKind.soup),
          Food(foodName: "육수당", foodKind: FoodKind.soup),
          Food(foodName: "맑은곰탕", foodKind: FoodKind.soup),
          Food(foodName: "명백집", foodKind: FoodKind.soup),
          Food(foodName: "북촌손만두", foodKind: FoodKind.soup),
        ],
        FoodKind.salad: [
          Food(foodName: "샐러디", foodKind: FoodKind.salad),
          Food(foodName: "샐러드박스", foodKind: FoodKind.salad),
          Food(foodName: "포케올데이", foodKind: FoodKind.salad),
          Food(foodName: "주니아", foodKind: FoodKind.salad),
          Food(foodName: "죠샌드위치", foodKind: FoodKind.salad),
        ],
        FoodKind.etc: [Food(foodName: "CU", foodKind: FoodKind.etc),
          Food(foodName: "돈카춘", foodKind: FoodKind.etc),
          Food(foodName: "꽃찬 찜닭", foodKind: FoodKind.etc)
        ],
      };
      _instance = RestaurantProvider._internal(
          internalData, settingsProvider.getDefaultFoodKind());
    }
    return RestaurantProvider._instance!;
  }
}
