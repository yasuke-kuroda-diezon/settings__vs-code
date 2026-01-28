---
agent: agent
description: package-lock.json にローカルとコンテナ内のnpm installにて差分が発生する - sharp
tools: ["vscode", "execute", "read", "edit", "search", "web", "agent", "todo"]
model: Claude Opus 4.5 (copilot)
---

# 内容

以下、regolith-frontのみ生じる事象（regolith-adminでは生じない）。

```
▼regolith-front
$ cd regolith-docker/regolith-front-ctr/regolith-front
$ npm install
```

を実行すると、package-lock.json に差分が生じる。
package-lock.jsonはGit管理しており、これまで`npm install`実行時にpackage-lock.json にGit差分は生じないはずだったが、ある時から差分が生じるようになったと思われる。

差分の原因を把握して、差分が起きないよう調整する。

## 発生経緯

おそらくnpm packageのsharpをインストールしてから発生。
通常の`npm install sharp`コマンドにてインストールした。

sharpは、Next.js の Standalone ModeでNext Imageを使用するにあたり
必要となりインストールした経緯がある。

## 参考

Next.js Sharp Missing In Production：https://nextjs.org/docs/messages/sharp-missing-in-production
Next.jsで本番環境で画像が表示されない場合の対処法：https://zenn.dev/trape_inc/articles/efc5f74b370b58

# release/v2.0.0だと再現する

git switch release/v2.0.0
Switched to branch 'release/v2.0.0'

git status
On branch release/v2.0.0
Your branch is up to date with 'origin/release/v2.0.0'.

nothing to commit, working tree clean

npm install
removed 4 packages, and audited 1715 packages in 2s

307 packages are looking for funding
run `npm fund` for details

40 vulnerabilities (9 low, 18 moderate, 10 high, 3 critical)

To address issues that do not require attention, run:
npm audit fix

To address all issues (including breaking changes), run:
npm audit fix --force

Run `npm audit` for details.

git status
On branch release/v2.0.0
Your branch is up to date with 'origin/release/v2.0.0'.

Changes not staged for commit:
(use "git add <file>..." to update what will be committed)
(use "git restore <file>..." to discard changes in working directory)
modified: package-lock.json

git diff
diff --git a/package-lock.json b/package-lock.json
index ac897745..2eeffa4f 100644
--- a/package-lock.json
+++ b/package-lock.json
@@ -60,6 +60,9 @@
},
"engines": {
"node": "20.x"

-      },
-      "optionalDependencies": {
-        "@rollup/rollup-linux-x64-gnu": "4.6.1"
         }
       },
       "node_modules/@alloc/quick-lru": {
  @@ -6689,9 +6692,9 @@
  ]
  },
  "node_modules/@rollup/rollup-linux-x64-gnu": {

*      "version": "4.35.0",
*      "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-x64-gnu/-/rollup-linux-x64-gnu-4.35.0.tgz",
*      "integrity": "sha512-Pim1T8rXOri+0HmV4CdKSGrqcBWX0d1HoPnQ0uw0bdp1aP5SdQVNBy8LjYncvnLgu3fnnCt17xjWGd4cqh8/hA==",

-      "version": "4.6.1",
-      "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-x64-gnu/-/rollup-linux-x64-gnu-4.6.1.tgz",
-      "integrity": "sha512-DNGZvZDO5YF7jN5fX8ZqmGLjZEXIJRdJEdTFMhiyXqyXubBa0WVLDWSNlQ5JR2PNgDbEV1VQowhVRUh+74D+RA==",
         "cpu": [
           "x64"
         ],
  @@ -20478,6 +20481,18 @@
  "fsevents": "~2.3.2"
  }
  },
- "node_modules/rollup/node_modules/@rollup/rollup-linux-x64-gnu": {
-      "version": "4.35.0",
-      "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-x64-gnu/-/rollup-linux-x64-gnu-4.35.0.tgz",
-      "integrity": "sha512-Pim1T8rXOri+0HmV4CdKSGrqcBWX0d1HoPnQ0uw0bdp1aP5SdQVNBy8LjYncvnLgu3fnnCt17xjWGd4cqh8/hA==",
-      "cpu": [
-        "x64"
-      ],
-      "optional": true,
-      "os": [
-        "linux"
-      ]
- },
  "node_modules/rollup/node_modules/@types/estree": {
  "version": "1.0.6",
  "resolved": "https://registry.npmjs.org/@types/estree/-/estree-1.0.6.tgz",

# release/v3.2.0ブランチでは発生しない

git switch release/v3.2.0
Switched to branch 'release/v3.2.0'
Your branch is up to date with 'origin/release/v3.2.0'.

npm install

added 4 packages, and audited 1719 packages in 3s

309 packages are looking for funding
run `npm fund` for details

40 vulnerabilities (9 low, 18 moderate, 10 high, 3 critical)

To address issues that do not require attention, run:
npm audit fix

To address all issues (including breaking changes), run:
npm audit fix --force

Run `npm audit` for details.

git status
On branch release/v3.2.0
Your branch is up to date with 'origin/release/v3.2.0'.

nothing to commit, working tree clean

# タスク

・原因調査
・解決方法の提案
・（提案内容に対して実施の許可が出たら、解決方法の実施）
