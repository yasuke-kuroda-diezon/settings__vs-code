## クイックスタート

```sh
// ユーザー設定ディレクトリをVisual Studio Codeで開く.
code ~/Library/Application\ Support/Code/User
```

## プロファイル一覧
### docker
- Docker作業用
- 拡張機能: Docker関連
- ディレクトリ例: `hazaiya-docker/`, `olta-docker/`

### eccube(PHP)
- Symfony(PHP)開発用
- 拡張機能: Symfony / PHP / Twig / YAML
- 設定: `$`を単語認識
- ディレクトリ例: `hazaiya-docker/eccube_web/eccube/`, `ceralabo-docker/eccube_web/eccube/`

### backend(TypeScript)
- NestJS(TypeScript)開発用
- 拡張機能: NestJS / TypeScript / Prisma / GraphQL
- 設定: `@`を単語認識
- ディレクトリ例: `regolith-docker/regolith-api-ctr/regolith-api/`, `olta-docker/regolith-api-ctr/regolith-api/`

### frontend(TypeScript)
- Next.js/React.js(TypeScript)開発用
- 拡張機能: Next.js / React / TypeScript / GraphQL
- ディレクトリ例: `regolith-docker/regolith-admin-ctr/regolith-admin`, `olta-docker/regolith-front-ctr/regolith-front`

### スクリプト(Bash ShellScript)
- bashスクリプト用
- 拡張機能: bash関連

### playground
- 設定や拡張機能の試用
- 気に入れば他プロファイルへ反映

## 参考リンク

- [試行錯誤の末たどりついた設定管理術](https://zenn.dev/hacobell_dev/articles/52b383c05ab408)

## [背景]プロファイル導入前に生じる問題
**①ワークスペース設定はいじれない**

```
// Visual Studio Code設定の読み込み優先度.
Visual Studio Codeデフォルト設定 < ユーザー設定 < ワークスペース設定(⚠️チームGit管理の対象⚠️)
```

ワークスペース設定は、プロジェクトルートディレクトリに配置します。DiezonではチームでVisual Studio Codeの設定を共通化しているので、気軽にワークスペース設定を変更することができません。
- 例
  - [regolith-headless > olta](https://diezon.backlog.com/git/DEV_OLTA/regolith-admin/blob/main/.vscode/settings.json)
  - [regolith > susplus](https://diezon.backlog.com/git/DEV_SUSP/ec-cube/blob/main/.vscode/settings.json)

**②ユーザー設定が増えすぎると、Visual Studio Codeが重たくなる**

例えば、ユーザー設定としてPHPとTypeScriptの拡張機能を50個ずつインストールして有効化していると、PHP実装時に余分なTypeScript拡張機能50個がアクティブなせいでVisual Studio Codeは重たくなります。

**③ワークスペース単位で都度設定するのが面倒**

前述した②の問題は、拡張機能をワークスペース単位で有効/無効と切り替えることで対応できますが、手間です。
- 案件毎に手動で設定する必要があり、面倒.
- 拡張機能が有効か無効か、気にするのも面倒.

## [解決]プロファイル導入により解決できること

[Profiles in Visual Studio Code](https://code.visualstudio.com/docs/configure/profiles)

プロファイルとは、**ユーザー設定に名前をつけて保存できる機能**です。
プロファイルを切り替えることで、特定の設定群をまとめてユーザー設定として適用できます。

```
// Visual Studio Code設定の読み込み優先度.
Visual Studio Codeデフォルト設定 < ⭐️プロファイルA(≠PHP用)⭐️        < ワークスペース設定(⚠️チームGit管理の対象⚠️)
                                   ↕︎アタッチ/デタッチ で切り替え
Visual Studio Codeデフォルト設定 < ⭐️プロファイルB(≠TypeScript用)⭐️ < ワークスペース設定(⚠️チームGit管理の対象⚠️)
```

Visual Studio Code上でプロファイルをアタッチメントしたり、デタッチメントすることで、ユーザー設定を切り替えることができるイメージです。[動作イメージ(Gyazo)](https://diezon.gyazo.com/de4a2404dbec1e1551504718871abf62)。

これにより、 <span style="color: #f09199;">ワークスペース設定を汚さず、Visual Studio Codeを軽快に保ちながら、案件毎に最適なユーザー設定を適用</span>できます。
