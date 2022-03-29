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

# 一次産業従事者と繋がる<br>マッチングアプリの開発

2022-03-29 (火) Kosuke Saigusa （Flutter 大学 #club_個人開発）

<div class="abs-br m-6 flex gap-2">
  <a href="https://github.com/KosukeSaigusa/mottai-flutter-app" target="_blank" alt="GitHub"
    class="text-xl icon-btn opacity-50 !border-none !hover:text-white">
    <carbon-logo-github />
  </a>
</div>

---

## 概要

- ３月からまとまった時間をとる個人開発を再開
- 一次産業従事者とつながるマッチングアプリをテーマに開発
- 高校時代のラグビー部同期の友人が理事をしている NPO 法人 MOTTAI で運営していきたいアプリ
- 現在は Notion を用いて beta 版でサービス提供中
- 不定期開催の鶏の解体ワークショップなどは「食の裏側」を学べる人気企画なので、興味がある方はフォローしてみてください
- 今日の話を面白いなと思って頂いた方は、ソースコードはすべて公開していて面白い箇所・参考になる箇所もあると思うので、 [**本プロジェクトの GitHub リポジトリ**](https://github.com/KosukeSaigusa/mottai-flutter-app) に ⭐️ をつけて頂けると嬉しいです🙌

NPO 法人 MOTTAI について

- [NPO 法人 MOTTAI HP](https://npo-mottai.org)
- [Notion 食べ物が報酬！！農家・漁師・猟師のお手伝いマッチングサービス](https://npo-mottai.notion.site/npo-mottai/1fc8beacc6e143bbb80f34f071d59013)

---

## モチベーション

- この9ヶ月間くらいは、月に80〜100時間程度を仕事としての開発に費やして来た
- 必要に迫られた技術には習熟するが、そうでないものには触れなくなる（求められる成果をアウトプットする周期が短くなりがち）
- Flutter 以外も含めて今回のサービス開発に必要な（≠ 必要最低限な）技術に、広く、ときどき深く触れていきたい
- リリースは α 版として年内の予定で、比較的猶予があるので、自身の技術的な興味の優先度を高めにしてゆっくり開発していく

---

## やったこと 1

3 月末までにやったことをアプリの画面共有・デモやソースコードをお見せしながら話します

- melos とサブモジュールの設定、アプリの骨格、ルーティング、Consistent な BottomNavigationBar 上での画面遷移などの実装
- Riverpod で状態管理をやってみる、途中から StateNotifierProvider 以外の Provider もユースケースに応じて積極的に使用していく
- Google/Apple でのサインイン
- Flutter LINE SDK を用いた LINE ログインの実装
- Callable Functions に LINE ログインを通じてクライアントで得られた `accessToken` と `idToken` を送って、その検証を行う API 通信を複数行った後に、Firebase Auth のカスタムトークン認証を行って Firebase Auth と LINE ログインを連携する、同一メールアドレスの場合は他のソーシャルログインとも連携する
- サウナライフや Always 次郎を参考に、`geoflutterfire`, `geolocator`, `google_maps_flutter` を用いて、現在地及び指定した場所を中心とした一定範囲内の情報を取得。カード式の UI のスライドと連動して動作

## やったこと 2

- Riverpod の複数の Provider を細かめに分けて組み合わせることで内部でリアルタイムなクライアントサイドジョイン的なことをして、ビューではひとつの Provider を watch すれば良い感じの実装
- プッシュ通知の Cloud Functions の実装
- プッシュ通知の Flutter クライアントの実装、通知を受けて任意の（or 現在の）BottomNavigationBar のアイテム上で通知の payload にもとづく画面へ遷移する実装
- Firebase Dynamic (Deep) Links の実装と、リンクを踏んだ後の指定された画面への遷移の実装
- チャット機能の基礎の実装
- 新規アカウント登録時に発火する Firebase Functions の実装
- 試行錯誤しながらデータモデリング
- ... など

## これからやってみたいこと

- チャット機能やその他の未着手の機能・画面を作成しながら Riverpod に習熟していく
- Flutter の Widget Test
- メッセージ機能の充実
- TypeSense を用いた全文検索
- Firebase Dynamic (Deep) Links の活用
- Firestore ではどうしようもないユースケースがあれば、何かしらの RDB（[PlanetScale](https://planetscale.com/) を触ってみたい）を使用して、自作のサーバサイドアプリケーション or API を実装する（まだ全然調べてないけど [NestJS](https://nestjs.com/), [Prisma](https://www.prisma.io/) あたりを使ってみたいかも）
- ... など

## さいごに

- 今後もコツコツ開発しつつ [#times_kosuke](https://flutteruniv.slack.com/archives/C01B82Y27U4) でも共有していこうと思いますのでよろしくお願いします！
- [GitHub リポジトリ](https://github.com/KosukeSaigusa/mottai-flutter-app)
