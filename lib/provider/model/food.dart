import 'package:tera_food/types/food_kind.dart';
import 'package:tera_food/types/food_preference.dart';

class Food {
  final String foodName;
  final FoodKind foodKind;
  final FoodPreference preference = FoodPreference.neutral;

  Food({
    required this.foodName,
    required this.foodKind,
  });
}