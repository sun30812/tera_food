import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:tera_food/provider/settings_provider.dart';
import 'package:tera_food/types/food_kind.dart';

/// 앱의 설정 페이지이다.
///
/// 해당 페이지를 통해 앱의 전반적인 설정을 제어할 수 있으며, 실제 데이터는 [SettingsProvider] 에서 관리한다.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late FoodKind _selectedFoodKind;

  late final Future<SettingsProvider> _settingsProviderFuture =
      SettingsProvider.getInstance();

  @override
  void initState() {
    super.initState();
    _selectedFoodKind = FoodKind.values.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: FutureBuilder<SettingsProvider>(
          future: _settingsProviderFuture,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            _selectedFoodKind =
                asyncSnapshot.data?.getDefaultFoodKind() ?? FoodKind.all;
            return Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const ListTile(
                            title: Text('기본 음식점 종류 설정'),
                            subtitle: Text(
                              '처음 화면 진입 시 기본으로 표시할 음식점 종류를 설정합니다.',
                            ),
                            leading: Icon(Icons.food_bank_outlined),
                          ),
                        ),
                        DropdownMenu(
                          width: MediaQuery.of(context).size.width - 32,
                          initialSelection: _selectedFoodKind,
                          dropdownMenuEntries: FoodKind.values
                              .map(
                                (item) => DropdownMenuEntry(
                                  value: item,
                                  label: item.label,
                                ),
                              )
                              .toList(),
                          onSelected: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedFoodKind = value;
                                asyncSnapshot.data?.setDefaultFoodKind(value);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

@Preview(name: 'SettingsPage')
Widget settingsPagePreview() => const SettingsPage();
