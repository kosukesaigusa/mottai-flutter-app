enum BottomNavigationBarItemName {
  home,
  matching,
  myPage,
}

extension BottomNavigationBarItemNameExt on BottomNavigationBarItemName {
  String get itemName {
    switch (this) {
      case BottomNavigationBarItemName.home:
        return 'ホーム';
      case BottomNavigationBarItemName.matching:
        return 'マッチング';
      case BottomNavigationBarItemName.myPage:
        return 'マイページ';
    }
  }
}
