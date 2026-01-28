---
agent: agent
description: 変更をステージングしてコミットしてプッシュします。
tools: ['execute', 'read', 'search']
model: GPT-4o (copilot)
---
手順はチャット欄に出力しない。手順に従い順に実行する。

# 変更をステージング, コミット、プッシュ
```bash
git add .
```
- {issueKey}: `git branch --show-current | grep -oE '[A-Z_]+-[0-9]+'`の結果。
- {commitMessage}: `git diff --cached`の結果から生成。簡潔な1行の英文。
- {currentBranch}: `git branch --show-current`の結果。
```bash
git commit -m "{issueKey}: {commitMessage}" && \
git push -u origin {currentBranch}
```

取得した変更内容から主要な修正点を1ファイル1行で箇条書き形式でまとめて出力する。
```
- ファイル名1
  - 修正内容の概要1
- ファイル名2
  - 修正内容の概要2
- ファイル名3
  - 修正内容の概要3
```