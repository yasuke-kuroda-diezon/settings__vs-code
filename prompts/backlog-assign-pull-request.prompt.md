---
mode: agent
description: backlog上のプルリクエストの担当者を更新する。
tools: ['runCommands', 'runTasks', 'backlog/*', 'changes']
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
担当者一覧の"no"と"assigneeUserName"をユーザーに提示する。"no"で選択させる。
ユーザー入力により担当者を決定する。
- {assigneeId}: 担当者の"assigneeId"値。

# backlog上の課題(issue)を取得する。
- {issueKey}: `git branch --show-current | grep -oE '[A-Z_]+-[0-9]+'`の結果。
```mcp:backlog:get_issue
{
  "issueKey",
  "fields": "{\n  id as issueId\n  projectId\n}"
}
```

# issueに関連したbacklog上のプルリクエストを取得する。
- {repoName}: `git remote get-url origin | grep -oE '[^/]+\.git$' | sed 's/\.git$//'` の結果。
- {openStatusId}: 1。open状態のステータスID。
- {one}: 1。取得数。
```mcp:backlog:get_pull_requests
{
  "projectId",
  "repoName",
  "issueId": [${issueId}],
  "statusId": [${openStatusId}],
  "count": ${one},
  "fields": "{\n  number\n}"
}
```

# backlog上のプルリクエストの担当者を更新する。
```mcp:backlog:get_project
{
  "projectId",
  "fields": "{\n  projectKey\n}"
}
```
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