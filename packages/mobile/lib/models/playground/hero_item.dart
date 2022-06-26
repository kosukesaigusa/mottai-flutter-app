import 'package:freezed_annotation/freezed_annotation.dart';

part 'hero_item.freezed.dart';

@freezed
class HeroItem with _$HeroItem {
  const factory HeroItem({
    required String tag,
    @Default('') String imageURL,
    @Default('') String description,
  }) = _HeroItem;
}
