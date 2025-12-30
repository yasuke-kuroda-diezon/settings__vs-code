---
agent: agent
description: backlog上のプルリクエストの担当者を更新する。
tools: ['execute', 'read', 'search', 'backlog/*']
model: GPT-4o (copilot)
---
手順はチャット欄に出力しない。手順に従い順に実行する。

# 更新後の担当者を決定する。
```担当者一覧
[
  {"no": 1, "assigneeUserName": "Hiroki Sasabuchi", "assigneeId": 63869},
  {"no": 2, "assigneeUserName": "Koki Morii", "assigneeId": 31071},
  {"no": 3, "assigneeUserName": "Akari Imazumi", "assigneeId": 314786},
  {"no": 4, "assigneeUserName": "橋本慎也", "assigneeId": 372545},
  {"no": 5, "assigneeUserName": "鶴来朋也", "assigneeId": 372544},
  {"no": 6, "assigneeUserName": "yasuke kuroda", "assigneeId": 380374}
]
```
担当者一覧の"no"と"assigneeUserName"をユーザーに提示する。「以下の担当者から番号を選択してください。」と表示する。
ユーザー入力により担当者を決定する。
- {assigneeId}: 担当者の"assigneeId"値。

# backlog上の課題(issue)を取得する。
- {issueKey}: `git branch --show-current | grep -oE '[A-Z_]+-[0-9]+'`の結果。
```mcp:backlog:get_issue
{
  "issueKey",
  "fields": "{\n  id as issueId\n}"
}
```

# issueに関連したbacklog上のプルリクエストを取得する。
- {projectKey}: `git remote get-url origin | grep -oE '[A-Z_]+'` の結果。
- {repoName}: `git remote get-url origin | grep -oE '[^/]+\.git$' | sed 's/\.git$//'` の結果。
- {OPEN_STATUS_ID}: 1。open状態のステータスID。
- {ONE}: 1。取得数。
```mcp:backlog:get_pull_requests
{
  "projectKey",
  "repoName",
  "issueId": [${issueId}],
  "statusId": [${OPEN_STATUS_ID}],
  "count": ${ONE},
  "fields": "{\n  number\n}"
}
```

# backlog上のプルリクエストの担当者を更新する。
```mcp:backlog:update_pull_request
{
  "projectKey",
  "repoName",
  "number",
  "assigneeId"
}
```

# プルリクエストのURLを表示する。
- {pullRequestUrl}: `https://diezon.backlog.com/git/${projectKey}/${repoName}/pullRequests/${number}`形式。
{pullRequestUrl}をユーザーに通知する。