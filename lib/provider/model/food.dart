import 'package:tera_food/types/food_kind.dart';
import 'package:tera_food/types/food_preference.dart';

/// 음식점 정보를 담는 모델 클래스.
///
/// [foodName]에 음식점의 이름을 저장하고, [foodKind]에 음식점의 종류를 저장한다.
/// 추후 [preference] 필드를 사용하여 선호도 정보를 지정할 예정이다.
class Food {
  /// 음식점의 이름.
  final String foodName;
  /// 음식점의 주요 음식의 대분류.
  final FoodKind foodKind;
  /// 음식점에 대한 선호도 정보.
  final FoodPreference preference = FoodPreference.neutral;

  Food({
    required this.foodName,
    required this.foodKind,
  });
}