import 'package:auto_route/auto_route.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ワーカーページ。
@RoutePage()
class CreateOrUpdateWorkerPage extends ConsumerWidget {
  const CreateOrUpdateWorkerPage({
    @PathParam('userId') required this.userId,
    super.key,
  });

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/worker/:userId/edit';

  /// [CreateOrUpdateWorkerPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static String location({required String userId}) => '/worker/$userId/edit';

  /// パスパラメータから得られるユーザーの ID.
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ワーカー情報を入力'),
      ),
      body: const _WorkerForm(),
    );
  }
}

class _WorkerForm extends ConsumerStatefulWidget {
  const _WorkerForm();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WorkerFormState();
}

class _WorkerFormState extends ConsumerState<_WorkerForm> {
  late final TextEditingController _workerNameController;

  late final TextEditingController _introductionController;

  late final String _imageUrl;

  @override
  void initState() {
    // TODO: ワーカー名を取得して初期値として入れる
    _workerNameController = TextEditingController(text: '');
    // TODO: 自己紹介文を取得して初期値として入れる
    _introductionController = TextEditingController(text: '');
    // TODO: ワーカーのプロフィール画像を取得してくるなければNoImageとして代わりの画像を出す
    _imageUrl = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Gap(8),
          Row(
            children: [
              GenericImage.circle(
                imageUrl: _imageUrl,
              ),
              const Gap(16),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: TextFormField(
                    controller: _workerNameController,
                    decoration: const InputDecoration(
                      hintText: 'お手伝い太郎',
                      labelText: 'ワーカー名',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Text('自己紹介'),
                    Gap(8),
                    OptionalBadge(),
                  ],
                ),
              ),
              TextFormField(
                controller: _introductionController,
                minLines: 5,
                maxLines: 12,
                decoration: const InputDecoration(
                  hintText: '自己紹介',
                  labelText: '自己紹介',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          const Gap(40),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('この内容で登録'),
          ),
        ],
      ),
    );
  }
}
