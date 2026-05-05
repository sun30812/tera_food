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
  final FoodPreference preference;

  Food({
    required this.foodName,
    required this.foodKind,
    this.preference = FoodPreference.neutral,
  });

  /// 음식점 정보 중 일부만 변경하여 새로운 [Food] 객체를 생성하는 메서드.
  Food copyWith({
    String? foodName,
    FoodKind? foodKind,
    FoodPreference? preference,
  }) {
    return Food(
      foodName: foodName ?? this.foodName,
      foodKind: foodKind ?? this.foodKind,
      preference: preference ?? this.preference,
    );
  }
}