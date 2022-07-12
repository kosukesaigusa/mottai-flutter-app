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
- eslint.js, editorconfig について
- package.json, package-lock.json について
- types ディレクトリについて
- Firebase Functions について（概要）
- withConverter について
- Firebase Functions を見てみる（リポジトリ構成、実装例）
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

たとえばバックエンドを Firebase で代替する場合のサーバサイドアプリとして使用します。

Firestore を主な DB として使用するアプリケーションでは Cloud (Firebase) Functions は必須です。

-
