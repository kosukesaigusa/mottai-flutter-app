import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../development/firebase_storage/firebase_storage.dart';
import '../../development/firebase_storage/ui/firebase_storage_controller.dart';
import '../../widgets/optional_badge.dart';

/// - `create` の場合、ログイン済みの `workerId`（ユーザー ID）
/// - `update` の場合、更新対象の [Review] とその本人であることが確認された `workerId`（ユーザー ID）
///
/// を受け取り、それに応じた [Review] の作成または更新を行うフォーム。
class ReviewForm extends ConsumerStatefulWidget {
  const ReviewForm.create({
    required String workerId,
    super.key,
  })  : _workerId = workerId,
        _review = null;

  const ReviewForm.update({
    required String workerId,
    required ReadReview review,
    super.key,
  })  : _workerId = workerId,
        _review = review;

  final ReadReview? _review;

  final String _workerId;

  @override
  ReviewFormState createState() => ReviewFormState();
}

class ReviewFormState extends ConsumerState<ReviewForm> {
  /// フォームのグローバルキー
  final formKey = GlobalKey<FormState>();

  /// [Review.title] のテキストフィールド用コントローラー
  late final TextEditingController _titleController;

  /// [Review.content] のテキストフィールド用コントローラー
  late final TextEditingController _contentController;

  /// 画像の高さ。
  static const double _imageHeight = 300;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget._review?.title);
    _contentController = TextEditingController(text: widget._review?.content);
  }

  @override
  Widget build(BuildContext context) {
    final firebaseStorageController =
        ref.watch(firebaseStorageControllerProvider);
    final pickedImageFile = ref.watch(pickedImageFileStateProvider);
    // final controller = ref.watch(jobControllerProvider(widget._hostId));
    // final jobId = widget._job?.jobId;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (pickedImageFile != null)
            GestureDetector(
              onTap: firebaseStorageController.pickImageFromGallery,
              child: SizedBox(
                height: _imageHeight,
                child: Center(
                  child: Image.file(pickedImageFile),
                ),
              ),
            )
          else if ((widget._review?.imageUrl ?? '').isNotEmpty)
            GenericImage.rectangle(
              onTap: firebaseStorageController.pickImageFromGallery,
              showDetailOnTap: false,
              imageUrl: pickedImageFile?.path ?? widget._review!.imageUrl,
              maxHeight: _imageHeight,
            )
          else
            GestureDetector(
              onTap: firebaseStorageController.pickImageFromGallery,
              child: Container(
                height: _imageHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38),
                ),
                child: const Center(child: Icon(Icons.image)),
              ),
            ),
          const Gap(32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TextInputSection(
                    title: 'タイトル',
                    description: '感想のタイトルを最大2行程度で入力してください。',
                    maxLines: 2,
                    defaultDisplayLines: 2,
                    controller: _titleController,
                    isRequired: true,
                  ),
                  _TextInputSection(
                    title: '本文',
                    description: '感想の本文を入力してください。',
                    defaultDisplayLines: 5,
                    maxLines: 12,
                    controller: _contentController,
                    isRequired: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 32),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // final isValidate = formKey.currentState?.validate();
                          // if (!(isValidate ?? true)) {
                          //   return;
                          // }

                          // if (jobId != null) {
                          //   controller.updateJob(
                          //     jobId: jobId,
                          //     title: _titleController.text,
                          //     place: _locationController.text,
                          //     content: _contentController.text,
                          //     belongings: _belongingsController.text,
                          //     reward: _rewardController.text,
                          //     accessDescription:
                          //         _accessDescriptionController.text,
                          //     comment: _commentController.text,
                          //     imageFile: pickedImageFile,
                          //     accessTypes: _selectedAccessTypes.toSet(),
                          //   );
                          // } else {
                          //   controller.create(
                          //     hostId: widget._hostId,
                          //     title: _titleController.text,
                          //     place: _locationController.text,
                          //     content: _contentController.text,
                          //     belongings: _belongingsController.text,
                          //     reward: _rewardController.text,
                          //     accessDescription:
                          //         _accessDescriptionController.text,
                          //     comment: _commentController.text,
                          //     imageFile: pickedImageFile,
                          //     accessTypes: _selectedAccessTypes.toSet(),
                          //   );
                          // }
                        },
                        child: const Text('この内容で登録する'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//TODO JobForm で使用しているものと同様のため、dart_flutter_common で共通化すべきか？
/// タイトルと説明、テキストフィールドからなるセクション。
/// [Section] を使用し、`Section.content` にフィールドを与えている。
class _TextInputSection<T extends dynamic> extends StatelessWidget {
  /// テキスト入力のみをさせる通常の [_TextInputSection] を作成する。
  const _TextInputSection({
    required this.title,
    this.description,
    this.maxLines,
    this.defaultDisplayLines = 1,
    this.controller,
    this.isRequired = false,
  })  : choices = const {},
        enabledChoices = const [],
        onChoiceSelected = null;

  /// テキスト入力と選択肢を併せて入力させる [_TextInputSection] を作成する。
  const _TextInputSection.withChoice({
    required this.title,
    this.description,
    this.maxLines,
    this.defaultDisplayLines = 1,
    required this.choices,
    required this.enabledChoices,
    required this.onChoiceSelected,
    this.controller,
    this.isRequired = false,
  });

  /// セクションのタイトル。
  final String title;

  /// セクションの説明。
  final String? description;

  /// テキストフィールドの最大行数
  final int? maxLines;

  /// 初期表示時のテキストフィールドの行数
  final int defaultDisplayLines;

  /// テキストフィールドの下に表示する選択肢
  /// 選択された際の値がkeyで、表示する値がvalueの[Map]で受け取る。
  final Map<T, String> choices;

  /// [choices] の有効な値のリスト
  final List<T> enabledChoices;

  /// [choices] が選択された際のコールバック
  final void Function(T item)? onChoiceSelected;

  /// テキストフィールドのコントローラー
  final TextEditingController? controller;

  /// 必須入力か否か
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Section(
      title: title,
      titleBadge: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: OptionalBadge(isRequired: isRequired),
      ),
      titleStyle: Theme.of(context).textTheme.titleLarge,
      description: description,
      descriptionStyle: Theme.of(context).textTheme.bodyMedium,
      sectionPadding: const EdgeInsets.only(bottom: 32),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            validator: (value) {
              if (isRequired && (value ?? '').isEmpty) {
                return '入力してください。';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: List.filled(defaultDisplayLines - 1, '\n').join(),
              border: const OutlineInputBorder(),
            ),
          ),
          if (choices.isNotEmpty) ...[
            const Gap(16),
            SelectableChips<T>(
              allItems: choices.keys,
              labels: choices,
              runSpacing: 8,
              enabledItems: enabledChoices,
              onTap: onChoiceSelected,
            ),
          ],
        ],
      ),
    );
  }
}
