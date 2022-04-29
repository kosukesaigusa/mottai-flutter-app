extension StringExtension on String {
  String ifIsEmpty(String placeholder) {
    return isEmpty ? placeholder : this;
  }
}
