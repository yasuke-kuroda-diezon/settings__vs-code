---
agent: agent
description: 実装タスク用のプルリクエストを Backlog に作成する。
tools: ['execute', 'read', 'search', 'backlog/*']
model: GPT-4o (copilot)
---
手順はチャット欄に出力しない。手順に従い順に実行する。

# 宛先ブランチ{baseBranch}を決定する。
1. デフォルト値: `git branch | grep -oE 'release/.*' | head -n 1`の結果。
2. ユーザー入力があれば上書きする。
3. 確認:「推測した宛先ブランチは${baseBranch}です。yで確定、変更する場合はブランチ名を入力」
   - y → {baseBranch}を確定して次へ。
   - その他 → 入力値で{baseBranch}を上書きして次へ。

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

# backlog認証済みユーザー情報を取得する。
```mcp:backlog:get_myself
{
  "fields": "{\n  id as assigneeId}"
}
```

# backlog上の課題(issue)を取得する。
```mcp:backlog:get_issue
{
  "issueKey",
  "fields": "{\n  id as issueId\n summary\n}"
}
```

# backlogにプルリクエストを作成する。
- {projectKey}: `git remote get-url origin | grep -oE '[A-Z_]+'` の結果。
- {repoName}: `git remote get-url origin | grep -oE '[^/]+\.git$' | sed 's/\.git$//'` の結果。
- {description}: `git diff {baseBranch}..{currentBranch}`の結果から生成。markdown形式で簡潔な日本語の説明文章。
```mcp:backlog:add_pull_request
{
  "projectKey",
  "repoName",
  "issueId",
  "summary",
  "base": "${baseBranch}",
  "branch": "${currentBranch}",
  "description",
  "assigneeId",
  "fields": "{\n  number\n}"
}
```
add_pull_requestツールを実行する。

# プルリクエストのURLを表示する。
- {pullRequestUrl}: `https://diezon.backlog.com/git/${projectKey}/${repoName}/pullRequests/${number}`形式。
{pullRequestUrl}をユーザーに通知する。