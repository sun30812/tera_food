import 'package:flutter_test/flutter_test.dart';
import 'package:tera_food/provider/restaurant_provider.dart';
import 'package:tera_food/types/food_kind.dart';
import 'package:tera_food/types/food_preference.dart';

/// [RestaurantProvider]의 기능을 검증하는 단위 테스트.
///
/// - 특정 음식 종류에 대한 음식점 목록 정상 반환여부
/// - 모든 음식점 목록 정상 반환여부
void main() {
  test('조건에 맞는 음식점 목록을 정상적으로 가져오는지 테스트', () async {
    RestaurantProvider provider = await RestaurantProvider.getSampleInstance();
    expect(provider
        .foods(FoodKind.etc)
        .first
        .foodKind, FoodKind.etc);
    expect(provider
        .foods(FoodKind.noodle)
        .first
        .foodKind, FoodKind.noodle);
  });

  test('모든 음식점 목록을 정상적으로 가져오는지 테스트', () async {
    RestaurantProvider provider = await RestaurantProvider.getSampleInstance();
    expect(provider
        .foods(FoodKind.all)
        .where((food) => food.foodKind == FoodKind.bread)
        .isNotEmpty, true);
    expect(provider
        .foods(FoodKind.all)
        .where((food) => food.foodKind == FoodKind.noodle)
        .isNotEmpty, true);
    expect(provider
        .foods(FoodKind.all)
        .where((food) => food.foodKind == FoodKind.etc)
        .isNotEmpty, true);
    expect(provider
        .foods(FoodKind.all)
        .where((food) => food.foodKind == FoodKind.rice)
        .isNotEmpty, true);
    expect(provider
        .foods(FoodKind.all)
        .where((food) => food.foodKind == FoodKind.soup)
        .isNotEmpty, true);
    expect(provider
        .foods(FoodKind.all)
        .where((food) => food.foodKind == FoodKind.salad)
        .isNotEmpty, true);
  });

  test('선호도 업데이트 기능이 정상적으로 작동하는지 테스트', () async {
    RestaurantProvider provider = await RestaurantProvider.getSampleInstance();
    final food = provider.foods(FoodKind.etc).first;
    expect(food.preference, FoodPreference.neutral);

    expect(provider.foods(FoodKind.etc, showOnlyFavorite: true), isEmpty);

    provider.updatePreference(food: food, preference: FoodPreference.like);
    expect(
      provider.foods(FoodKind.etc, showOnlyFavorite: true).first.preference,
      FoodPreference.like,
    );
  });
}
