import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../development/firebase_storage/firebase_storage.dart';
import '../../development/firebase_storage/ui/firebase_storage_controller.dart';
import '../../widgets/text_input_section.dart';
import 'job_controller.dart';

/// - `create` の場合、ログイン済みの `hostId`（ユーザー ID）
/// - `update` の場合、更新対象の [Job] とその本人であることが確認された `hostId`（ユーザー ID）
///
/// を受け取り、それに応じた [Job] の作成または更新を行うフォーム。
class JobForm extends ConsumerStatefulWidget {
  const JobForm.create({
    required String hostId,
    super.key,
  })  : _hostId = hostId,
        _job = null;

  const JobForm.update({
    required String hostId,
    required ReadJob job,
    super.key,
  })  : _hostId = hostId,
        _job = job;

  final ReadJob? _job;

  final String _hostId;

  @override
  JobFormState createState() => JobFormState();
}

class JobFormState extends ConsumerState<JobForm> {
  /// フォームのグローバルキー
  final formKey = GlobalKey<FormState>();

  /// 選択中のアクセスタイプ
  final List<AccessType> _selectedAccessTypes = [];

  /// [Job.title] のテキストフィールド用コントローラー
  late final TextEditingController _titleController;

  /// [Job.place] のテキストフィールド用コントローラー
  late final TextEditingController _locationController;

  /// [Job.content] のテキストフィールド用コントローラー
  late final TextEditingController _contentController;

  /// [Job.belongings] のテキストフィールド用コントローラー
  late final TextEditingController _belongingsController;

  /// [Job.reward] のテキストフィールド用コントローラー
  late final TextEditingController _rewardController;

  /// [Job.accessDescription] のテキストフィールド用コントローラー
  late final TextEditingController _accessDescriptionController;

  /// [Job.comment] のテキストフィールド用コントローラー
  late final TextEditingController _commentController;

  /// 画像の高さ。
  static const double _imageHeight = 300;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget._job?.title);
    _locationController = TextEditingController(text: widget._job?.place);
    _contentController = TextEditingController(text: widget._job?.content);
    _belongingsController =
        TextEditingController(text: widget._job?.belongings);
    _rewardController = TextEditingController(text: widget._job?.reward);
    _accessDescriptionController =
        TextEditingController(text: widget._job?.accessDescription);
    _commentController = TextEditingController(text: widget._job?.comment);
    if (widget._job != null) {
      _selectedAccessTypes.addAll(widget._job!.accessTypes.toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseStorageController =
        ref.watch(firebaseStorageControllerProvider);
    final pickedImageFile = ref.watch(pickedImageFileStateProvider);
    final controller = ref.watch(jobControllerProvider(widget._hostId));
    final jobId = widget._job?.jobId;
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
          else if ((widget._job?.imageUrl ?? '').isNotEmpty)
            GenericImage.rectangle(
              onTap: firebaseStorageController.pickImageFromGallery,
              showDetailOnTap: false,
              imageUrl: pickedImageFile?.path ?? widget._job!.imageUrl,
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
                    title: 'お手伝いのタイトル',
                    description: 'お手伝いのタイトルを最大2行程度で入力してください。',
                    maxLines: 2,
                    defaultDisplayLines: 2,
                    controller: _titleController,
                    isRequired: true,
                  ),
                  TextInputSection(
                    title: 'お手伝いの場所',
                    description: 'お手伝いを行う場所（農場や作業場所など）を入力してください。'
                        '作業内容や曜日によって複数の場所の可能性がある場合は、それも入力してください。',
                    controller: _locationController,
                    isRequired: true,
                  ),
                  TextInputSection(
                    title: 'お手伝いの内容',
                    description: 'お手伝いの作業内容、作業時間帯やその他の情報をできるだけ詳しくを入力してください。'
                        'お手伝い可能な曜日や時間帯、時期や季節が限られている場合や、'
                        'その他に事前にお知らせするべき条件や情報などがあれば、その内容も入力してください。',
                    defaultDisplayLines: 10,
                    controller: _contentController,
                    isRequired: true,
                  ),
                  TextInputSection(
                    title: '持ち物',
                    description: 'お手伝いに必要な服装や持ち物などを書いてください。'
                        '特に必要ない場合や貸出を行う場合はその内容も入力してください。',
                    controller: _belongingsController,
                    isRequired: true,
                  ),
                  TextInputSection(
                    title: '報酬',
                    description: 'お手伝いをしてくれたワーカーにお渡しする報酬（食べ物など）を入力してください。',
                    controller: _rewardController,
                    isRequired: true,
                  ),
                  TextInputSection<AccessType>.withChoice(
                    title: 'アクセス',
                    description: 'お手伝いの場所までのアクセス方法について補足説明をしてください。'
                        '最寄りの駅やバス停まで送迎ができる場合などは、その内容も入力してください。',
                    controller: _accessDescriptionController,
                    choices: {
                      for (final v in AccessType.values) v: v.label,
                    },
                    enabledChoices: _selectedAccessTypes,
                    onChoiceSelected: (item) {
                      if (_selectedAccessTypes.contains(item)) {
                        _selectedAccessTypes.remove(item);
                      } else {
                        _selectedAccessTypes.add(item);
                      }
                      setState(() {});
                    },
                  ),
                  TextInputSection(
                    title: 'ひとこと',
                    description: 'お手伝いを検討してくれるワーカーの方が、ぜひお手伝いをしてみたくなるようひとことや、'
                        '募集するお手伝いの魅力を入力しましょう！',
                    defaultDisplayLines: 5,
                    controller: _commentController,
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

                          if (jobId != null) {
                            controller.updateJob(
                              jobId: jobId,
                              title: _titleController.text,
                              place: _locationController.text,
                              content: _contentController.text,
                              belongings: _belongingsController.text,
                              reward: _rewardController.text,
                              accessDescription:
                                  _accessDescriptionController.text,
                              comment: _commentController.text,
                              imageFile: pickedImageFile,
                              accessTypes: _selectedAccessTypes.toSet(),
                            );
                          } else {
                            controller.create(
                              hostId: widget._hostId,
                              title: _titleController.text,
                              place: _locationController.text,
                              content: _contentController.text,
                              belongings: _belongingsController.text,
                              reward: _rewardController.text,
                              accessDescription:
                                  _accessDescriptionController.text,
                              comment: _commentController.text,
                              imageFile: pickedImageFile,
                              accessTypes: _selectedAccessTypes.toSet(),
                            );
                          }
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
