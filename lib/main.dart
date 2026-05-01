import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:tera_food/provider/model/food.dart';
import 'package:tera_food/provider/restaurant_provider.dart';
import 'package:tera_food/style/buttons.dart';
import 'package:tera_food/types/food_kind.dart';

/// 앱 전체에서 사용하는 이름.
const appName = "테라타워 음식점 추천";

void main() {
  runApp(const App());
}

/// 앱의 최상위 위젯.
///
/// Material 3 테마와 App의 시작 화면인 [AppPage]를 구성한다.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
          ).surface,
        ),
      ),
      home: const AppPage(),
    );
  }
}

/// 음식점 목록과 추천 기능을 제공하는 메인 화면.
class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

/// [AppPage]의 상태를 관리한다.
///
/// 음식 종류 선택, 음식점 목록 및 음식점에 대한 즐겨찾기 및 추천 제외 버튼을 포함한 카드를 표시한다.
class _AppPageState extends State<AppPage> {
  /// 현재 선택된 음식점 종류.
  late FoodKind foodKind;

  // 음식점 데이터를 비동기로 제공하는 provider future.
  late final Future<RestaurantProvider> _restaurantProviderFuture;

  /// 마지막으로 추천된 음식점 정보.
  Food? recommendedFood;

  // 음식점 카드 확장 상태를 제어하는 컨트롤러 목록.
  final List<ExpansibleController> _expansionControllers = [];

  // 추천 후보로 사용할 음식 이름 목록.
  final List<Food> _recommendedFoods = [];

  @override
  void didUpdateWidget(covariant AppPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 화면 갱신 시 기존 확장 상태와 추천 후보를 초기화한다.
    for (var controller in _expansionControllers) {
      controller.collapse();
    }
    _recommendedFoods.clear();
    _expansionControllers.clear();
  }

  @override
  void initState() {
    super.initState();

    // 기본 음식 종류와 음식점 provider를 초기화한다.
    foodKind = FoodKind.noodle;
    _restaurantProviderFuture = RestaurantProvider.getSampleInstance();
  }

  /// [foodList]에서 임의의 음식을 선택해 [RecommendDialog]를 표시한다.
  void _recommendFood(List<Food> foodList) {
    final random = Random();
    final randomFood = foodList[random.nextInt(foodList.length)];
    recommendedFood = randomFood;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RecommendDialog(recommendedFood: recommendedFood);
      },
    );
  }

  /// 카드 확장 상태와 추천 음식점 후보 목록을 초기화한다.
  void _refreshUI() {
    for (final controller in _expansionControllers) {
      controller.collapse();
    }
    _recommendedFoods.clear();
  }

  @override
  void dispose() {
    // 위젯 제거 시 생성한 확장 컨트롤러를 해제한다.
    for (final controller in _expansionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _restaurantProviderFuture,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: mainAppBar(context),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 3.0,
                children: [
                  CircularProgressIndicator(),
                  Text("음식점 정보를 불러오는 중입니다..."),
                ],
              ),
            ),
          );
        }

        foodKind = asyncSnapshot.data != null ? foodKind : FoodKind.noodle;
        final foodList = asyncSnapshot.data?.foods(foodKind) ?? [];

        // 음식점 카드 수만큼 확장 컨트롤러를 준비한다.
        for (int i = 0; i < foodList.length; i++) {
          if (i >= _expansionControllers.length) {
            _expansionControllers.add(ExpansibleController());
          }
        }

        // 현재 표시 중인 음식점을 추천 후보에 추가한다.
        _recommendedFoods.addAll(foodList);

        return Scaffold(
          appBar: mainAppBar(context),
          body: RefreshIndicator(
            onRefresh: () async {
              _refreshUI();
              setState(() {});
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownMenu<FoodKind>(
                    initialSelection: foodKind,
                    width: MediaQuery.of(context).size.width - 32,
                    dropdownMenuEntries: FoodKind.values
                        .map(
                          (item) =>
                              DropdownMenuEntry(value: item, label: item.label),
                        )
                        .toList(),
                    onSelected: (value) {
                      if (value == null) return;

                      _refreshUI();
                      setState(() {
                        foodKind = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: foodList.length,
                    itemBuilder: (context, index) {
                      return FoodInfoCard(
                        food: foodList[index],
                        controller: _expansionControllers[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _recommendFood(_recommendedFoods),
            child: const Icon(Icons.thumb_up_outlined),
          ),
        );
      },
    );
  }

  /// 앱의 전반적인 부분에서 사용될 [AppBar]
  AppBar mainAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        appName,
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// 추천 음식점을 표시하는 [AlertDialog]
///
/// [recommendedFood]의 이름을 표시하며, 확인 버튼을 통해 다이얼로그를 닫는다.
///
/// ## 참고
/// - [Food]
class RecommendDialog extends StatelessWidget {
  /// [recommendedFood]를 표시하는 다이얼로그를 생성한다.
  const RecommendDialog({super.key, required this.recommendedFood});

  /// 사용자에게 보여줄 추천 음식점 정보
  final Food? recommendedFood;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('오늘의 추천 메뉴!'),
      content: Row(
        spacing: 8.0,
        children: [
          Icon(
            Icons.star_outline_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          Text(
            recommendedFood!.foodName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('확인'),
        ),
      ],
    );
  }
}

/// 음식점 정보를 카드 형태로 표시하는 위젯.
///
/// [food]로 제공된 정보를 출략하며, 카드 확장 상태는 [controller]로 제어된다.
class FoodInfoCard extends StatelessWidget {
  /// 음식점 카드 인스턴스를 생성한다.
  const FoodInfoCard({
    super.key,
    required this.food,
    required this.controller,
  });

  /// 카드에 표시할 음식점 정보
  final Food food;

  /// [ExpansionTile]의 확장 상태를 제어하는 컨트롤러.
  final ExpansibleController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: ExpansionTile(
          controller: controller,
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          title: Text(food.foodName, style: Theme.of(context).textTheme.bodyLarge),
          leading: Icon(
            getFoodIcon,
            color: Theme.of(context).colorScheme.primary,
          ),
          children: [
            Row(
              spacing: 8.0,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: null, icon: Icon(Icons.delete_outline)),
                BeatingHeartIconButton(onPressed: null)
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// [foodKind]에 대응하는 Material 아이콘을 반환한다.
  ///
  /// ## 참고
  /// - [FoodKind]
  IconData get getFoodIcon {
    switch (food.foodKind) {
      case FoodKind.noodle:
        return Icons.ramen_dining_rounded;
      case FoodKind.rice:
        return Icons.rice_bowl_outlined;
      case FoodKind.bread:
        return Icons.lunch_dining_outlined;
      case FoodKind.soup:
        return Icons.soup_kitchen_outlined;
      case FoodKind.salad:
        return Icons.water_drop_outlined;
      default:
        return Icons.food_bank_outlined;
    }
  }
}

@Preview(name: 'Food Card')
Widget foodCardPreview() {
  return FoodInfoCard(food: Food(foodName: "쌀국수", foodKind: FoodKind.noodle), controller: ExpansibleController());
}

@Preview(name: 'Recommended Dialog')
Widget recommendedDialogPreview() {
  return RecommendDialog(recommendedFood: Food(foodName: "쌀국수", foodKind: FoodKind.noodle));
}
