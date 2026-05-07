// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tera_food/main.dart';
import 'package:tera_food/types/food_kind.dart';

/// 앱 위젯 테스트 진입점.
///
/// 주요 사용자 흐름을 검증한다:
///
/// - 앱 초기 로딩 상태
/// - 음식점 목록 렌더링
/// - 음식점 카드 확장
/// - 추천 다이얼로그 표시 및 닫기
void main() {
  setUp(() async {
    // 테스트 실행 전에 앱의 설정을 초기화한다.
    SharedPreferences.setMockInitialValues(
        {
          'default_food_kind': FoodKind.noodle.name,
        }
    );
  });
  /// 앱 실행 직후 로딩 UI를 표시하고,
  /// 데이터 로딩 이후 음식점 목록을 렌더링하는지 검증한다.
  testWidgets('앱 실행 시 로딩 후 음식점 목록이 표시된다', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // FutureBuilder의 대기 상태에서 로딩 인디케이터가 표시되어야 한다.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // 비동기 음식점 데이터 로딩 시간을 진행시킨다.
    await tester.pumpAndSettle();
    await tester.pump();

    // 앱 제목과 음식점 카드 목록이 화면에 표시되어야 한다.
    expect(find.text(appName), findsOneWidget);
    expect(find.byType(FoodInfoCard), findsWidgets);
  });

  /// 음식점 카드를 탭했을 때 상세 액션 버튼이 노출되는지 검증한다.
  testWidgets('음식점 카드를 탭하면 상세 액션 버튼이 표시된다', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // 음식점 목록이 표시될 때까지 비동기 로딩을 진행한다.
    await tester.pumpAndSettle();
    await tester.pump();

    // 첫 번째 음식점 카드를 확장한다.
    await tester.tap(find.byType(FoodInfoCard).first);
    await tester.pumpAndSettle();

    // 확장 영역의 액션 버튼들이 표시되어야 한다.
    final favoriteButton = find.descendant(
        of: find
            .byType(FoodInfoCard)
            .first,
        matching: find.byIcon(Icons.favorite_border)
    );
    expect(favoriteButton, findsOneWidget);
  });

  /// 추천 버튼을 눌렀을 때 추천 다이얼로그가 표시되는지 검증한다.
  testWidgets('추천 버튼을 누르면 추천 다이얼로그가 표시된다', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // 추천 가능한 음식 목록이 구성될 때까지 대기한다.
    await tester.pumpAndSettle();
    await tester.pump();

    // 남은 애니메이션과 프레임 처리를 완료한 뒤 추천 버튼을 누른다.
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.thumb_up_outlined));
    await tester.pumpAndSettle();

    // 추천 다이얼로그의 핵심 UI 요소가 표시되어야 한다.
    expect(find.text('오늘의 추천 메뉴!'), findsOneWidget);
    expect(find.byIcon(Icons.star_outline_outlined), findsOneWidget);
    expect(find.text('확인'), findsOneWidget);
  });

  /// 추천 다이얼로그의 확인 버튼을 눌렀을 때 다이얼로그가 닫히는지 검증한다.
  testWidgets('추천 다이얼로그의 확인 버튼을 누르면 다이얼로그가 닫힌다', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // 추천 다이얼로그를 열 수 있도록 앱 초기 로딩을 완료한다.
    await tester.pumpAndSettle();
    await tester.pump();

    // 추천 버튼을 눌러 다이얼로그를 표시한다.
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.thumb_up_outlined));
    await tester.pumpAndSettle();

    expect(find.text('오늘의 추천 메뉴!'), findsOneWidget);

    // 확인 버튼을 눌러 다이얼로그를 닫는다.
    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();

    // 다이얼로그가 위젯 트리에서 제거되어야 한다.
    expect(find.text('오늘의 추천 메뉴!'), findsNothing);
  });

  group('즐겨찾기 기능에 대한 정상 동작 유무 확인', () {
    testWidgets('즐겨찾기 탭 하기', (widgetTester) async {
      await widgetTester.pumpWidget(const App());

      // 음식점 목록이 표시될 때까지 비동기 로딩을 진행한다.
      await widgetTester.pumpAndSettle();

      // 첫 번째 음식점 카드를 확장한다.
      await widgetTester.tap(find
          .byType(FoodInfoCard)
          .first);
      await widgetTester.pumpAndSettle();

      // 음식점 카드에 있는 즐겨찾기 버튼.
      final foodCardFavoriteButton = find.descendant(
          of: find
              .byType(FoodInfoCard)
              .first,
          matching: find.byIcon(Icons.favorite_border)
      );
      await widgetTester.tap(foodCardFavoriteButton);
      await widgetTester.pumpAndSettle();

      // 즐겨찾기 아이콘이 활성화된 상태로 변경되어야 한다.
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    },);
    testWidgets(
      '즐겨찾기 목록 추가 후 즐겨찾기 버튼 클릭 시 즐겨찾는 음식점 목록만 표시', (widgetTester) async {
      await widgetTester.pumpWidget(const App());

      // 음식점 목록이 표시될 때까지 비동기 로딩을 진행한다.
      await widgetTester.pumpAndSettle();

      // 첫 번째 음식점 카드를 확장한다.
      final selectedFoodCard = find
          .byType(FoodInfoCard)
          .first;
      await widgetTester.tap(selectedFoodCard);
      await widgetTester.pumpAndSettle();

      final foodCardFavoriteButton = find.descendant(
          of: find
              .byType(FoodInfoCard)
              .first,
          matching: find.byIcon(Icons.favorite_border)
      );

      // 특정 음식점 카드가 즐겨찾기에 등록되지 않은 경우에만 즐겨찾기 버튼을 탭하여 등록한다.
      if (foodCardFavoriteButton
          .evaluate()
          .isNotEmpty) {
        await widgetTester.tap(foodCardFavoriteButton);
        await widgetTester.pumpAndSettle();

        // 첫번째 음식점 카드를 축소한다.
        await widgetTester.tap(selectedFoodCard);
        await widgetTester.pumpAndSettle();
      }

      // AppBar의 즐겨찾기 버튼을 탭한다.
      await widgetTester.tap(find
          .byIcon(Icons.favorite_border)
          .first);
      await widgetTester.pumpAndSettle();

      expect(find.byType(FoodInfoCard), findsOneWidget);
    },);
  },);
  group('앱의 설정에 대한 정상 반영여부 확인', () {
    testWidgets(
      '설정에서 기본 음식점 종류 변경 시, 변경된 음식점 종류가 앱에 반영되는지 확인', (widgetTester) async {
      await widgetTester.pumpWidget(const App());

      // 앱 초기 로딩이 완료될 때까지 대기한다.
      await widgetTester.pumpAndSettle();

      // 기본 음식점 종류가 면류로 되어있을 시 음식점 출력 화면에서 면류만 출력되는지 확인한다.
      final noodleDropdownButton = find
          .descendant(
        of: find.byType(DropdownMenu<FoodKind>),
        matching: find.text('면류'),
      )
          .first;

      expect(noodleDropdownButton, findsOneWidget);
      expect(find.text('고스락 칼국수'), findsOneWidget);
      expect(find.text('CU'), findsNothing);
    },);
  });
}
