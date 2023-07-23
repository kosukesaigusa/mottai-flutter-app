import 'package:firebase_common/firebase_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mottai_flutter_app/firestore_repository.dart';
import 'package:mottai_flutter_app/force_update/force_update.dart';
import 'package:mottai_flutter_app/package_info.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'force_update_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ForceUpdateConfigRepository>()])
Future<void> main() async {
  group('強制アップデート', () {
    test('データローディング中はisForceUpdateProviderがfalseを返す', () async {
      final mockForceUpdateConfigRepository = MockForceUpdateConfigRepository();
      PackageInfo.setMockInitialValues(
        appName: 'test_mottai_flutter_app_monorepo',
        packageName: 'packageName',
        version: '0.0.1',
        buildNumber: 'buildNumber',
        buildSignature: 'buildSignature',
      );
      final container = ProviderContainer(
        overrides: [
          packageInfoProvider
              .overrideWithValue(await PackageInfo.fromPlatform()),
          isIOSProvider.overrideWithValue(true),
          forceUpdateConfigRepositoryProvider
              .overrideWithValue(mockForceUpdateConfigRepository),
        ],
      );
      // モックリポジトリにより取得するデータを変更する
      when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
          .thenAnswer((_) async* {
        yield const ReadForceUpdateConfig(
          androidForceUpdate: false,
          androidLatestVersion: '0.0.2',
          androidMinRequiredVersion: '0.0.1',
          forceUpdateConfigId: 'forceUpdateConfig',
          iOSForceUpdate: false,
          iOSLatestVersion: '0.0.2',
          iOSMinRequiredVersion: '0.0.2',
          path: 'configurations',
        );
      });
      // プロバイダーをリッスンすることで変更を反映させる
      container.listen(
        forceUpdateFutureProvider,
        (previous, next) {},
        fireImmediately: true,
      );
      expect(
        container.read(forceUpdateFutureProvider),
        const AsyncValue<ReadForceUpdateConfig?>.loading(),
      );
      // ローディング中はfalseを返す
      expect(
        container.read(isForceUpdateProvider),
        false,
      );
      // リクエストの結果が戻るのを待つ
      await container.read(forceUpdateFutureProvider.future);
      // 取得したデータを公開する
      // 取得したデータがmockitoで設定した値と同じであること
      expect(
        container.read(forceUpdateFutureProvider).value,
        isA<ReadForceUpdateConfig>()
            .having((s) => s.androidForceUpdate, 'androidForceUpdate', false)
            .having(
              (s) => s.androidLatestVersion,
              'androidLatestVersion',
              '0.0.2',
            )
            .having(
              (s) => s.androidMinRequiredVersion,
              'androidMinRequiredVersion',
              '0.0.1',
            )
            .having(
              (s) => s.forceUpdateConfigId,
              'forceUpdateConfigId',
              'forceUpdateConfig',
            )
            .having(
              (s) => s.iOSForceUpdate,
              'iOSForceUpdate',
              false,
            )
            .having(
              (s) => s.iOSLatestVersion,
              'iOSLatestVersion',
              '0.0.2',
            )
            .having(
              (s) => s.iOSMinRequiredVersion,
              'iOSMinRequiredVersion',
              '0.0.2',
            )
            .having(
              (s) => s.path,
              'path',
              'configurations',
            ),
      );
      // データローディング後はtrueになる
      expect(
        container.read(isForceUpdateProvider),
        true,
      );
    });
    test('iosの時、iOSForceUpdateがtrueだとtrueを返す', () async {
      final mockForceUpdateConfigRepository = MockForceUpdateConfigRepository();
      PackageInfo.setMockInitialValues(
        appName: 'test_mottai_flutter_app_monorepo',
        packageName: 'packageName',
        version: '0.0.1',
        buildNumber: 'buildNumber',
        buildSignature: 'buildSignature',
      );
      final container = ProviderContainer(
        overrides: [
          packageInfoProvider
              .overrideWithValue(await PackageInfo.fromPlatform()),
          isIOSProvider.overrideWithValue(true),
          forceUpdateConfigRepositoryProvider
              .overrideWithValue(mockForceUpdateConfigRepository),
        ],
      );
      // モックリポジトリにより取得するデータを変更する
      when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
          .thenAnswer((_) async* {
        yield const ReadForceUpdateConfig(
          androidForceUpdate: false,
          androidLatestVersion: '0.0.2',
          androidMinRequiredVersion: '0.0.1',
          forceUpdateConfigId: 'forceUpdateConfig',
          iOSForceUpdate: true,
          iOSLatestVersion: '0.0.2',
          iOSMinRequiredVersion: '0.0.1',
          path: 'configurations',
        );
      });
      // プロバイダーをリッスンすることで変更を反映させる
      container.listen(
        forceUpdateFutureProvider,
        (previous, next) {},
        fireImmediately: true,
      );
      // リクエストの結果が戻るのを待つ
      await container.read(forceUpdateFutureProvider.future);
      expect(
        container.read(forceUpdateFutureProvider).value,
        isA<ReadForceUpdateConfig>()
            .having((s) => s.androidForceUpdate, 'androidForceUpdate', false)
            .having(
              (s) => s.androidLatestVersion,
              'androidLatestVersion',
              '0.0.2',
            )
            .having(
              (s) => s.androidMinRequiredVersion,
              'androidMinRequiredVersion',
              '0.0.1',
            )
            .having(
              (s) => s.forceUpdateConfigId,
              'forceUpdateConfigId',
              'forceUpdateConfig',
            )
            .having(
              (s) => s.iOSForceUpdate,
              'iOSForceUpdate',
              true,
            )
            .having(
              (s) => s.iOSLatestVersion,
              'iOSLatestVersion',
              '0.0.2',
            )
            .having(
              (s) => s.iOSMinRequiredVersion,
              'iOSMinRequiredVersion',
              '0.0.1',
            )
            .having(
              (s) => s.path,
              'path',
              'configurations',
            ),
      );
      // 値はtrueになること
      expect(
        container.read(isForceUpdateProvider),
        true,
      );
    });
    test('iosの時、iOSForceUpdateがfalseの場合かつバージョンが範囲外の時はtrue', () async {
      final mockForceUpdateConfigRepository = MockForceUpdateConfigRepository();
      PackageInfo.setMockInitialValues(
        appName: 'test_mottai_flutter_app_monorepo',
        packageName: 'packageName',
        version: '0.0.1',
        buildNumber: 'buildNumber',
        buildSignature: 'buildSignature',
      );
      final container = ProviderContainer(
        overrides: [
          packageInfoProvider
              .overrideWithValue(await PackageInfo.fromPlatform()),
          isIOSProvider.overrideWithValue(true),
          forceUpdateConfigRepositoryProvider
              .overrideWithValue(mockForceUpdateConfigRepository),
        ],
      );
      // モックリポジトリにより取得するデータを変更する
      when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
          .thenAnswer((_) async* {
        yield const ReadForceUpdateConfig(
          androidForceUpdate: false,
          androidLatestVersion: '0.0.2',
          androidMinRequiredVersion: '0.0.1',
          forceUpdateConfigId: 'forceUpdateConfig',
          iOSForceUpdate: false,
          iOSLatestVersion: '0.0.2',
          iOSMinRequiredVersion: '0.0.2',
          path: 'configurations',
        );
      });
      // リクエストの結果が戻るのを待つ
      await container.read(forceUpdateFutureProvider.future);
      // 値はtrueになること
      expect(
        container.read(isForceUpdateProvider),
        true,
      );
    });
    test('iosの時、iOSForceUpdateがfalseの場合かつバージョンが範囲内の時はfalse', () async {
      final mockForceUpdateConfigRepository = MockForceUpdateConfigRepository();
      PackageInfo.setMockInitialValues(
        appName: 'test_mottai_flutter_app_monorepo',
        packageName: 'packageName',
        version: '0.0.1',
        buildNumber: 'buildNumber',
        buildSignature: 'buildSignature',
      );
      final container = ProviderContainer(
        overrides: [
          packageInfoProvider
              .overrideWithValue(await PackageInfo.fromPlatform()),
          isIOSProvider.overrideWithValue(true),
          forceUpdateConfigRepositoryProvider
              .overrideWithValue(mockForceUpdateConfigRepository),
        ],
      );
      // モックリポジトリにより取得するデータを変更する
      when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
          .thenAnswer((_) async* {
        yield const ReadForceUpdateConfig(
          androidForceUpdate: false,
          androidLatestVersion: '0.0.2',
          androidMinRequiredVersion: '0.0.1',
          forceUpdateConfigId: 'forceUpdateConfig',
          iOSForceUpdate: false,
          iOSLatestVersion: '0.0.2',
          iOSMinRequiredVersion: '0.0.1',
          path: 'configurations',
        );
      });
      // リクエストの結果が戻るのを待つ
      await container.read(forceUpdateFutureProvider.future);
      // 値はtrueになること
      expect(
        container.read(isForceUpdateProvider),
        false,
      );
    });
    test('androidの時、androidForceUpdateがtrueだとtrueを返す', () async {
      final mockForceUpdateConfigRepository = MockForceUpdateConfigRepository();
      PackageInfo.setMockInitialValues(
        appName: 'test_mottai_flutter_app_monorepo',
        packageName: 'packageName',
        version: '0.0.1',
        buildNumber: 'buildNumber',
        buildSignature: 'buildSignature',
      );
      final container = ProviderContainer(
        overrides: [
          packageInfoProvider
              .overrideWithValue(await PackageInfo.fromPlatform()),
          isIOSProvider.overrideWithValue(false),
          forceUpdateConfigRepositoryProvider
              .overrideWithValue(mockForceUpdateConfigRepository),
        ],
      );
      // モックリポジトリにより取得するデータを変更する
      when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
          .thenAnswer((_) async* {
        yield const ReadForceUpdateConfig(
          androidForceUpdate: true,
          androidLatestVersion: '0.0.2',
          androidMinRequiredVersion: '0.0.1',
          forceUpdateConfigId: 'forceUpdateConfig',
          iOSForceUpdate: false,
          iOSLatestVersion: '0.0.2',
          iOSMinRequiredVersion: '0.0.1',
          path: 'configurations',
        );
      });
      // リクエストの結果が戻るのを待つ
      await container.read(forceUpdateFutureProvider.future);
      // 値はtrueになること
      expect(
        container.read(isForceUpdateProvider),
        true,
      );
    });
    test('androidの時、androidForceUpdateがfalseの場合かつバージョンが範囲外の時はtrue', () async {
      final mockForceUpdateConfigRepository = MockForceUpdateConfigRepository();
      PackageInfo.setMockInitialValues(
        appName: 'test_mottai_flutter_app_monorepo',
        packageName: 'packageName',
        version: '0.0.1',
        buildNumber: 'buildNumber',
        buildSignature: 'buildSignature',
      );
      final container = ProviderContainer(
        overrides: [
          packageInfoProvider
              .overrideWithValue(await PackageInfo.fromPlatform()),
          isIOSProvider.overrideWithValue(false),
          forceUpdateConfigRepositoryProvider
              .overrideWithValue(mockForceUpdateConfigRepository),
        ],
      );
      // モックリポジトリにより取得するデータを変更する
      when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
          .thenAnswer((_) async* {
        yield const ReadForceUpdateConfig(
          androidForceUpdate: false,
          androidLatestVersion: '0.0.2',
          androidMinRequiredVersion: '0.0.2',
          forceUpdateConfigId: 'forceUpdateConfig',
          iOSForceUpdate: false,
          iOSLatestVersion: '0.0.2',
          iOSMinRequiredVersion: '0.0.1',
          path: 'configurations',
        );
      });
      // リクエストの結果が戻るのを待つ
      await container.read(forceUpdateFutureProvider.future);
      // 値はtrueになること
      expect(
        container.read(isForceUpdateProvider),
        true,
      );
    });
    test('androidの時、androidForceUpdateがfalseの場合かつバージョンが範囲内の時はfalse', () async {
      final mockForceUpdateConfigRepository = MockForceUpdateConfigRepository();
      PackageInfo.setMockInitialValues(
        appName: 'test_mottai_flutter_app_monorepo',
        packageName: 'packageName',
        version: '0.0.1',
        buildNumber: 'buildNumber',
        buildSignature: 'buildSignature',
      );
      final container = ProviderContainer(
        overrides: [
          packageInfoProvider
              .overrideWithValue(await PackageInfo.fromPlatform()),
          isIOSProvider.overrideWithValue(false),
          forceUpdateConfigRepositoryProvider
              .overrideWithValue(mockForceUpdateConfigRepository),
        ],
      );
      // モックリポジトリにより取得するデータを変更する
      when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
          .thenAnswer((_) async* {
        yield const ReadForceUpdateConfig(
          androidForceUpdate: false,
          androidLatestVersion: '0.0.2',
          androidMinRequiredVersion: '0.0.1',
          forceUpdateConfigId: 'forceUpdateConfig',
          iOSForceUpdate: false,
          iOSLatestVersion: '0.0.2',
          iOSMinRequiredVersion: '0.0.1',
          path: 'configurations',
        );
      });
      // リクエストの結果が戻るのを待つ
      await container.read(forceUpdateFutureProvider.future);
      // 値はtrueになること
      expect(
        container.read(isForceUpdateProvider),
        false,
      );
    });
    test('fireStoreから取得した数値がおかしな場合はfalseを返す', () async {
      final mockForceUpdateConfigRepository = MockForceUpdateConfigRepository();
      PackageInfo.setMockInitialValues(
        appName: 'test_mottai_flutter_app_monorepo',
        packageName: 'packageName',
        version: '0.0.1',
        buildNumber: 'buildNumber',
        buildSignature: 'buildSignature',
      );
      final container = ProviderContainer(
        overrides: [
          packageInfoProvider
              .overrideWithValue(await PackageInfo.fromPlatform()),
          isIOSProvider.overrideWithValue(false),
          forceUpdateConfigRepositoryProvider
              .overrideWithValue(mockForceUpdateConfigRepository),
        ],
      );
      // モックリポジトリにより取得するデータを変更する
      when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
          .thenAnswer((_) async* {
        yield const ReadForceUpdateConfig(
          androidForceUpdate: false,
          androidLatestVersion: 'おかしな値1',
          androidMinRequiredVersion: 'おかしな値2',
          forceUpdateConfigId: 'forceUpdateConfig',
          iOSForceUpdate: false,
          iOSLatestVersion: 'おかしな値3',
          iOSMinRequiredVersion: 'おかしな値4',
          path: 'configurations',
        );
      });
      // リクエストの結果が戻るのを待つ
      await container.read(forceUpdateFutureProvider.future);
      // 値はtrueになること
      expect(
        container.read(isForceUpdateProvider),
        false,
      );
    });
  });
}
