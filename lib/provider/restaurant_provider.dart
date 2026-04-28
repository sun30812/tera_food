import 'package:tera_food/types/food_kind.dart';

/// 음식점 데이터를 비동기로 제공하는 provider 클래스.
///
/// [FoodKind]별 음식점 목록을 포함하는 데이터를 관리하며, 앱 전체에서 공유되는 싱글톤 인스턴스를 제공한다.
class RestaurantProvider {
  RestaurantProvider._internal(this.data);

  final Map<FoodKind, List<String>>? data;

  static RestaurantProvider? _instance;

  /// [FoodKind]에 해당하는 음식점 목록을 반환한다.
  ///
  /// 만일 모든 음식 종류를 의마하는 [FoodKind.all]이 전달되면 모든 음식점 목록을 하나의 리스트로 반환한다.
  List<String> foods(FoodKind foodKind) {
    if (foodKind == FoodKind.all) {
      return data?.values.expand((food) => food).toList() ?? [];
    }
    return data?[foodKind] ?? [];
  }

  /// 싱글톤 인스턴스가 아직 생성되지 않은 경우, 데이터를 초기화하여 인스턴스를 생성한다.
  ///
  /// 해당 데이터는 Sample 이며, 추후 Firebase 를 이용하여 정보를 가져올 예정이다.
  static Future<RestaurantProvider> getSampleInstance() async {
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
