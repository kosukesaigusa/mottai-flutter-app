import 'package:auto_route/auto_route.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/auth.dart';
import '../../development/firebase_storage/firebase_storage.dart';
import '../../development/firebase_storage/ui/firebase_storage_controller.dart';
import '../job.dart';
import 'job_controller.dart';

/// 仕事情報更新ページ。
@RoutePage()
class JobUpdatePage extends ConsumerWidget {
  const JobUpdatePage({
    @PathParam('jobId') required this.jobId,
    super.key,
  });

  static const path = '/jobs/:jobId/update';

  /// [JobUpdatePage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static String location({required String jobId}) => '/jobs/$jobId/update';

  final String jobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('お手伝い募集内容を入力')),
      // Jobの読み込み状態によって表示を変更
      body: ref.watch(jobFutureProvider(jobId)).when(
            data: (job) {
              if (job == null) {
                return const Center(child: Text('お手伝いが存在していません。'));
              }
              // UrlのhostIdとログイン中のユーザーのhostIdが違う場合
              if (job.hostId != ref.watch(userIdProvider)) {
                return const Center(
                  child: Text('編集の権限がありません。'),
                );
              }
              return _JobUpdate(
                job: job,
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => const Center(
              child: Text('仕事情報が取得できませんでした。'),
            ),
          ),
    );
  }
}

class _JobUpdate extends ConsumerWidget {
  const _JobUpdate({
    required this.job,
  });

  final ReadJob job;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseStorageController =
        ref.watch(firebaseStorageControllerProvider);
    final pickedImageFile = ref.watch(pickedImageFileStateProvider);
    final controller = ref.watch(jobControllerProvider);
    final titleController = TextEditingController(text: job.title);
    final locationController = TextEditingController(text: job.place);
    final contentController = TextEditingController(text: job.content);
    final belongingsController = TextEditingController(text: job.belongings);
    final rewardController = TextEditingController(text: job.reward);
    final accessDiscriptionController =
        TextEditingController(text: job.accessDescription);
    final commentController = TextEditingController(text: job.comment);

    final imageUrlProvider = StateProvider.autoDispose<String>(
      (ref) => job.imageUrl,
    );

    late final Widget imageWidget;

    if (pickedImageFile != null) {
      imageWidget = GestureDetector(
        onTap: firebaseStorageController.pickImageFromGallery,
        child: SizedBox(
          height: 300,
          child: Center(
            child: Image.file(pickedImageFile),
          ),
        ),
      );
    }
    // 画像が選択されている場合は画像を表示
    // 選択されていない場合は画像アイコンを表示
    else if (ref.watch(imageUrlProvider) != '') {
      imageWidget = GenericImage.rectangle(
        onTap: firebaseStorageController.pickImageFromGallery,
        showDetailOnTap: false,
        imageUrl: pickedImageFile?.path ?? ref.watch(imageUrlProvider),
        height: 300,
        width: null,
      );
    } else {
      imageWidget = GestureDetector(
        onTap: firebaseStorageController.pickImageFromGallery,
        child: Container(
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black38),
          ),
          child: const Center(child: Icon(Icons.image)),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageWidget,
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 24,
            ),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TextInputSection(
                    title: 'お手伝いのタイトル',
                    description: 'お手伝いのタイトルを最大2行程度で入力してください。',
                    maxLines: 2,
                    defaultDisplayLines: 2,
                    controller: titleController,
                  ),
                  _TextInputSection(
                    title: 'お手伝いの場所',
                    description:
                        'お手伝いを行う場所（農場や作業場所など）を入力してください。作業内容や曜日によって複数の場所の可能性がある場合は、それも入力してください。',
                    controller: locationController,
                  ),
                  _TextInputSection(
                    title: 'お手伝いの内容',
                    description:
                        'お手伝いの作業内容、作業時間帯やその他の情報をできるだけ詳しくを入力してください。お手伝い可能な曜日や時間帯、時期や季節が限られている場合や、その他に事前にお知らせするべき条件や情報などがあれば、その内容も入力してください。',
                    defaultDisplayLines: 10,
                    controller: contentController,
                  ),
                  _TextInputSection(
                    title: '持ち物',
                    description:
                        'お手伝いに必要な服装や持ち物などを書いてください。特に必要ない場合や貸出を行う場合はその内容も入力してください。',
                    controller: belongingsController,
                  ),
                  _TextInputSection(
                    title: '報酬',
                    description: 'お手伝いをしてくれたワーカーにお渡しする報酬（食べ物など）を入力してください。',
                    controller: rewardController,
                  ),
                  _TextInputSection(
                    title: 'アクセス',
                    description:
                        'お手伝いの場所までのアクセス方法について補足説明をしてください。最寄りの駅やバス停まで送迎ができる場合などは、その内容も入力してください。',
                    controller: accessDiscriptionController,
                    choices: {
                      for (final v in AccessType.values) v: v.label,
                    },
                  ),
                  _TextInputSection(
                    title: 'ひとこと',
                    description:
                        'お手伝いを検討してくれるワーカーの方が、ぜひお手伝いをしてみたくなるようひとことや、募集するお手伝いの魅力を入力しましょう！',
                    defaultDisplayLines: 5,
                    controller: commentController,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 32),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          controller.updateJob(
                            jobId: job.jobId,
                            title: titleController.text,
                            place: locationController.text,
                            content: contentController.text,
                            belongings: belongingsController.text,
                            reward: rewardController.text,
                            accessDescription: accessDiscriptionController.text,
                            comment: commentController.text,
                            imageFile: pickedImageFile,
                          );
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

/// タイトルと説明、テキストフィールドからなるセクション
/// [Section]を使用し、contentにフィールドを与えている
class _TextInputSection extends StatelessWidget {
  const _TextInputSection({
    required this.title,
    this.description,
    this.maxLines,
    this.defaultDisplayLines = 1,
    this.choices,
    this.controller,
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
  final Map<dynamic, String>? choices;

  /// テキストフィールドのコントローラー
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Section(
      title: title,
      titleStyle: Theme.of(context).textTheme.titleLarge,
      description: description,
      descriptionStyle: Theme.of(context).textTheme.bodyMedium,
      sectionPadding: const EdgeInsets.only(bottom: 32),
      content: Column(
        children: [
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: List.filled(defaultDisplayLines - 1, '\n').join(),
              border: const OutlineInputBorder(),
            ),
          ),
          if (choices != null)
            SelectableChips(
              allItems: choices!.keys,
              labels: choices!,
              enabledItems: choices!.keys,
            )
        ],
      ),
    );
  }
}