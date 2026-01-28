---
agent: agent
description: backlog上のプルリクエストにコメントを追加する。
tools: ['execute', 'read', 'search', 'backlog/*']
model: GPT-4o (copilot)
---
手順はチャット欄に出力しない。手順に従い順に実行する。

# 担当者を決定する。
```担当者一覧
[
  {"no": 1, "assigneeUserName": "Hiroki Sasabuchi", "assigneeId": 63869, "assigneeUserId": "*NyCzJSeNXO"},
  {"no": 2, "assigneeUserName": "Koki Morii", "assigneeId": 31071, "assigneeUserId": "*FJC77ybwMs"},
  {"no": 3, "assigneeUserName": "Akari Imazumi", "assigneeId": 314786, "assigneeUserId": "*kopP7dqsof"},
  {"no": 4, "assigneeUserName": "橋本慎也", "assigneeId": 372545, "assigneeUserId": "*QylJh4AmUo"},
  {"no": 5, "assigneeUserName": "鶴来朋也", "assigneeId": 372544, "assigneeUserId": "*pvdNatmQSn"},
  {"no": 6, "assigneeUserName": "yasuke kuroda", "assigneeId": 380374, "assigneeUserId": "*SEXNCqwWhY"}
]
```
担当者一覧の"no"と"assigneeUserName"をユーザーに提示する。「以下の担当者から番号を選択してください。」と表示する。
ユーザー入力により担当者を決定する。
- {assigneeId}: 担当者の"assigneeId"値。
- {notifiedAnchorElement}: `<a href="/user/${assigneeUserId}" data-linktype="mention" class="user-mention backlog-card-checked" data-id="${assigneeId}" data-user-id="${assigneeUserId}" data-username="${assigneeUserName}">@${assigneeUserName}</a>`

### コメント文章を生成する。
```本文一覧
[
  {"no": 1, "commentMessage": "お疲れ様です！\n\n本件、対応致しましたので、PR提出させていただきます。\nお手隙の際にご確認の程お願いいたします。"},
  {"no": 2, "commentMessage": "コメントありがとうございます！\n\n修正致しましたので、お手隙の際にご確認のほどお願いいたします。"},
  {"no": その他, "commentMessage": "自由入力"}
]
```
本文一覧の"no"と"commentMessage"をユーザーに提示する。「以下の本文から番号を選択、もしくは自由入力してください。」と表示する。
ユーザー入力により本文を決定する。
- {commentMessage}: 数字入力時は本文の"commentMessage"値。数字以外入力時はユーザー入力値。
- {content}: `${notifiedAnchorElement}\n${commentMessage}`形式で生成する。

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

### プルリクエストにコメントを追加する。
```mcp:backlog:add_pull_request_comment
{
  "projectKey",
  "repoName",
  "number",
  "content",
  "notifiedUserId": [{assigneeId}]
}
```
add_pull_request_commentツールを実行する。

# プルリクエストのURLを表示する。
- {pullRequestUrl}: `https://diezon.backlog.com/git/${projectKey}/${repoName}/pullRequests/${number}`形式。
{pullRequestUrl}をユーザーに通知する。