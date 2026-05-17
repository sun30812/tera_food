import 'package:tera_food/provider/model/food.dart';
import 'package:tera_food/provider/settings_provider.dart';
import 'package:tera_food/types/food_kind.dart';
import 'package:tera_food/types/food_preference.dart';

/// 음식점 데이터를 비동기로 제공하는 provider 클래스.
///
/// [FoodKind]별 음식점 목록을 포함하는 데이터를 관리하며, 앱 전체에서 공유되는 싱글톤 인스턴스를 제공한다.
/// 인스턴스 초기화 필요 시 반드시 [getSampleInstance] 메서드를 통해 데이터를 초기화하여 인스턴스를 생성해야 한다.
class RestaurantProvider {
  RestaurantProvider._internal(this._foodData, this._settingsProvider) {
    _favoriteFoodNames = _settingsProvider?.getFavoriteFoodList() ?? {};
  }

  /// [Food]으로 작성된 음식점 목록을 [FoodKind]별로 매핑한 데이터.
  final Map<FoodKind, List<Food>>? _foodData;

  final SettingsProvider? _settingsProvider;

  late final Set<String> _favoriteFoodNames;

  static RestaurantProvider? _instance;

  FoodKind get defaultFoodKind =>
      _settingsProvider?.getDefaultFoodKind() ?? FoodKind.all;

  /// [foodKind]에 해당하는 음식점 목록을 [Food] 형으로 반환한다.
  ///
  /// 만일 모든 음식 종류를 의미하는 [FoodKind.all]이 전달되면 모든 음식점 목록을 하나의 리스트로 반환한다.
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
    if (preference == FoodPreference.like) {
      _favoriteFoodNames.add(food.foodName);
    } else {
      _favoriteFoodNames.remove(food.foodName);
    }

    _foodData?.update(food.foodKind, (oldFoods) {
      List<Food> newFoods = [];

      for (final oldFood in oldFoods) {
        if (oldFood.foodName == food.foodName) {
          newFoods.add(oldFood.copyWith(preference: preference));
        } else {
          newFoods.add(oldFood);
        }
      }
      _settingsProvider?.updateFavoriteFoodList(_favoriteFoodNames);
      return newFoods;
    });
  }

  /// 싱글톤 인스턴스가 아직 생성되지 않은 경우, 데이터를 초기화하여 인스턴스를 생성한다.
  ///
  /// 해당 데이터는 Sample 이며, 추후 Firebase 를 이용하여 정보를 가져올 예정이다.
  /// [skipInitializeSettingsProvider]가 true로 설정되면 [SettingsProvider]의 인스턴스 초기화를 건너뛴다.
  /// 이는 테스트 시 [SettingsProvider]의 초기화가 필요 없는 경우에 유용하다.
  static Future<RestaurantProvider> getSampleInstance(
      {bool skipInitializeSettingsProvider = false}) async {
    if (_instance == null) {
      final settingsProvider = !skipInitializeSettingsProvider
          ? await SettingsProvider.getInstance()
          : null;
      final favoriteFoodNames = settingsProvider?.getFavoriteFoodList() ?? {};

      FoodPreference preferenceOf(String foodName) {
        return favoriteFoodNames.contains(foodName)
            ? FoodPreference.like
            : FoodPreference.neutral;
      }

      Food food(FoodKind foodKind, String foodName) {
        return Food(
          foodName: foodName,
          foodKind: foodKind,
          preference: preferenceOf(foodName),
        );
      }

      final foodNamesByKind = {
        FoodKind.noodle: [
          "고스락 칼국수",
          "짬뽕혁명",
          "찐짜짬뽕",
          "퍼틴",
          "오한수우육명가",
          "큐슈울트라아멘",
          "오백국수",
        ],
        FoodKind.rice: [
          "진상",
          "유쾌한 비빔밥",
          "한솥 도시락",
          "얌샘김밥",
          "모모유부",
          "한창회관",
          "한끼의 정석 dine",
          "정담은 한상",
          "장금이한식뷔페",
          "나드리김밥"
        ],
        FoodKind.bread: [
          "뉴욕 버거",
          "목동버거",
          "베이글 트리",
        ],
        FoodKind.soup: [
          "본설렁탕",
          "일품양평해장국",
          "육수당",
          "맑은곰탕",
          "명백집",
          "북촌손만두",
          "송탄부대찌개",
          "자래순두부",
        ],
        FoodKind.salad: [
          "샐러디",
          "샐러드박스",
          "포케올데이",
          "주니아",
          "죠샌드위치",
          "파리바게트",
          "뚜레주르"
        ],
        FoodKind.etc: [
          "CU",
          "돈카춘",
          "꽃찬 찜닭",
        ],
      };

      final internalData = foodNamesByKind.map(
            (foodKind, foodNames) =>
            MapEntry(
              foodKind,
              foodNames.map((foodName) => food(foodKind, foodName)).toList(),
            ),
      );

      _instance = RestaurantProvider._internal(
          internalData, settingsProvider);
    }
    return RestaurantProvider._instance!;
  }
}
