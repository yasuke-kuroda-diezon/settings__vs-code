---
model: GPT-5 (copilot)
description: Use the context7 mcp to explain the given topic.
tools: ['vscode', 'execute', 'read', 'search', 'web', '@upstash/context7-mcp/*', 'todo']
---

context7 MCPを利用して、ユーザーが選択したコードもしくは入力されたテキストについて、 利用技術とそのバージョンを把握した上で、詳細に解説して下さい。

1. ユーザー入力テキストの利用技術を特定する.

- バージョン特定のための参考ファイル
  - TypeScriptプロジェクト
    - package.json
  - PHPプロジェクト
    - composer.json

2. ユーザー入力テキストの周辺コードを参照し読み込む.

3. 利用技術とバージョンを元に、詳細に解説する.

use context7