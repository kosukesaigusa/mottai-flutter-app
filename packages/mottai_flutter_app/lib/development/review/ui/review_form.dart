import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../review/ui/review_controller.dart';
import '../../../widgets/text_input_section.dart';
import '../../firebase_storage/firebase_storage.dart';
import '../../firebase_storage/ui/firebase_storage_controller.dart';

/// - `create` の場合、ログイン済みの `workerId`（ユーザー ID）と、対象の `jobId`
/// - `update` の場合、更新対象の [Review] と、対象の`jobId`、本人であることが確認された `workerId`（ユーザー ID）
///
/// を受け取り、それに応じた [Review] の作成または更新を行うフォーム。
class ReviewForm extends ConsumerStatefulWidget {
  const ReviewForm.create({
    required String workerId,
    required String jobId,
    super.key,
  })  : _jobId = jobId,
        _workerId = workerId,
        _review = null;

  const ReviewForm.update({
    required String workerId,
    required String jobId,
    required ReadReview review,
    super.key,
  })  : _jobId = jobId,
        _workerId = workerId,
        _review = review;

  final ReadReview? _review;

  final String _workerId;

  final String _jobId;

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
    final controller = ref.watch(reviewControllerProvider);
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
                  TextInputSection(
                    title: 'タイトル',
                    description: '感想のタイトルを最大2行程度で入力してください。',
                    maxLines: 2,
                    defaultDisplayLines: 2,
                    controller: _titleController,
                    isRequired: true,
                  ),
                  TextInputSection(
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
                          final isValidate = formKey.currentState?.validate();
                          if (!(isValidate ?? true)) {
                            return;
                          }

                          final review = widget._review;

                          if (review != null) {
                            controller.updateReview(
                              reviewId: review.reviewId,
                              workerId: widget._workerId,
                              title: _titleController.text,
                              content: _contentController.text,
                              imageFile: pickedImageFile,
                            );
                          } else {
                            controller.create(
                              workerId: widget._workerId,
                              jobId: widget._jobId,
                              title: _titleController.text,
                              content: _contentController.text,
                              imageFile: pickedImageFile,
                            );
                          }
                          //TODO: 登録 or 更新完了の旨をユーザーに示すUIが必要か？
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
