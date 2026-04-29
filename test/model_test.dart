import 'package:flutter_test/flutter_test.dart';
import 'package:tera_food/provider/restaurant_provider.dart';
import 'package:tera_food/types/food_kind.dart';

/// [RestaurantProvider]의 기능을 검증하는 단위 테스트.
///
/// - 특정 음식 종료에 대한 음식점 목록 정상 반환여부
/// - 모든 음식점 목록 정상 반환여부
void main() {
 test('조건에 맞는 음식점 목록을 정상적으로 가져오는지 테스트', () async {
  RestaurantProvider provider = await RestaurantProvider.getSampleInstance();
  expect(provider.foods(FoodKind.etc).first.foodName, 'CU');
  expect(provider.foods(FoodKind.etc).length, 1);
 }) ;

 test('모든 음식점 목록을 정상적으로 가져오는지 테스트', () async {
  RestaurantProvider provider = await RestaurantProvider.getSampleInstance();
  expect(provider.foods(FoodKind.all).any((element) => element.foodName == 'CU'), true);
  expect(provider.foods(FoodKind.all).any((element) => element.foodName == 'CU'),true);
  expect(provider.foods(FoodKind.all).any((element) => element.foodName == '한솥 도시락'), true);
  expect(provider.foods(FoodKind.all).any((element) => element.foodName == '고스락 칼국수'), true);
  expect(provider.foods(FoodKind.all).any((element) => element.foodName == '뉴욕 버거'), true);
  expect(provider.foods(FoodKind.all).any((element) => element.foodName == '명백집'), true);
  expect(provider.foods(FoodKind.all).any((element) => element.foodName == '포케올데이'), true);
 }) ;
}