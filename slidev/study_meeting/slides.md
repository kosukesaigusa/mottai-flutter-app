---
theme: default
background: https://source.unsplash.com/collection/94734566/1920x1080
class: 'text-center'
highlighter: shiki
info: |
  ## Slidev Starter Template
  Presentation slides for developers.

  Learn more at [Sli.dev](https://sli.dev)
fonts:
  sans: 'Roboto'
  serif: 'Roboto'
  mono: 'Fira Code'
---

# Firebase Functions 入門

2022-06-20 (水) Kosuke Saigusa （Flutter 大学 #共同勉強会）

<div class="abs-br m-6 flex gap-2">
  <a href="https://github.com/KosukeSaigusa/mottai-flutter-app" target="_blank" alt="GitHub"
    class="text-xl icon-btn opacity-50 !border-none !hover:text-white">
    <carbon-logo-github />
  </a>
</div>

---

## 概要

Flutter/Dart と比べると習熟度が低く恐縮ですが、Cloud (Firebase) Functions に関する話をしてみます。

下記のような話題に触れて今までよりも少しでも Cloud (Firebase) Functions を楽しく快適に書く方が増えたら良いなと思っています。

- Cloud (Firebase) Functions って何？いつ使う？なぜ必要？
- tsconfig.json について
- eslint, editorconfig について
- package.json, package-lock.json について
- types ディレクトリについて
- Firebase Functions の概要
- withConverter について
- Firebase Functions の実装例、リポジトリ構成
- Callable Functions について（概要）
- Callable Functions について（実装例）
- Firebase Local Emulator によるデバッグについて

---

## その前に

- [私の GitHub](https://github.com/KosukeSaigusa) のフォロー
- [今回使用するリポジトリへのスター](https://github.com/KosukeSaigusa/mottai-flutter-app)

をお願いしたいです！🙌

---

## Cloud (Firebase) Functions って何？

<https://cloud.google.com/functions/docs/concepts/overview>

> Google Cloud Functions は、クラウド サービスの構築と接続に使用するサーバーレスのランタイム環境です。Cloud Functions を使用すると、クラウドのインフラストラクチャやサービスで生じたイベントに関連する、シンプルで一義的な関数を作成できます。対象のイベントが発生すると、Cloud Functions がトリガーされ、コードがフルマネージドの環境で実行されます。インフラストラクチャをプロビジョニングする必要はなく、サーバーの管理に悩まされることもありません。

要は「サーバレスな関数単位のサーバサイドアプリケーションの実行環境」くらいに捉えると良いと思います。

Firebase との連携も容易で、たとえば Firestore のドキュメントの作成・変更・削除などをトリガーにした関数などは実装が容易で強力です。

---

## Cloud (Firebase) Functions いつ使う？なぜ必要？

バックエンドを Firebase で代替するサービスのサーバサイドアプリケートションとして使用します（Firebase を多様せずとも「サーバレスな関数単位のサーバサイドアプリケーションの実行環境」として使用を検討するケースも多くあります）。

たとえば Firestore を主な DB として使用するアプリケーションでは Cloud (Firebase) Functions は必須です。

- Firestore はクエリが貧弱で Write-heavy な設計になるので、クライアントが単純な読み込みで済むような実装をするために必須なイベントトリガー関数
- Security Rules で制限されたクライアント SDK とは異なる Admin SDK を用いた処理の実行
- プッシュ通知や決済プロバイダ、認証プロバイダなどの外部 API との連携に必要なサーバサイドアプリケーションや HTTP 関数 (Callable Functions) の実装
- Cloud Pub/Sub, Cloud Scheduler を用いた Schedule Functions による定期実行タスクのスケジューリング・実行

その他にも、Firebase Auth や Firebase Storage のイベントなどをトリガーにした関数も簡単に定義することができます。

---

## Cloud (Firebase) Functions の始め方

```sh
# Firebase CLI（firebase コマンド）の導入
npm install -g firebase-tools

# firebase プロジェクトのイニシャライズ
firebase init
```

ちなみに個人的には npm や node の環境構築には最近は [VOLTA](https://volta.sh/) をおすすめしています。

また Dart を普段から取り扱うであろう皆さんには、JavaScript ではなく TypeScript での開発を推奨し、その前提で話を進めます。

詳細は ... を参考にしてください。

---

## tsconfig.json について

`tsconfig.json` とは、すべての TypeScript プロジェクトのルートに必ず設置され、

- どのファイルをコンパイル（トランスパイル）対象とすべきか
- コンパイル（トランスパイル）結果をどのディレクトリに格納すべきか
- どのバージョンの JavaScript を出力するか
- ...

などを TypeScript プロジェクトが定義するためのファイル。

---

## tsconfig.json の例

```json
{
  "compilerOptions": {
    "module": "commonjs",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "noImplicitReturns": true,
    "noUnusedLocals": true,
    "outDir": "lib",
    "sourceMap": true,
    "strict": true,
    "target": "es2020",
    "baseUrl": "./",
    "paths": {
      "~/*": ["./*"],
      "@/*": ["./*"]
    },
    "types": ["@types/node"]
  },
  "compileOnSave": true,
  "exclude": ["node_modules", "lib"]
}
```

---

## eslint について

ESLint とは JavaScript (EcmaScript) のための静的解析ツール。

<https://eslint.org/>

...

---

## editorconfig について

EditorConfig とは、同一プロジェクトを異なるエディタや IDE の複数の開発者で開発する再にコードのスタイルの一貫性を維持するための設定を行うファイルです。

<https://editorconfig.org/>

<https://stackoverflow.com/questions/48363647/editorconfig-vs-eslint-vs-prettier-is-it-worthwhile-to-use-them-all>

---

## package.json, package-lock.json について

`package.json` とは JavaScript や Node.js プロジェクト（パッケージ）のルートに設置し、プロジェクトに関する様々なメタデータや設定を記述するファイルです。

たとえば、プロジェクトが依存する外部パッケージを記述したり、`npm run something` で実行したいスクリプトを定義したりすることができます。

`package-lock.json` とは、`package.json` を元に解決したすべての依存性が記述され、固定化して使用するためのファイルです。

Dart のプロジェクトにとっての `pubspec.yaml`, `pubspec-lock.yaml` と同じものだと捉えて問題ありません。

---

## types ディレクトリについて

...

---

## Firebase Functions の概要 1

Firebase Functions (Cloud Functions for Firebase) で最もよく使うもののひとつは、Firestore のイベントの作成・更新・削除などをトリガーにした関数 (Cloud Firestore triggers) です。

`firebase-functions` パッケージは `as functions` としてインポートするのが通例で、下記のような記述を行うことで `accounts` コレクションの任意のドキュメント (`accountId`) が作成されたときに発火する関数を定義することができます。

```ts
import * as functions from 'firebase-functions'

export const onCreateAccount = functions
    .region(`asia-northeast1`)
    .firestore.document(`/accounts/{accountId}`)
    .onCreate(async (snapshot) => {
      // ...
    })
```

---

## Firebase Functions の概要 2

下記の `onCreate` は第 1 引数に `QueryDocumentSnapshot (snapshot)` を、第 2 引数に `EventContext (context)` をとることができます。

```ts
export const onCreateAccount = functions
    .region(`asia-northeast1`)
    .firestore.document(`/accounts/{accountId}`)
    .onCreate(async (snapshot, context) => {
      // ...
    })
```

`snapshot` には、この関数の onCreate の引き金となったドキュメントの `QueryDocumentSnapshot` が入っています。`snapshot.data()` とすることでドキュメントのデータにアクセスすることができます。

`context` には、このトリガーされたイベントに関する認証情報やその他のメタデータのようなものが入っています。たとえば `context.params.accountId` とすると、onCreate の引き金となったドキュメントのドキュメント ID を得ることができます。

---

## withConverter について 1

FlutterFire でもお馴染みですが `withConverter` を用いると、Firestore の `CollectionReference<T>`, `DocumentReference<T>`, `DocumentSnapshot<T>` `DocumentData<T>` に型をつけることができます。

JS (TS) の Firestore でも同様です。

まず、型定義ファイルにドキュメントの内容に合う型を定義してください。TypeScript の（いわゆる）型定義（みたいなもの）には複数の方法がありますが、ここでは `interface` を用いることにします。

```ts
/** Firestore の account コレクションのドキュメントデータの型。 */
interface AppAccount {
  accountId: string
  createdAt?: FirebaseFirestore.Timestamp | null
  updatedAt?: FirebaseFirestore.Timestamp | null
  displayName: string
  imageURL: string
  providers: string[]
  fcmTokens: string[]
}
```

---

## withConverter について 2

`withConverter` の引数にわたす `FirestoreDataConverter<T>` を定義します。

```ts
import { FieldValue, FirestoreDataConverter } from "@google-cloud/firestore"

export const accountConverter: FirestoreDataConverter<AppAccount> = {
    fromFirestore(qds: FirebaseFirestore.QueryDocumentSnapshot): AppAccount {
        const data = qds.data()
        return {
            accountId: qds.id,
            createdAt: data.createdAt ?? null,
            updatedAt: data.updatedAt ?? null,
            displayName: data.displayName ?? ``,
            imageURL: data.imageURL ?? ``,
            providers: data.providers ?? [],
            fcmTokens: data.fcmTokens ?? []
        }
    },
    // ... toFirestore 省略
}
```

---

## withConverter について 3

`withConverter` の引数にわたす `FirestoreDataConverter<T>` を定義します。

```ts
import { FieldValue, FirestoreDataConverter } from "@google-cloud/firestore"

export const accountConverter: FirestoreDataConverter<AppAccount> = {
    // ... fromFirestore 省略
    toFirestore(account: AppAccount): FirebaseFirestore.DocumentData {
        return {
            accountId: account.accountId,
            createdAt: FieldValue.serverTimestamp(),
            updatedAt: FieldValue.serverTimestamp(),
            displayName: account.displayName ?? ``,
            imageURL: account.imageURL ?? ``,
            providers: account.providers ?? [],
            fcmTokens: account.fcmTokens ?? []
        }
    }
}
```

---

## withConverter について 4

たとえば `withConverter` を用いて account コレクションの型付き `CollectionReference<AppAccount>` を返す変数や、account ドキュメントの ID を渡すと型付き `DocumentReference<AppAccount>` を返すメソッドを作っておいたりすると便利です。

```ts
import * as admin from 'firebase-admin'
import { CollectionReference, DocumentReference, Query } from '@google-cloud/firestore'
import { accountConverter } from '../converters/accountConverter'

/** accounts コレクションの参照 */
const accountsRef: CollectionReference<AppAccount> = admin.firestore()
    .collection(`accounts`)
    .withConverter<AppAccount>(accountConverter)

/** 指定した account ドキュメントの参照 */
const accountRef = (
    { accountId }: { accountId: string }
): DocumentReference<AppAccount> => {
    return accountsRef.doc(accountId).withConverter<AppAccount>(accountConverter)
}
```

---

## withConverter について 5

あとは `onCreate` の第 1 引数から得られる `DocumentSnapshot (snapshot)` を `accountConverter.fromFirestore` に渡すとそれだけで変数 `account` には `AppAccount` の型が付いています。

```ts {5}
export const onCreateAccount = functions
    .region(`asia-northeast1`)
    .firestore.document(`/accounts/{accountId}`)
    .onCreate(async (snapshot) => {
        const account = accountConverter.fromFirestore(snapshot)
    })
```

---

## Firebase Functions の実装例

`accounts` コレクションの任意のドキュメントが新規作成されたときに、`publicUsers` コレクションに対応するドキュメントを作成する関数。

```ts
export const onCreateAccount = functions
    .region(`asia-northeast1`)
    .firestore.document(`/accounts/{accountId}`)
    .onCreate(async (snapshot) => {
        const account = accountConverter.fromFirestore(snapshot)
        const publicUser: PublicUser = {
            userId: account.accountId,
            displayName: account.displayName,
            imageURL: account.imageURL
        }
        try {
            await publicUserRef({ publicUserId: account.accountId }).set(publicUser)
        } catch (e) {
            functions.logger.error(`onCreateAccount に失敗しました: ${e}`)
        }
    })
```

また、`accounts` ドキュメントから Firebase Functions 経由で `publicUsers` ドキュメントを作る理由に思いを馳せると、Firestore のデータモデリング、Security Rules や読み書きの分離について考えるきっかけになります。

---

## Firebase Functions のリポジトリ構成の例

プロダクションレベルで運用・開発したことはない前提ですが、...

```plain

```

---

## 参考

- [OREILLY プログラミング TypeScript]()
