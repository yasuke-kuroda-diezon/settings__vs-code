---
agent: agent
description: 出荷タイムライン機能のテストNG修正を行う。
tools: ["vscode", "execute", "read", "edit", "search", "web", "agent", "todo"]
model: Claude Opus 4.5 (copilot)
---

# 概要

出荷タイムライン機能は、以下の仕様で実装されていますが、一部機能が未実装となっています。

実装状況 機能分類 メッセージ分類 メッセージ トリガー 編集/削除 投稿者名 リンク 備考
実装済 出荷 メッセージ この出荷を作成しました。 フロントAPIに起因した出荷作成 不可 会員名 -
実装済 出荷 メッセージ この出荷を作成しました。 管理画面での出荷登録 不可 {{メンバー名}} -
実装済 出荷 メッセージ この出荷を編集しました。 管理画面での出荷更新（連携され受注などから商品が編集されたり、数量が変更された場合を含む） 不可 {{メンバー名}} -
実装済 出荷 メッセージ {{メッセージ内容}} 管理画面での管理用メモ追加 可 {{メンバー名}} -
実装済 出荷 メッセージ 受注#XXXX #XXXXを連携しました。 出荷に関連する受注が登録された場合 不可 注文者/メンバー名 あり
実装済 出荷 メッセージ 返品/交換#XXXX #XXXXを連携しました。 出荷に関連する返品/交換が登録された場合 不可 注文者/メンバー名 あり
実装済 出荷 メッセージ 発注#XXXX #XXXXを連携しました。 出荷に関連する発注が登録された場合 不可 注文者/メンバー名 あり
実装済 出荷 メッセージ "受注#XXXXの連携を解除しました。 返品/交換#XXXXの連携を解除しました。 入荷#XXXXの連携を解除しました。" 出荷に連携された受注、返品/交換、発注が解除された場合 不可 メンバー名 あり ログ追加時の内容
実装済 出荷 メッセージ メールを送信しました。 出荷に関わるメール送信 不可 システム/メンバー名 -
実装済 出荷 付帯記録 出荷ステータス：{{変更ステータス}} 出荷ステータス変更 不可 - -
実装済 出荷 付帯記録 商品：XX点/XX件 出荷合計商品点数/件数が変更された場合 不可 - - ログ追加時の内容
未実装 出荷 付帯記録 出荷#XXXXへ{商品名 - バリエーション1/バリエーション2}を移動しました 別の出荷へ商品を移動した場合 不可 不可 あり ログ追加時の内容
未実装 出荷 付帯記録 出荷#XXXXから{商品名 - バリエーション1/バリエーション2}を移動しました 別の出荷へ商品を移動した場合 不可 不可 あり ログ追加時の内容
実装済 出荷 付帯記録 メール内容 出荷に関わるメール送信 不可 - あり モーダルでメールを表示する。

# タスク

「未実装」の出荷タイムライン機能について、機能追加うための、方針を2パターン提案して下さい。
未実装 出荷 付帯記録 出荷#XXXXへ{商品名 - バリエーション1/バリエーション2}を移動しました 別の出荷へ商品を移動した場合 不可 不可 あり ログ追加時の内容
未実装 出荷 付帯記録 出荷#XXXXから{商品名 - バリエーション1/バリエーション2}を移動しました 別の出荷へ商品を移動した場合 不可 不可 あり ログ追加時の内容

アウトプットは
・ShippingLogTypeの構造変更内容
・実現方法の詳細

です。

# 参考情報

Shipping.ShippingItem.ShippingItemVariationValueという辿り方でバリエーションを取得できます。
以下のコードで「商品名 - バリエーション1/バリエーション2」の部分を生成可能です。

```
{ShippingItem.name} -
{ShippingItem.variationValues
.map((variationValue) => variationValue.valueName)
.join('/') + ' '}
```

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
