import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mottai_flutter_app/firestore_repository.dart';
import 'package:mottai_flutter_app/force_update/ui/force_update.dart';
import 'package:mottai_flutter_app/package_info.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'force_update_test.mocks.dart';

@GenerateMocks([ForceUpdateConfigRepository])
void main() {
  late final MockForceUpdateConfigRepository forceUpdateConfigRepository;

  setUpAll(() {
    forceUpdateConfigRepository = MockForceUpdateConfigRepository();
  });

  group('test forceUpdateStreamProvider', () {
    // TODO: 適切な dscription にする
    testWidgets('sample', (tester) async {
      when(forceUpdateConfigRepository.subscribeForceUpdateConfig()).thenAnswer(
        (_) => Stream<ReadForceUpdateConfig?>.value(
          const ReadForceUpdateConfig(
            forceUpdateConfigId: 'forceUpdateConfig',
            iOSLatestVersion: '1.0.2',
            iOSMinRequiredVersion: '1.0.1',
            iOSForceUpdate: true,
            androidLatestVersion: '1.0.2',
            androidMinRequiredVersion: '1.0.1',
            androidForceUpdate: true,
          ),
        ),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            packageInfoProvider.overrideWithValue(
              PackageInfo(
                appName: 'appName',
                packageName: 'packageName',
                version: '1.0.0',
                buildNumber: '1',
              ),
            ),
            forceUpdateConfigRepositoryProvider
                .overrideWithValue(forceUpdateConfigRepository),
          ],
          child: const MaterialApp(
            home: ForceUpdatePage(),
          ),
        ),
      );

      // TODO: 必要ならば数百ミリ秒まつなどの対応をする
      await tester.pump();

      // TODO: 適切なアサーションを行う
      expect(find.text('アップデートするかどうか'), findsOneWidget);
    });
  });
}
