import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ks_flutter_commons/ks_flutter_commons.dart';
import 'package:mottai_flutter_app/theme/theme.dart';

class MessagePage extends StatefulHookConsumerWidget {
  const MessagePage({Key? key}) : super(key: key);

  static const path = '/message/';
  static const name = 'MessagePage';

  @override
  ConsumerState<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends ConsumerState<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return _buildAttendingRooms;
          },
          itemCount: 20,
        ),
      ),
    );
  }

  Widget get _buildAttendingRooms {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const Icon(Icons.person, size: 48),
          const CircleImage(
              radius: 48,
              imageURL:
                  'https://firebasestorage.googleapis.com/v0/b/mottai-app-dev-2.appspot.com/o/hosts%2Fyago-san.jpeg?alt=media&token=637a9f78-9243-4ce8-8734-5776a40cc7fd'),
          const Gap(8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('矢郷 史郎', style: bold12),
                Text(
                  '長いテキスト、長いテキスト、長いテキスト、長いテキスト、'
                  '長いテキスト、長いテキスト、長いテキスト、長いテキスト、'
                  '長いテキスト、長いテキスト、長いテキスト、長いテキスト、',
                  style: grey12,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          const Gap(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('00:00', style: grey10),
              const Gap(4),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: const Center(
                  child: Text(
                    '3',
                    style: whiteBold12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
