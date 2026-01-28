---
agent: agent
description: 本番リリース用のIssue(課題)を Backlog に作成する。
tools: ['execute', 'read', 'search', 'backlog/*']
model: GPT-4o (copilot)
---
手順はチャット欄に出力しない。手順に従い順に実行する。

# リリースブランチ{releaseBranch}を決定する。
1. デフォルト値: `git branch | grep -oE 'release/.*' | head -n 1`の結果。
2. ユーザー入力があれば上書きする。
3. 確認:「⚠️SHAREDにリリース課題を作成します。⚠️\n\n推測したリリースブブランチは${releaseBranch}です。yで確定、変更する場合はブランチ名を入力」
   - y → {releaseBranch}を確定して次へ。
   - その他 → 入力値で{releaseBranch}を上書きして次へ。

# バージョンを特定する。
- {version}: `echo "${releaseBranch}" | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+'` の結果。

# backlog認証済みユーザー情報を取得する。
```mcp:backlog:get_myself
{
  "fields": "{\n  id as assigneeId}"
}
```

# SHARED用のプロジェクトキーを取得： 例: DEV_CORES => CORES_SHARED
- {systemCode}: `git remote get-url origin | grep -oE 'DEV_[A-Z]+' | grep -oE '[A-Z]+$'` の結果。
- {projectKey}: 文字列`${systemCode}_SHARED`。

# backlog プロジェクトを取得する
```mcp:backlog:get_project
{
  "projectKey",
   "fields": "{\n  id as projectId\n}"
}
```

# backlog マイルストーンリストを取得し、マイルストーンID(milestoneId)を決定する。
```mcp:backlog:get_version_milestone_list
{
  "projectKey",
  "fields": "{\n  id as milestoneId\n  name as milestoneName\n}"
}
```
- {milestoneId}: `${version}`に最も近い`${milestoneName}`を持つマイルストーンのID。
  - 例：
    - {version}は`/v[0-9]+\.[0-9]+\.[0-9]+/`にマッチします。
    - {milestoneName}は半角スペースや全角スペース、メモや日付が付与されている場合があります。
      - `v1.0.0` や `v 1.0.0` や `v 1.0.0 実装` や `v 1.0.0（23/9/25）` など。
- {dueDate}: デフォルトNULL。{milestoneName}に日付が含まれている場合`yyyy-MM-dd`形式(例:2025-11-10)に変換した文字列とする。
{milestoneId}を決定したら、対応する{milestoneName}をチャット欄に出力して次へ。

# backlog 課題種別リストを取得し、課題種別ID(issueTypeId)を決定する。
```mcp:backlog:get_issue_types
{
  "projectKey",
  "fields": "{\n  id as issueTypeId\n  name as issueTypeName\n}"
}
```
- {issueTypeId}: `"リリース"`に最も近い`${issueTypeName}`を持つ課題種別のID。

# backlogにリリース用のissueを作成する。
- {MEDIUM_PRIORITY_STATUS_ID}: 3。優先度「中」のステータスID。
- {summary}: `${version} リリース`。
- {description}: ```markdown
## 概要
${version}をリリースする。

## 概要
- リリース時間
    - mm月yy日hh時～hh:mm目安
- ユーザー画面のサイト停止/メンテナンス
    - なし
- 管理画面のメンテナンス
    - なし
- 注文に関わる改修
    - なし

## 手順書
未作成

## 備考
- 大変お手数ですが、本番環境のテストに関しては、御社にてお願いいたします。
```

```mcp:backlog:add_issue
{
  "projectId",
  "summary",
  "issueTypeId",
  "priorityId": "${MEDIUM_PRIORITY_STATUS_ID}",
  "description",
  "dueDate",
  "milestoneId": [${milestoneId}],
  "assigneeId",
  "fields": "{\n  issueKey\n}"
}
```
backlog mcpのadd_issueツールを実行する。

# 課題URLを表示する。
- {issueUrl}: `https://diezon.backlog.com/view/${issueKey}`形式。
{issueUrl}をユーザーに通知する。