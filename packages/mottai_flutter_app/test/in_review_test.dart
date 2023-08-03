import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mottai_flutter_app/development/in_review/in_review.dart';
import 'package:mottai_flutter_app/firestore_repository.dart';
import 'package:mottai_flutter_app/package_info.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'in_review_test.mocks.dart';

@GenerateNiceMocks([MockSpec<InReviewConfigRepository>()])
Future<void> main() async {
  setUpAll(
    () {
      PackageInfo.setMockInitialValues(
        appName: 'test_mottai_flutter_app',
        packageName: 'packageName',
        version: '0.0.1',
        buildNumber: 'buildNumber',
        buildSignature: 'buildSignature',
      );
    },
  );
  group('iOSのテスト', () {
    setUpAll(() {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    });
    test('ローディング中はfalseを返す', () async {
      final mockInReviewConfigRepository = MockInReviewConfigRepository();
      final container = ProviderContainer(
        overrides: [
          packageInfoProvider
              .overrideWithValue(await PackageInfo.fromPlatform()),
          inReviewConfigRepositoryProvider
              .overrideWithValue(mockInReviewConfigRepository),
        ],
      );
      // モックリポジトリにより取得するデータを変更する
      when(mockInReviewConfigRepository.subscribeInReviewConfig())
          .thenAnswer((_) async* {
        yield const ReadInReviewConfig(
          androidInReviewVersion: '0.0.1',
          enableAndroidInReviewMode: false,
          enableIOSInReviewMode: false,
          iOSInReviewVersion: '0.0.1',
          inReviewConfigId: 'inReviewConfig',
          path: 'configurations',
        );
      });

      // プロバイダーをリッスンすることで変更を反映させる
      container.listen(
        inReviewStreamProvider,
        (previous, next) {},
        fireImmediately: true,
      );
      // ローディング中を確認
      expect(
        container.read(inReviewStreamProvider),
        const AsyncValue<ReadInReviewConfig?>.loading(),
      );
      // ローディング中はfalseを返す
      expect(
        container.read(isInReviewProvider),
        false,
      );
    });

    group('レビュー中', () {
      test('バージョン同じ', () async {
        final mockInReviewConfigRepository = MockInReviewConfigRepository();
        final container = ProviderContainer(
          overrides: [
            packageInfoProvider
                .overrideWithValue(await PackageInfo.fromPlatform()),
            inReviewConfigRepositoryProvider
                .overrideWithValue(mockInReviewConfigRepository),
          ],
        );
        // モックリポジトリにより取得するデータを変更する
        when(mockInReviewConfigRepository.subscribeInReviewConfig())
            .thenAnswer((_) async* {
          yield const ReadInReviewConfig(
            androidInReviewVersion: '0.0.1',
            enableAndroidInReviewMode: true,
            enableIOSInReviewMode: true,
            iOSInReviewVersion: '0.0.1',
            inReviewConfigId: 'inReviewConfig',
            path: 'configurations',
          );
        });

        // プロバイダーをリッスンすることで変更を反映させる
        container.listen(
          inReviewStreamProvider,
          (previous, next) {},
          fireImmediately: true,
        );
        // リクエストの結果が戻るのを待つ
        await container.read(inReviewStreamProvider.future);

        expect(
          container.read(isInReviewProvider),
          true,
        );
      });

      test('バージョン異なる', () async {
        final mockInReviewConfigRepository = MockInReviewConfigRepository();
        final container = ProviderContainer(
          overrides: [
            packageInfoProvider
                .overrideWithValue(await PackageInfo.fromPlatform()),
            inReviewConfigRepositoryProvider
                .overrideWithValue(mockInReviewConfigRepository),
          ],
        );
        // モックリポジトリにより取得するデータを変更する
        when(mockInReviewConfigRepository.subscribeInReviewConfig())
            .thenAnswer((_) async* {
          yield const ReadInReviewConfig(
            androidInReviewVersion: '0.0.1',
            enableAndroidInReviewMode: true,
            enableIOSInReviewMode: true,
            iOSInReviewVersion: '0.0.2',
            inReviewConfigId: 'inReviewConfig',
            path: 'configurations',
          );
        });

        // プロバイダーをリッスンすることで変更を反映させる
        container.listen(
          inReviewStreamProvider,
          (previous, next) {},
          fireImmediately: true,
        );
        // リクエストの結果が戻るのを待つ
        await container.read(inReviewStreamProvider.future);

        expect(
          container.read(isInReviewProvider),
          false,
        );
      });
    });
    group('レビューしてない', () {
      test('バージョン同じ', () async {
        final mockInReviewConfigRepository = MockInReviewConfigRepository();
        final container = ProviderContainer(
          overrides: [
            packageInfoProvider
                .overrideWithValue(await PackageInfo.fromPlatform()),
            inReviewConfigRepositoryProvider
                .overrideWithValue(mockInReviewConfigRepository),
          ],
        );
        // モックリポジトリにより取得するデータを変更する
        when(mockInReviewConfigRepository.subscribeInReviewConfig())
            .thenAnswer((_) async* {
          yield const ReadInReviewConfig(
            androidInReviewVersion: '0.0.1',
            enableAndroidInReviewMode: false,
            enableIOSInReviewMode: false,
            iOSInReviewVersion: '0.0.1',
            inReviewConfigId: 'inReviewConfig',
            path: 'configurations',
          );
        });

        // プロバイダーをリッスンすることで変更を反映させる
        container.listen(
          inReviewStreamProvider,
          (previous, next) {},
          fireImmediately: true,
        );
        // リクエストの結果が戻るのを待つ
        await container.read(inReviewStreamProvider.future);

        expect(
          container.read(isInReviewProvider),
          false,
        );
      });

      test('バージョン異なる', () async {
        final mockInReviewConfigRepository = MockInReviewConfigRepository();
        final container = ProviderContainer(
          overrides: [
            packageInfoProvider
                .overrideWithValue(await PackageInfo.fromPlatform()),
            inReviewConfigRepositoryProvider
                .overrideWithValue(mockInReviewConfigRepository),
          ],
        );
        // モックリポジトリにより取得するデータを変更する
        when(mockInReviewConfigRepository.subscribeInReviewConfig())
            .thenAnswer((_) async* {
          yield const ReadInReviewConfig(
            androidInReviewVersion: '0.0.1',
            enableAndroidInReviewMode: false,
            enableIOSInReviewMode: false,
            iOSInReviewVersion: '0.0.2',
            inReviewConfigId: 'inReviewConfig',
            path: 'configurations',
          );
        });

        // プロバイダーをリッスンすることで変更を反映させる
        container.listen(
          inReviewStreamProvider,
          (previous, next) {},
          fireImmediately: true,
        );
        // リクエストの結果が戻るのを待つ
        await container.read(inReviewStreamProvider.future);

        expect(
          container.read(isInReviewProvider),
          false,
        );
      });
      test('おかしな値を取得したとき', () async {
        final mockInReviewConfigRepository = MockInReviewConfigRepository();
        final container = ProviderContainer(
          overrides: [
            packageInfoProvider
                .overrideWithValue(await PackageInfo.fromPlatform()),
            inReviewConfigRepositoryProvider
                .overrideWithValue(mockInReviewConfigRepository),
          ],
        );
        // モックリポジトリにより取得するデータを変更する
        when(mockInReviewConfigRepository.subscribeInReviewConfig())
            .thenAnswer((_) async* {
          yield const ReadInReviewConfig(
            androidInReviewVersion: 'あああ',
            enableAndroidInReviewMode: false,
            enableIOSInReviewMode: false,
            iOSInReviewVersion: 'ああああ',
            inReviewConfigId: 'inReviewConfig',
            path: 'configurations',
          );
        });
        // リクエストの結果が戻るのを待つ
        await container.read(inReviewStreamProvider.future);
        expect(
          container.read(isInReviewProvider),
          false,
        );
      });
    });
  });
  group('androidのテスト', () {
    setUpAll(() {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
    });
    test('ローディング中はfalseを返す', () async {
      final mockInReviewConfigRepository = MockInReviewConfigRepository();
      final container = ProviderContainer(
        overrides: [
          packageInfoProvider
              .overrideWithValue(await PackageInfo.fromPlatform()),
          inReviewConfigRepositoryProvider
              .overrideWithValue(mockInReviewConfigRepository),
        ],
      );
      // モックリポジトリにより取得するデータを変更する
      when(mockInReviewConfigRepository.subscribeInReviewConfig())
          .thenAnswer((_) async* {
        yield const ReadInReviewConfig(
          androidInReviewVersion: '0.0.1',
          enableAndroidInReviewMode: false,
          enableIOSInReviewMode: false,
          iOSInReviewVersion: '0.0.1',
          inReviewConfigId: 'inReviewConfig',
          path: 'configurations',
        );
      });

      // プロバイダーをリッスンすることで変更を反映させる
      container.listen(
        inReviewStreamProvider,
        (previous, next) {},
        fireImmediately: true,
      );
      // ローディング中を確認
      expect(
        container.read(inReviewStreamProvider),
        const AsyncValue<ReadInReviewConfig?>.loading(),
      );
      // ローディング中はfalseを返す
      expect(
        container.read(isInReviewProvider),
        false,
      );
    });

    group('レビュー中', () {
      test('バージョン同じ', () async {
        final mockInReviewConfigRepository = MockInReviewConfigRepository();
        final container = ProviderContainer(
          overrides: [
            packageInfoProvider
                .overrideWithValue(await PackageInfo.fromPlatform()),
            inReviewConfigRepositoryProvider
                .overrideWithValue(mockInReviewConfigRepository),
          ],
        );
        // モックリポジトリにより取得するデータを変更する
        when(mockInReviewConfigRepository.subscribeInReviewConfig())
            .thenAnswer((_) async* {
          yield const ReadInReviewConfig(
            androidInReviewVersion: '0.0.1',
            enableAndroidInReviewMode: true,
            enableIOSInReviewMode: true,
            iOSInReviewVersion: '0.0.1',
            inReviewConfigId: 'inReviewConfig',
            path: 'configurations',
          );
        });

        // プロバイダーをリッスンすることで変更を反映させる
        container.listen(
          inReviewStreamProvider,
          (previous, next) {},
          fireImmediately: true,
        );
        // リクエストの結果が戻るのを待つ
        await container.read(inReviewStreamProvider.future);

        expect(
          container.read(isInReviewProvider),
          true,
        );
      });

      test('バージョン異なる', () async {
        final mockInReviewConfigRepository = MockInReviewConfigRepository();
        final container = ProviderContainer(
          overrides: [
            packageInfoProvider
                .overrideWithValue(await PackageInfo.fromPlatform()),
            inReviewConfigRepositoryProvider
                .overrideWithValue(mockInReviewConfigRepository),
          ],
        );
        // モックリポジトリにより取得するデータを変更する
        when(mockInReviewConfigRepository.subscribeInReviewConfig())
            .thenAnswer((_) async* {
          yield const ReadInReviewConfig(
            androidInReviewVersion: '0.0.2',
            enableAndroidInReviewMode: true,
            enableIOSInReviewMode: true,
            iOSInReviewVersion: '0.0.2',
            inReviewConfigId: 'inReviewConfig',
            path: 'configurations',
          );
        });

        // プロバイダーをリッスンすることで変更を反映させる
        container.listen(
          inReviewStreamProvider,
          (previous, next) {},
          fireImmediately: true,
        );
        // リクエストの結果が戻るのを待つ
        await container.read(inReviewStreamProvider.future);

        expect(
          container.read(isInReviewProvider),
          false,
        );
      });
    });
    group('レビューしてない', () {
      test('バージョン同じ', () async {
        final mockInReviewConfigRepository = MockInReviewConfigRepository();
        final container = ProviderContainer(
          overrides: [
            packageInfoProvider
                .overrideWithValue(await PackageInfo.fromPlatform()),
            inReviewConfigRepositoryProvider
                .overrideWithValue(mockInReviewConfigRepository),
          ],
        );
        // モックリポジトリにより取得するデータを変更する
        when(mockInReviewConfigRepository.subscribeInReviewConfig())
            .thenAnswer((_) async* {
          yield const ReadInReviewConfig(
            androidInReviewVersion: '0.0.1',
            enableAndroidInReviewMode: false,
            enableIOSInReviewMode: false,
            iOSInReviewVersion: '0.0.1',
            inReviewConfigId: 'inReviewConfig',
            path: 'configurations',
          );
        });

        // プロバイダーをリッスンすることで変更を反映させる
        container.listen(
          inReviewStreamProvider,
          (previous, next) {},
          fireImmediately: true,
        );
        // リクエストの結果が戻るのを待つ
        await container.read(inReviewStreamProvider.future);

        expect(
          container.read(isInReviewProvider),
          false,
        );
      });

      test('バージョン異なる', () async {
        final mockInReviewConfigRepository = MockInReviewConfigRepository();
        final container = ProviderContainer(
          overrides: [
            packageInfoProvider
                .overrideWithValue(await PackageInfo.fromPlatform()),
            inReviewConfigRepositoryProvider
                .overrideWithValue(mockInReviewConfigRepository),
          ],
        );
        // モックリポジトリにより取得するデータを変更する
        when(mockInReviewConfigRepository.subscribeInReviewConfig())
            .thenAnswer((_) async* {
          yield const ReadInReviewConfig(
            androidInReviewVersion: '0.0.2',
            enableAndroidInReviewMode: false,
            enableIOSInReviewMode: false,
            iOSInReviewVersion: '0.0.2',
            inReviewConfigId: 'inReviewConfig',
            path: 'configurations',
          );
        });

        // プロバイダーをリッスンすることで変更を反映させる
        container.listen(
          inReviewStreamProvider,
          (previous, next) {},
          fireImmediately: true,
        );
        // リクエストの結果が戻るのを待つ
        await container.read(inReviewStreamProvider.future);

        expect(
          container.read(isInReviewProvider),
          false,
        );
      });
    });
    test('おかしな値を取得したとき', () async {
      final mockInReviewConfigRepository = MockInReviewConfigRepository();
      final container = ProviderContainer(
        overrides: [
          packageInfoProvider
              .overrideWithValue(await PackageInfo.fromPlatform()),
          inReviewConfigRepositoryProvider
              .overrideWithValue(mockInReviewConfigRepository),
        ],
      );
      // モックリポジトリにより取得するデータを変更する
      when(mockInReviewConfigRepository.subscribeInReviewConfig())
          .thenAnswer((_) async* {
        yield const ReadInReviewConfig(
          androidInReviewVersion: 'あああ',
          enableAndroidInReviewMode: false,
          enableIOSInReviewMode: false,
          iOSInReviewVersion: 'ああああ',
          inReviewConfigId: 'inReviewConfig',
          path: 'configurations',
        );
      });
      // リクエストの結果が戻るのを待つ
      await container.read(inReviewStreamProvider.future);
      expect(
        container.read(isInReviewProvider),
        false,
      );
    });
  });
}
