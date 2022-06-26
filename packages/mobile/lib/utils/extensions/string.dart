extension StringExtension on String {
  /// 空文字の場合に変わりの文字を返す。
  String ifIsEmpty(String placeholder) => isEmpty ? placeholder : this;

  /// 指定した文字数を超えていた場合にそれ以降を省略する。
  String truncated(
    int maxLength, {
    String ellipsis = '...',
  }) {
    final length = this.length;
    if (length <= maxLength) {
      return this;
    }
    return '${substring(0, maxLength)}$ellipsis';
  }
}
