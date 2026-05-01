/// 음식점 종류에 대한 enum.
///
/// 음식점의 종류를 분류하기 위해 사용되며, [label] 필드를 통해 글자 형태의 이름을 제공합니다.
enum FoodKind {
  all("전체"),
  noodle("면 요리"),
  rice("밥"),
  bread("빵"),
  soup("국물 요리"),
  salad("샐러드"),
  etc("기타");

  /// 출력을 위한 글자 형태의 이름.
  final String label;
  const FoodKind(this.label);
}
