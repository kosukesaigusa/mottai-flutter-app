/// Dynamic から bool への変換を行う。
bool toBool(dynamic value) {
  if (value == null) {
    return false;
  }
  if (value is bool) {
    return value;
  }
  if (value is int) {
    return value == 0;
  }
  if (value is String) {
    return value == '1' || value == 'true' || value == 'True' || value == 'TRUE';
  }
  return false;
}
