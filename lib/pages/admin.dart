import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:tera_food/provider/restaurant_provider.dart';
import 'package:tera_food/types/food_kind.dart';
import 'package:tera_food/provider/model/food.dart';

class ManagementPage extends StatefulWidget {
  const ManagementPage({super.key});

  @override
  State<ManagementPage> createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  late final Future<RestaurantProvider> _restaurantProvider;

  @override
  void initState() {
    super.initState();
    _restaurantProvider = RestaurantProvider.getSampleInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('관리자용 페이지')),
      body: FutureBuilder<RestaurantProvider>(
        future: _restaurantProvider,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        asyncSnapshot.data?.foods(FoodKind.all).length ?? 0,
                    itemBuilder: (context, index) {
                      List<Food> foodList =
                          asyncSnapshot.data?.foods(FoodKind.all) ?? [];
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  foodList[index].foodName,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  "음식 종류: ${foodList[index].foodKind.label}",
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.edit_outlined),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

@Preview(name: 'ManagementPage')
Widget managementPagePreview() => const ManagementPage();
