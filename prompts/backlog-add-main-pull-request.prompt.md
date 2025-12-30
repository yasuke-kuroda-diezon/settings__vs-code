---
agent: agent
description: 本番リリース用のプルリクエストを Backlog に作成する。
tools: ['execute', 'read', 'search', 'backlog/*']
model: GPT-4o (copilot)
---
手順はチャット欄に出力しない。手順に従い順に実行する。

# 本番ブランチ{productionBranch}を取得する。
- {productionBranch}: `git ls-remote --heads origin master main`の結果から"main"or"master"を判定。

# リリース課題のissueKeyをユーザー入力より決定する。
1. 確認:「⚠️本番環境(${productionBranch})向けにPRを作成します⚠️\n\nリリース課題の課題キーを入力してください(例：XXX_SHARED-123)。?\n nでキャンセル」
   - {issueKey}: ユーザー入力値。
   - {sharedProjectKey}: {issueKey}の`/[A-Z_]+/`にマッチする部分。
   - n → プロセスを中止する。
{issueKey}を決定したらチャット欄に出力して次へ。

# リリースブランチ{releaseBranch}を決定する。
1. デフォルト値: `git branch | grep -oE 'release/.*' | head -n 1`の結果。
2. ユーザー入力があれば上書きする。
3. 確認:「推測したリリースブランチは${releaseBranch}です。yで確定、変更する場合はブランチ名を入力」
   - y → {releaseBranch}を確定して次へ。
   - その他 → 入力値で{releaseBranch}を上書きして次へ。

# バージョンを特定する。
- {version}: `echo "${releaseBranch}" | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+'` の結果。

# リリースブランチをチェックアウト、プッシュする。
```bash
git checkout -b {releaseBranch} origin/{releaseBranch}
git pull --prune
git push -u origin {releaseBranch}
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
  "fields": "{\n  id as issueId\n projectId\n milestone }"
}
```
- {milestoneId}: get_issueの結果の、milestone配列の最初の要素のid。

# backlogにプルリクエストを作成する。
- {systemCode}: `git remote get-url origin | grep -oE 'DEV_[A-Z]+' | grep -oE '[A-Z]+$'` の結果。
- {projectKey}: `git remote get-url origin | grep -oE '[A-Z_]+'` の結果。
- {repoName}: `git remote get-url origin | grep -oE '[^/]+\.git$' | sed 's/\.git$//'` の結果。
- {summary}: `【本番PR】{systemCode}：release {version}`。
- {issueListUrl}: `https://diezon.backlog.com/find/{sharedProjectKey}?fixedVersionId={milestoneId}&limit=20&offset=0&projectId={projectId}&simpleSearch=true&sort=UPDATED`形式。
- {description}: ```markdown
## 手順
- dep deploy production -p -vvv

## 対象課題
{issueListUrl}
```
```mcp:backlog:add_pull_request
{
  "projectKey",
  "repoName",
  "issueId",
  "summary",
  "base": "${productionBranch}",
  "branch": "${releaseBranch}",
  "description",
  "assigneeId",
  "fields": "{\n  number\n}"
}
```
add_pull_requestツールを実行する。

# プルリクエストのURLを表示する。
- {pullRequestUrl}: `https://diezon.backlog.com/git/${projectKey}/${repoName}/pullRequests/${number}`形式。
{pullRequestUrl}をユーザーに通知する。