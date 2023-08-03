// import 'package:firebase_common/firebase_common.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:mottai_flutter_app/firestore_repository.dart';
// import 'package:mottai_flutter_app/force_update/force_update.dart';
// import 'package:mottai_flutter_app/package_info.dart';
// import 'package:package_info_plus/package_info_plus.dart';

// import 'force_update_test.mocks.dart';

// @GenerateNiceMocks([MockSpec<ForceUpdateConfigRepository>()])
// Future<void> main() async {
//   group('データローディング中はfalseを返す', () {
//     test('iOSの時ローディング中はfalseを返す', () async {
//       debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
//       final mockForceUpdateConfigRepository = MockForceUpdateConfigRepository
// ();
//       PackageInfo.setMockInitialValues(
//         appName: 'test_mottai_flutter_app',
//         packageName: 'packageName',
//         version: '0.0.1',
//         buildNumber: 'buildNumber',
//         buildSignature: 'buildSignature',
//       );
//       final container = ProviderContainer(
//         overrides: [
//           packageInfoProvider
//               .overrideWithValue(await PackageInfo.fromPlatform()),
//           forceUpdateConfigRepositoryProvider
//               .overrideWithValue(mockForceUpdateConfigRepository),
//         ],
//       );
//       // モックリポジトリにより取得するデータを変更する
//       when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
//           .thenAnswer((_) async* {
//         yield const ReadForceUpdateConfig(
//           androidForceUpdate: false,
//           androidLatestVersion: '0.0.2',
//           androidMinRequiredVersion: '0.0.1',
//           forceUpdateConfigId: 'forceUpdateConfigId',
//           iOSForceUpdate: false,
//           iOSLatestVersion: '0.0.2',
//           iOSMinRequiredVersion: '0.0.1',
//           path: 'configurations',
//         );
//       });
//       // プロバイダーをリッスンすることで変更を反映させる
//       container.listen(
//         forceUpdateStreamProvider,
//         (previous, next) {},
//         fireImmediately: true,
//       );
//       expect(
//         container.read(forceUpdateStreamProvider),
//         const AsyncValue<ReadForceUpdateConfig?>.loading(),
//       );
//       // ローディング中はfalseを返す
//       expect(
//         container.read(isForceUpdateRequiredProvider),
//         false,
//       );
//       // リクエストの結果が戻るのを待つ
//       await container.read(forceUpdateStreamProvider.future);
//       // 取得したデータがmockitoで設定した値と同じであること
//       expect(
//         container.read(forceUpdateStreamProvider).value,
//         isA<ReadForceUpdateConfig>()
//             .having((s) => s.androidForceUpdate, 'androidForceUpdate', false)
//             .having(
//               (s) => s.androidLatestVersion,
//               'androidLatestVersion',
//               '0.0.2',
//             )
//             .having(
//               (s) => s.androidMinRequiredVersion,
//               'androidMinRequiredVersion',
//               '0.0.1',
//             )
//             .having(
//               (s) => s.forceUpdateConfigId,
//               'forceUpdateConfigId',
//               'forceUpdateConfigId',
//             )
//             .having(
//               (s) => s.iOSForceUpdate,
//               'iOSForceUpdate',
//               false,
//             )
//             .having(
//               (s) => s.iOSLatestVersion,
//               'iOSLatestVersion',
//               '0.0.2',
//             )
//             .having(
//               (s) => s.iOSMinRequiredVersion,
//               'iOSMinRequiredVersion',
//               '0.0.1',
//             )
//             .having(
//               (s) => s.path,
//               'path',
//               'configurations',
//             ),
//       );
//     });
//     test('androidの時ローディング中はfalseを返す', () async {
//       debugDefaultTargetPlatformOverride = TargetPlatform.android;
//       final mockForceUpdateConfigRepository = MockForceUpdateConfigRepository
// ();
//       PackageInfo.setMockInitialValues(
//         appName: 'test_mottai_flutter_app',
//         packageName: 'packageName',
//         version: '0.0.1',
//         buildNumber: 'buildNumber',
//         buildSignature: 'buildSignature',
//       );
//       final container = ProviderContainer(
//         overrides: [
//           packageInfoProvider
//               .overrideWithValue(await PackageInfo.fromPlatform()),
//           forceUpdateConfigRepositoryProvider
//               .overrideWithValue(mockForceUpdateConfigRepository),
//         ],
//       );
//       // モックリポジトリにより取得するデータを変更する
//       when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
//           .thenAnswer((_) async* {
//         yield const ReadForceUpdateConfig(
//           androidForceUpdate: false,
//           androidLatestVersion: '0.0.2',
//           androidMinRequiredVersion: '0.0.1',
//           forceUpdateConfigId: 'forceUpdateConfigId',
//           iOSForceUpdate: false,
//           iOSLatestVersion: '0.0.2',
//           iOSMinRequiredVersion: '0.0.1',
//           path: 'configurations',
//         );
//       });
//       // プロバイダーをリッスンすることで変更を反映させる
//       container.listen(
//         forceUpdateStreamProvider,
//         (previous, next) {},
//         fireImmediately: true,
//       );
//       expect(
//         container.read(forceUpdateStreamProvider),
//         const AsyncValue<ReadForceUpdateConfig?>.loading(),
//       );
//       // ローディング中はfalseを返す
//       expect(
//         container.read(isForceUpdateRequiredProvider),
//         false,
//       );
//       // リクエストの結果が戻るのを待つ
//       await container.read(forceUpdateStreamProvider.future);
//       // 取得したデータがmockitoで設定した値と同じであること
//       expect(
//         container.read(forceUpdateStreamProvider).value,
//         isA<ReadForceUpdateConfig>()
//             .having((s) => s.androidForceUpdate, 'androidForceUpdate', false)
//             .having(
//               (s) => s.androidLatestVersion,
//               'androidLatestVersion',
//               '0.0.2',
//             )
//             .having(
//               (s) => s.androidMinRequiredVersion,
//               'androidMinRequiredVersion',
//               '0.0.1',
//             )
//             .having(
//               (s) => s.forceUpdateConfigId,
//               'forceUpdateConfigId',
//               'forceUpdateConfigId',
//             )
//             .having(
//               (s) => s.iOSForceUpdate,
//               'iOSForceUpdate',
//               false,
//             )
//             .having(
//               (s) => s.iOSLatestVersion,
//               'iOSLatestVersion',
//               '0.0.2',
//             )
//             .having(
//               (s) => s.iOSMinRequiredVersion,
//               'iOSMinRequiredVersion',
//               '0.0.1',
//             )
//             .having(
//               (s) => s.path,
//               'path',
//               'configurations',
//             ),
//       );
//     });
//   });
//   group('iOS強制アップデートテスト', () {
//     setUpAll(() => debugDefaultTargetPlatformOverride = TargetPlatform.iOS);
//     group('強制アップデートfalse(forceUpdate=false)', () {
//       test('現在バージョン<最低限バージョンはfalseを返す', () async {
//         final mockForceUpdateConfigRepository =
//             MockForceUpdateConfigRepository();
//         PackageInfo.setMockInitialValues(
//           appName: 'test_mottai_flutter_app',
//           packageName: 'packageName',
//           version: '0.0.1',
//           buildNumber: 'buildNumber',
//           buildSignature: 'buildSignature',
//         );
//         final container = ProviderContainer(
//           overrides: [
//             packageInfoProvider
//                 .overrideWithValue(await PackageInfo.fromPlatform()),
//             forceUpdateConfigRepositoryProvider
//                 .overrideWithValue(mockForceUpdateConfigRepository),
//           ],
//         );
//         // モックリポジトリにより取得するデータを変更する
//         when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
//             .thenAnswer((_) async* {
//           yield const ReadForceUpdateConfig(
//             androidForceUpdate: false,
//             androidLatestVersion: '0.0.2',
//             androidMinRequiredVersion: '0.0.1',
//             forceUpdateConfigId: 'forceUpdateConfig',
//             iOSForceUpdate: false,
//             iOSLatestVersion: '0.0.2',
//             iOSMinRequiredVersion: '0.0.2',
//             path: 'configurations',
//           );
//         });
//         // リクエストの結果が戻るのを待つ
//         await container.read(forceUpdateStreamProvider.future);
//         expect(
//           container.read(isForceUpdateRequiredProvider),
//           false,
//         );
//       });
//       test('現在バージョン<=最低限バージョンはfalseを返す', () async {
//         final mockForceUpdateConfigRepository =
//             MockForceUpdateConfigRepository();
//         PackageInfo.setMockInitialValues(
//           appName: 'test_mottai_flutter_app',
//           packageName: 'packageName',
//           version: '0.0.1',
//           buildNumber: 'buildNumber',
//           buildSignature: 'buildSignature',
//         );
//         final container = ProviderContainer(
//           overrides: [
//             packageInfoProvider
//                 .overrideWithValue(await PackageInfo.fromPlatform()),
//             forceUpdateConfigRepositoryProvider
//                 .overrideWithValue(mockForceUpdateConfigRepository),
//           ],
//         );
//         // モックリポジトリにより取得するデータを変更する
//         when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
//             .thenAnswer((_) async* {
//           yield const ReadForceUpdateConfig(
//             androidForceUpdate: false,
//             androidLatestVersion: '0.0.2',
//             androidMinRequiredVersion: '0.0.1',
//             forceUpdateConfigId: 'forceUpdateConfig',
//             iOSForceUpdate: false,
//             iOSLatestVersion: '0.0.2',
//             iOSMinRequiredVersion: '0.0.1',
//             path: 'configurations',
//           );
//         });
//         // リクエストの結果が戻るのを待つ
//         await container.read(forceUpdateStreamProvider.future);
//         expect(
//           container.read(isForceUpdateRequiredProvider),
//           false,
//         );
//       });
//       test('現在バージョン>最低限バージョンはfalseを返す', () async {
//         final mockForceUpdateConfigRepository =
//             MockForceUpdateConfigRepository();
//         PackageInfo.setMockInitialValues(
//           appName: 'test_mottai_flutter_app',
//           packageName: 'packageName',
//           version: '0.0.2',
//           buildNumber: 'buildNumber',
//           buildSignature: 'buildSignature',
//         );
//         final container = ProviderContainer(
//           overrides: [
//             packageInfoProvider
//                 .overrideWithValue(await PackageInfo.fromPlatform()),
//             forceUpdateConfigRepositoryProvider
//                 .overrideWithValue(mockForceUpdateConfigRepository),
//           ],
//         );
//         // モックリポジトリにより取得するデータを変更する
//         when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
//             .thenAnswer((_) async* {
//           yield const ReadForceUpdateConfig(
//             androidForceUpdate: false,
//             androidLatestVersion: '0.0.2',
//             androidMinRequiredVersion: '0.0.1',
//             forceUpdateConfigId: 'forceUpdateConfig',
//             iOSForceUpdate: false,
//             iOSLatestVersion: '0.0.2',
//             iOSMinRequiredVersion: '0.0.1',
//             path: 'configurations',
//           );
//         });
//         // リクエストの結果が戻るのを待つ
//         await container.read(forceUpdateStreamProvider.future);
//         expect(
//           container.read(isForceUpdateRequiredProvider),
//           false,
//         );
//       });
//     });
//     group('強制アップデートtrue(forceUpdate=true)', () {
//       test('現在バージョン<最低限バージョンはtrueを返す', () async {
//         final mockForceUpdateConfigRepository =
//             MockForceUpdateConfigRepository();
//         PackageInfo.setMockInitialValues(
//           appName: 'test_mottai_flutter_app',
//           packageName: 'packageName',
//           version: '0.0.1',
//           buildNumber: 'buildNumber',
//           buildSignature: 'buildSignature',
//         );
//         final container = ProviderContainer(
//           overrides: [
//             packageInfoProvider
//                 .overrideWithValue(await PackageInfo.fromPlatform()),
//             forceUpdateConfigRepositoryProvider
//                 .overrideWithValue(mockForceUpdateConfigRepository),
//           ],
//         );
//         // モックリポジトリにより取得するデータを変更する
//         when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
//             .thenAnswer((_) async* {
//           yield const ReadForceUpdateConfig(
//             androidForceUpdate: true,
//             androidLatestVersion: '0.0.2',
//             androidMinRequiredVersion: '0.0.1',
//             forceUpdateConfigId: 'forceUpdateConfig',
//             iOSForceUpdate: true,
//             iOSLatestVersion: '0.0.2',
//             iOSMinRequiredVersion: '0.0.2',
//             path: 'configurations',
//           );
//         });
//         // リクエストの結果が戻るのを待つ
//         await container.read(forceUpdateStreamProvider.future);
//         // 値はtrueになること
//         expect(
//           container.read(isForceUpdateRequiredProvider),
//           true,
//         );
//       });
//       test('現在バージョン<=最低限バージョンはfalseを返す', () async {
//         final mockForceUpdateConfigRepository =
//             MockForceUpdateConfigRepository();
//         PackageInfo.setMockInitialValues(
//           appName: 'test_mottai_flutter_app',
//           packageName: 'packageName',
//           version: '0.0.1',
//           buildNumber: 'buildNumber',
//           buildSignature: 'buildSignature',
//         );
//         final container = ProviderContainer(
//           overrides: [
//             packageInfoProvider
//                 .overrideWithValue(await PackageInfo.fromPlatform()),
//             forceUpdateConfigRepositoryProvider
//                 .overrideWithValue(mockForceUpdateConfigRepository),
//           ],
//         );
//         // モックリポジトリにより取得するデータを変更する
//         when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
//             .thenAnswer((_) async* {
//           yield const ReadForceUpdateConfig(
//             androidForceUpdate: true,
//             androidLatestVersion: '0.0.2',
//             androidMinRequiredVersion: '0.0.1',
//             forceUpdateConfigId: 'forceUpdateConfig',
//             iOSForceUpdate: true,
//             iOSLatestVersion: '0.0.2',
//             iOSMinRequiredVersion: '0.0.1',
//             path: 'configurations',
//           );
//         });
//         // リクエストの結果が戻るのを待つ
//         await container.read(forceUpdateStreamProvider.future);
//         expect(
//           container.read(isForceUpdateRequiredProvider),
//           false,
//         );
//       });
//       test('現在バージョン>最低限バージョンはfalseを返す', () async {
//         final mockForceUpdateConfigRepository =
//             MockForceUpdateConfigRepository();
//         PackageInfo.setMockInitialValues(
//           appName: 'test_mottai_flutter_app',
//           packageName: 'packageName',
//           version: '0.0.2',
//           buildNumber: 'buildNumber',
//           buildSignature: 'buildSignature',
//         );
//         final container = ProviderContainer(
//           overrides: [
//             packageInfoProvider
//                 .overrideWithValue(await PackageInfo.fromPlatform()),
//             forceUpdateConfigRepositoryProvider
//                 .overrideWithValue(mockForceUpdateConfigRepository),
//           ],
//         );
//         // モックリポジトリにより取得するデータを変更する
//         when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
//             .thenAnswer((_) async* {
//           yield const ReadForceUpdateConfig(
//             androidForceUpdate: true,
//             androidLatestVersion: '0.0.2',
//             androidMinRequiredVersion: '0.0.1',
//             forceUpdateConfigId: 'forceUpdateConfig',
//             iOSForceUpdate: true,
//             iOSLatestVersion: '0.0.2',
//             iOSMinRequiredVersion: '0.0.1',
//             path: 'configurations',
//           );
//         });
//         // リクエストの結果が戻るのを待つ
//         await container.read(forceUpdateStreamProvider.future);
//         expect(
//           container.read(isForceUpdateRequiredProvider),
//           false,
//         );
//       });
//     });
//   });
//   group('android強制アップデートテスト', () {
//     setUpAll(() => debugDefaultTargetPlatformOverride = 
// TargetPlatform.android);
//     group('強制アップデートfalse(forceUpdate=false)', () {
//       test('現在バージョン<最低限バージョンはfalseを返す', () async {
//         final mockForceUpdateConfigRepository =
//             MockForceUpdateConfigRepository();
//         PackageInfo.setMockInitialValues(
//           appName: 'test_mottai_flutter_app',
//           packageName: 'packageName',
//           version: '0.0.1',
//           buildNumber: 'buildNumber',
//           buildSignature: 'buildSignature',
//         );
//         final container = ProviderContainer(
//           overrides: [
//             packageInfoProvider
//                 .overrideWithValue(await PackageInfo.fromPlatform()),
//             forceUpdateConfigRepositoryProvider
//                 .overrideWithValue(mockForceUpdateConfigRepository),
//           ],
//         );
//         // モックリポジトリにより取得するデータを変更する
//         when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
//             .thenAnswer((_) async* {
//           yield const ReadForceUpdateConfig(
//             androidForceUpdate: false,
//             androidLatestVersion: '0.0.2',
//             androidMinRequiredVersion: '0.0.2',
//             forceUpdateConfigId: 'forceUpdateConfig',
//             iOSForceUpdate: false,
//             iOSLatestVersion: '0.0.2',
//             iOSMinRequiredVersion: '0.0.1',
//             path: 'configurations',
//           );
//         });
//         // リクエストの結果が戻るのを待つ
//         await container.read(forceUpdateStreamProvider.future);
//         expect(
//           container.read(isForceUpdateRequiredProvider),
//           false,
//         );
//       });
//       test('現在バージョン<=最低限バージョンはfalseを返す', () async {
//         final mockForceUpdateConfigRepository =
//             MockForceUpdateConfigRepository();
//         PackageInfo.setMockInitialValues(
//           appName: 'test_mottai_flutter_app',
//           packageName: 'packageName',
//           version: '0.0.1',
//           buildNumber: 'buildNumber',
//           buildSignature: 'buildSignature',
//         );
//         final container = ProviderContainer(
//           overrides: [
//             packageInfoProvider
//                 .overrideWithValue(await PackageInfo.fromPlatform()),
//             forceUpdateConfigRepositoryProvider
//                 .overrideWithValue(mockForceUpdateConfigRepository),
//           ],
//         );
//         // モックリポジトリにより取得するデータを変更する
//         when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
//             .thenAnswer((_) async* {
//           yield const ReadForceUpdateConfig(
//             androidForceUpdate: false,
//             androidLatestVersion: '0.0.2',
//             androidMinRequiredVersion: '0.0.1',
//             forceUpdateConfigId: 'forceUpdateConfig',
//             iOSForceUpdate: false,
//             iOSLatestVersion: '0.0.2',
//             iOSMinRequiredVersion: '0.0.1',
//             path: 'configurations',
//           );
//         });
//         // リクエストの結果が戻るのを待つ
//         await container.read(forceUpdateStreamProvider.future);
//         expect(
//           container.read(isForceUpdateRequiredProvider),
//           false,
//         );
//       });
//       test('現在バージョン>最低限バージョンはfalseを返す', () async {
//         final mockForceUpdateConfigRepository =
//             MockForceUpdateConfigRepository();
//         PackageInfo.setMockInitialValues(
//           appName: 'test_mottai_flutter_app',
//           packageName: 'packageName',
//           version: '0.0.2',
//           buildNumber: 'buildNumber',
//           buildSignature: 'buildSignature',
//         );
//         final container = ProviderContainer(
//           overrides: [
//             packageInfoProvider
//                 .overrideWithValue(await PackageInfo.fromPlatform()),
//             forceUpdateConfigRepositoryProvider
//                 .overrideWithValue(mockForceUpdateConfigRepository),
//           ],
//         );
//         // モックリポジトリにより取得するデータを変更する
//         when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
//             .thenAnswer((_) async* {
//           yield const ReadForceUpdateConfig(
//             androidForceUpdate: false,
//             androidLatestVersion: '0.0.2',
//             androidMinRequiredVersion: '0.0.1',
//             forceUpdateConfigId: 'forceUpdateConfig',
//             iOSForceUpdate: false,
//             iOSLatestVersion: '0.0.2',
//             iOSMinRequiredVersion: '0.0.1',
//             path: 'configurations',
//           );
//         });
//         // リクエストの結果が戻るのを待つ
//         await container.read(forceUpdateStreamProvider.future);
//         expect(
//           container.read(isForceUpdateRequiredProvider),
//           false,
//         );
//       });
//     });
//     group('強制アップデートtrue(forceUpdate=true)', () {
//       test('現在バージョン<最低限バージョンはtrueを返す', () async {
//         final mockForceUpdateConfigRepository =
//             MockForceUpdateConfigRepository();
//         PackageInfo.setMockInitialValues(
//           appName: 'test_mottai_flutter_app',
//           packageName: 'packageName',
//           version: '0.0.1',
//           buildNumber: 'buildNumber',
//           buildSignature: 'buildSignature',
//         );
//         final container = ProviderContainer(
//           overrides: [
//             packageInfoProvider
//                 .overrideWithValue(await PackageInfo.fromPlatform()),
//             forceUpdateConfigRepositoryProvider
//                 .overrideWithValue(mockForceUpdateConfigRepository),
//           ],
//         );
//         // モックリポジトリにより取得するデータを変更する
//         when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
//             .thenAnswer((_) async* {
//           yield const ReadForceUpdateConfig(
//             androidForceUpdate: true,
//             androidLatestVersion: '0.0.2',
//             androidMinRequiredVersion: '0.0.2',
//             forceUpdateConfigId: 'forceUpdateConfig',
//             iOSForceUpdate: true,
//             iOSLatestVersion: '0.0.2',
//             iOSMinRequiredVersion: '0.0.1',
//             path: 'configurations',
//           );
//         });
//         // リクエストの結果が戻るのを待つ
//         await container.read(forceUpdateStreamProvider.future);
//         expect(
//           container.read(isForceUpdateRequiredProvider),
//           true,
//         );
//       });
//       test('現在バージョン<=最低限バージョンはfalseを返す', () async {
//         final mockForceUpdateConfigRepository =
//             MockForceUpdateConfigRepository();
//         PackageInfo.setMockInitialValues(
//           appName: 'test_mottai_flutter_app',
//           packageName: 'packageName',
//           version: '0.0.1',
//           buildNumber: 'buildNumber',
//           buildSignature: 'buildSignature',
//         );
//         final container = ProviderContainer(
//           overrides: [
//             packageInfoProvider
//                 .overrideWithValue(await PackageInfo.fromPlatform()),
//             forceUpdateConfigRepositoryProvider
//                 .overrideWithValue(mockForceUpdateConfigRepository),
//           ],
//         );
//         // モックリポジトリにより取得するデータを変更する
//         when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
//             .thenAnswer((_) async* {
//           yield const ReadForceUpdateConfig(
//             androidForceUpdate: true,
//             androidLatestVersion: '0.0.2',
//             androidMinRequiredVersion: '0.0.1',
//             forceUpdateConfigId: 'forceUpdateConfig',
//             iOSForceUpdate: true,
//             iOSLatestVersion: '0.0.2',
//             iOSMinRequiredVersion: '0.0.1',
//             path: 'configurations',
//           );
//         });
//         // リクエストの結果が戻るのを待つ
//         await container.read(forceUpdateStreamProvider.future);
//         expect(
//           container.read(isForceUpdateRequiredProvider),
//           false,
//         );
//       });
//       test('現在バージョン>最低限バージョンはfalseを返す', () async {
//         final mockForceUpdateConfigRepository =
//             MockForceUpdateConfigRepository();
//         PackageInfo.setMockInitialValues(
//           appName: 'test_mottai_flutter_app',
//           packageName: 'packageName',
//           version: '0.0.2',
//           buildNumber: 'buildNumber',
//           buildSignature: 'buildSignature',
//         );
//         final container = ProviderContainer(
//           overrides: [
//             packageInfoProvider
//                 .overrideWithValue(await PackageInfo.fromPlatform()),
//             forceUpdateConfigRepositoryProvider
//                 .overrideWithValue(mockForceUpdateConfigRepository),
//           ],
//         );
//         // モックリポジトリにより取得するデータを変更する
//         when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
//             .thenAnswer((_) async* {
//           yield const ReadForceUpdateConfig(
//             androidForceUpdate: true,
//             androidLatestVersion: '0.0.2',
//             androidMinRequiredVersion: '0.0.1',
//             forceUpdateConfigId: 'forceUpdateConfig',
//             iOSForceUpdate: true,
//             iOSLatestVersion: '0.0.2',
//             iOSMinRequiredVersion: '0.0.1',
//             path: 'configurations',
//           );
//         });
//         // リクエストの結果が戻るのを待つ
//         await container.read(forceUpdateStreamProvider.future);
//         expect(
//           container.read(isForceUpdateRequiredProvider),
//           false,
//         );
//       });
//     });
//   });
//   group('おかしな値を取得した場合', () {
//     test('fireStoreから取得した数値がおかしな場合はfalseを返す', () async {
//       final mockForceUpdateConfigRepository = MockForceUpdateConfigRepository
// ();
//       PackageInfo.setMockInitialValues(
//         appName: 'test_mottai_flutter_app',
//         packageName: 'packageName',
//         version: '0.0.1',
//         buildNumber: 'buildNumber',
//         buildSignature: 'buildSignature',
//       );
//       final container = ProviderContainer(
//         overrides: [
//           packageInfoProvider
//               .overrideWithValue(await PackageInfo.fromPlatform()),
//           forceUpdateConfigRepositoryProvider
//               .overrideWithValue(mockForceUpdateConfigRepository),
//         ],
//       );
//       // モックリポジトリにより取得するデータを変更する
//       when(mockForceUpdateConfigRepository.subscribeForceUpdateConfig())
//           .thenAnswer((_) async* {
//         yield const ReadForceUpdateConfig(
//           androidForceUpdate: true,
//           androidLatestVersion: 'おかしな値1',
//           androidMinRequiredVersion: 'おかしな値2',
//           forceUpdateConfigId: 'forceUpdateConfig',
//           iOSForceUpdate: true,
//           iOSLatestVersion: 'おかしな値3',
//           iOSMinRequiredVersion: 'おかしな値4',
//           path: 'configurations',
//         );
//       });
//       // リクエストの結果が戻るのを待つ
//       await container.read(forceUpdateStreamProvider.future);
//       expect(
//         container.read(isForceUpdateRequiredProvider),
//         false,
//       );
//     });
//   });
// }
