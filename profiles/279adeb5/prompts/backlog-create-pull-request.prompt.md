---
mode: agent
description: Create a pull request on Backlog using the backlogMCP.
tools: [ "runNotebooks", "search", "runCommands", "runTasks", "usages", "vscodeAPI", "think", "problems", "changes", "testFailure", "openSimpleBrowser", "fetch", "githubRepo", "todos", "backlog"]
model: GPT-4o (copilot)
---

以下の手順に従って、backlog mcp の add_pull_request ツールを実行してください。

1. `git remote -v`コマンドを実行し、出力を解析してください。
   originのURLには{プロジェクトキー}/{リポジトリID}.gitの形式が含まれています。
   {プロジェクトキー}(大文字アルファベットと\_のみで構成)を取得してください。
   {リポジトリID}を取得してください。
2. `git branch`コマンドを実行し、出力を解析してください。
   現在のブランチを{マージするブランチ名}として取得してください。
   `release/`で始まるブランチを{ベースブランチ名}として取得してください。(`release/`で始まるブランチが複数ある場合は、ユーザーに選択を促してください。)
3. {マージするブランチ名}から{課題ID}を解析してください。
   {課題ID}はBacklog課題の識別子で、`{プロジェクトキー}-{課題番号}`の形式です。
4. {課題タイトル}を取得してください。
   backlogMCPの`get_issue`ツールを実行し、{課題ID}に対応する{課題タイトル}を取得してください。
5. 解析結果をユーザーに表示したら確認を求めずに直ちに後続ステップを実行してください。
   プロジェクトキー:{プロジェクトキー}
   課題ID:{課題ID}
   課題タイトル:{課題タイトル}
   リポジトリID:{リポジトリID}
   ベースブランチ名:{ベースブランチ名}
   マージするブランチ名:{マージするブランチ名}
6. `git commit -m "{課題ID}: {1行の英文コミットメッセージ}"`コマンドを実行してください。{1行の英文コミットメッセージ}部分は変更内容を簡潔に表現します。
7. `git push -u origin {マージするブランチ名}`コマンドを実行してください。
8. backlogMCP の`add_pull_request`ツールを利用してください。
   ベースブランチ(`"base"`)に{ベースブランチ名}を設定してください。
   マージするブランチ(`"branch"`)に{マージするブランチ名}を設定してください。
   関連課題(`"issueId"`)に{課題ID}を設定してください。
   タイトル(`"summary"`)は{課題タイトル}としてください。
   説明(`"description"`)は`git diff {ベースブランチ名}..{マージするブランチ名}`コマンドの出力をもとに、変更内容の詳細を生成してください。
9. 作成したプルリクエストのURLを絶対パスでユーザーに伝えてください。
