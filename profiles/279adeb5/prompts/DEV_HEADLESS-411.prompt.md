---
mode: agent
description: Create a pull request on Backlog using the backlogMCP.
tools: ['edit', 'runNotebooks', 'search', 'new', 'runCommands', 'runTasks', 'usages', 'vscodeAPI', 'think', 'problems', 'changes', 'testFailure', 'openSimpleBrowser', 'fetch', 'githubRepo', 'extensions', 'todos', 'figma-developer-mcp', 'context7', 'backlog']
model: GPT-5 (copilot)
---

## Figma情報

・バリエーション一覧（エンプティステート）
[https://www.figma.com/design/8flGsyvaN5BGJYobGuYscX/HL*管理*デザイン?node-id=19888-58504&m=dev](https://www.figma.com/design/8flGsyvaN5BGJYobGuYscX/HL_%E7%AE%A1%E7%90%86_%E3%83%87%E3%82%B6%E3%82%A4%E3%83%B3?node-id=19888-58504&m=dev)

・バリエーション一覧
[https://www.figma.com/design/8flGsyvaN5BGJYobGuYscX/HL*管理*デザイン?node-id=19888-58146&m=dev](https://www.figma.com/design/8flGsyvaN5BGJYobGuYscX/HL_%E7%AE%A1%E7%90%86_%E3%83%87%E3%82%B6%E3%82%A4%E3%83%B3?node-id=19888-58146&m=dev)

・リファレンスUI（チェックボックス、選択肢：あり、なし。ありを選択した際、商品とのリファレンスが1件以上のバリエーションのみ表示します。）
[https://www.figma.com/design/8flGsyvaN5BGJYobGuYscX/HL*管理*デザイン?node-id=33608-181101&m=dev](https://www.figma.com/design/8flGsyvaN5BGJYobGuYscX/HL_%E7%AE%A1%E7%90%86_%E3%83%87%E3%82%B6%E3%82%A4%E3%83%B3?node-id=33608-181101&m=dev)

## タスク

・管理画面のバリエーション一覧画面をsrc/app/(authentificated)/(standard)/product/variation/list/page.tsxに構築して下さい。現状、バリエーション一覧画面部分的に実装しているので、完成させて下さい。

## 参考情報

以下の「タグ一覧」画面を参考にして下さい。
・タグ一覧（エンプティステート）
[https://www.figma.com/design/8flGsyvaN5BGJYobGuYscX/HL*管理*デザイン?node-id=5468-22198&m=dev](https://www.figma.com/design/8flGsyvaN5BGJYobGuYscX/HL_%E7%AE%A1%E7%90%86_%E3%83%87%E3%82%B6%E3%82%A4%E3%83%B3?node-id=5468-22198&m=dev)

・タグ一覧
[https://www.figma.com/design/8flGsyvaN5BGJYobGuYscX/HL*管理*デザイン?node-id=1116-12467&m=dev](https://www.figma.com/design/8flGsyvaN5BGJYobGuYscX/HL_%E7%AE%A1%E7%90%86_%E3%83%87%E3%82%B6%E3%82%A4%E3%83%B3?node-id=1116-12467&m=dev)

・タグ一覧の実装（主要なファイルのみ抜粋）
src/app/(authentificated)/(standard)/product/tag/list/page.tsx
src/common/api/modules/tag.ts
src/common/gql/tag.ts
src/components/container/form/tag/**.tsx
src/components/container/modules/tag/**.tsx
src/components/container/page/product/tag/\*\*.tsx