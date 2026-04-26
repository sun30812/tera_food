import 'package:tera_food/types/food_kind.dart';

class RestaurantProvider {
  RestaurantProvider._internal(this.data);

  final Map<FoodKind, List<String>>? data;

  static RestaurantProvider? _instance;

  List<String> foods(FoodKind foodKind) => data?[foodKind] ?? [];

  static Future<RestaurantProvider> getInstance() async {
    if (_instance == null) {
      await Future.delayed(const Duration(seconds: 2)); // 예시로 1초 지연
      final internalData = {
        FoodKind.noodle: ["고스락 칼국수", "고기짬뽕", "찐짜짬뽕", "큐슈울트라아멘"],
        FoodKind.rice: ["진상", "한솥 도시락", "정담은 한상"],
        FoodKind.bread: ["뉴욕 버거", "목동버거", "베이글 트리"],
        FoodKind.soup: ["본설렁탕", "양평해장국", "명백집"],
        FoodKind.salad: ["샐러디", "포케올데이"],
        FoodKind.etc: ["CU"],
      };
      _instance = RestaurantProvider._internal(internalData);
    }
    return RestaurantProvider._instance!;
  }
}
