import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ks_flutter_commons/ks_flutter_commons.dart';
import 'package:mottai_flutter_app/controllers/scaffold_messenger/scaffold_messenger_controller.dart';
import 'package:mottai_flutter_app/theme/theme.dart';

const double horizontalPadding = 8;
const double partnerImageSize = 36;

class RoomPage extends StatefulHookConsumerWidget {
  const RoomPage({Key? key}) : super(key: key);

  static const path = '/room/';
  static const name = 'RoomPage';

  @override
  ConsumerState<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends ConsumerState<RoomPage> {
  @override
  Widget build(BuildContext context) {
    return TapToUnfocusWidget(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    if (index.isEven) {
                      return _buildMessageByPartner();
                    } else {
                      return _buildMessageByMyself();
                    }
                  },
                  itemCount: 10,
                  reverse: true,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  color: messageBackgroundColor,
                ),
                child: Stack(
                  children: [
                    const TextField(
                      minLines: 1,
                      maxLines: 5,
                      style: regular12,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                          left: 16,
                          right: 36,
                          top: 8,
                          bottom: 8,
                        ),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: 'メッセージを入力',
                        hintStyle: regular12,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            ref.read(scaffoldMessengerController).showSnackBar('まだ何も起こりません');
                          },
                          child: const Icon(
                            Icons.send,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 相手からのメッセージ
  Widget _buildMessageByPartner() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const CircleImage(
                  size: 36,
                  imageURL:
                      'https://firebasestorage.googleapis.com/v0/b/mottai-app-dev-2.appspot.com/o/hosts%2Fyago-san.jpeg?alt=media&token=637a9f78-9243-4ce8-8734-5776a40cc7fd'),
              const Gap(8),
              Container(
                padding: const EdgeInsets.all(12),
                width:
                    (MediaQuery.of(context).size.width - partnerImageSize - horizontalPadding * 3) *
                        0.9,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  color: messageBackgroundColor,
                ),
                child: const Text(
                  '相手からのメッセージ、相手からのメッセージ、相手からのメッセージ、'
                  '相手からのメッセージ、相手からのメッセージ、相手からのメッセージ、'
                  '相手からのメッセージ、相手からのメッセージ、相手からのメッセージ、'
                  '相手からのメッセージ、相手からのメッセージ、相手からのメッセージ、',
                  style: regular12,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 4,
              left: partnerImageSize + horizontalPadding,
              bottom: 16,
            ),
            child: Text('00:00', style: grey12),
          ),
        ],
      ),
    );
  }

  /// 自分からのメッセージ
  Widget _buildMessageByMyself() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            width: (MediaQuery.of(context).size.width - partnerImageSize - horizontalPadding * 3) *
                0.9,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Text(
              '自分からのメッセージ、自分からのメッセージ、自分からのメッセージ、'
              '自分からのメッセージ、自分からのメッセージ、自分からのメッセージ、'
              '自分からのメッセージ、自分からのメッセージ、自分からのメッセージ、'
              '自分からのメッセージ、自分からのメッセージ、自分からのメッセージ、',
              style: white12,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: Text('00:00', style: grey12),
          ),
        ],
      ),
    );
  }
}
