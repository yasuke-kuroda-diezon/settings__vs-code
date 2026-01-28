---
agent: agent
description: タイムライン機能の改修を行う。受注タイムライン機能を参考に、出荷タイムライン機能の既存不具合を改修する。
tools: ["vscode", "execute", "read", "edit", "search", "web", "agent", "todo"]
model: Claude Opus 4.5 (copilot)
---

# 概要

タイムライン機能の改修を行う。受注タイムライン機能を参考に、出荷タイムライン機能の既存不具合を改修する。

# タスク

受注詳細画面（例：http://127.0.0.1:8010/receive-order/edit/1060）にて受注ステータスを「対応中」に変更して「保存する」ボタンを押下すると以下のタイムラインが表示される。
2026/01/26 黒田テスト
15:44:29 この受注を編集しました。
受注ステータス： 対応中

一方で、出荷詳細画面（例：http://127.0.0.1:8010/shipping/edit/2665）にて出荷ステータスを任意のステータスに変更して「保存する」ボタンを押下しても、タイムラインが表示されない。
その後、画面をリロードすると、以下のタイムラインが表示される。
2026/01/26 黒田テスト

15:50:19 この出荷を編集しました。
出荷ステータス： 出荷待ち

恐らく、出荷タイムラインのデータ更新後に出荷詳細画面を更新できていないことが原因と考えられる。
そのため、受注タイムライン機能を参考に、受注タイムラインの仕組みを読み込んで、出荷タイムライン機能の既存不具合を修正してください。

# 参考資料

## 出荷タイムライン＞フロントエンドコード

追加 src/common/api/modules/shippingLog.ts
追加 src/common/app/modules/shippingLog.tsx
追加 src/common/gql/shippingLog.ts
追加 src/common/model/order/shippingLog.ts
修正 src/components/container/form/shipping/ShippingForm.tsx
追加 src/components/container/form/shipping/block/ShippingMemoBlock.tsx
追加 src/components/container/form/shipping/relation/ShippingLogContent.tsx
追加 src/components/container/form/shipping/relation/ShippingTimeline.tsx
修正 src/components/container/page/shipping/ShippingEditPage.tsx

## 出荷タイムライン＞APIコード

修正 src/modules/order/order-returns/order-returns.module.ts
修正 src/modules/order/order-returns/order-returns.service.ts
修正 src/modules/order/receive-order-logs/receive-order-logs.service.ts
修正 src/modules/order/receive-orders/receive-order-admin.service.ts
修正 src/modules/order/receive-orders/receive-orders.module.ts
修正 src/modules/order/receive-orders/receive-orders.service.ts
追加 src/modules/order/shipping-logs/dto/create-shipping-log.dto.ts
追加 src/modules/order/shipping-logs/dto/shipping-log-pagination.args.ts
追加 src/modules/order/shipping-logs/model/shipping-logs.model.ts
追加 src/modules/order/shipping-logs/shipping-logs.admin.resolver.ts
追加 src/modules/order/shipping-logs/shipping-logs.module.ts
追加 src/modules/order/shipping-logs/shipping-logs.service.ts
修正 src/modules/order/shippings/shipping-mail.service.ts
修正 src/modules/order/shippings/shipping-status.state-machine.ts
修正 src/modules/order/shippings/shippings.module.ts
修正 src/modules/order/shippings/shippings.service.ts
修正 src/modules/order/shoppings/shoppings.service.ts
修正 src/modules/order/stock-orders/stock-orders.service.ts
修正 src/modules/util/flexible-db/dyanamodb.service.ts
修正 src/modules/util/flexible-db/flexible-db.param.ts
