---
agent: agent
description: 管理画面の詳細画面について、モデルの作成者と更新者の表示方針の統一を行う。
tools: ["vscode", "execute", "read", "edit", "search", "web", "agent", "todo"]
model: Claude Opus 4.5 (copilot)
---

# 概要

管理画面の詳細画面について、モデルの作成者と更新者の表示方針の統一を行う。

作成者・更新者の扱い
作成者：DBに`creatorAdminMemberId`カラムを保持する
更新者：DBに`updaterAdminMemberId`カラムを保持し、最終更新者のみ管理する

## 表示文言のフォーマット統一

### 作成者表示フォーマット

作成者表示フォーマット：YYYY/MM/DD hh:mm:ss に{{メンバー名}}により作成されました。
画面ごとの文言揺れは廃止し、上記フォーマットに統一する。
ただし「この{受注／発注／入荷}は」等の接頭文は画面仕様に応じて付与可とする
例）この入荷は2026/01/27 20:28:15 に{{メンバー名}}により作成されました。
`authorText`関数や`CreatorAdminMember`コンポーネントを使用して表示を行う

### 更新者表示フォーマット

更新者表示フォーマット：最終更新：YYYY/MM/DD hh:mm:ss（{{メンバー名}}）
共通コンポーネント(`UpdaterAdminMember`)を使用する方針で統一する。

## 表示対象画面

以下の画面を対象に、作成者・更新者表示のフォーマット統一を行う。

- 商品詳細(Product)：対応済み。参考にすること。
- 受注詳細(ReceiveOrder)：対応済み。参考にすること。
- 返品・交換詳細(ReturnOrder)：未対応
- 発注詳細(StockOrder)：未対応
- 発注先詳細(Supplier)：未対応
- 入荷詳細(Arrival)：対応済み。参考にすること。
- 出荷詳細(Shipping)：未対応
- 会員詳細(Customer)：未対応
- 組織グループ詳細(CustomerCompany)：未対応
- コンタクト詳細(Contact)：未対応
- キャンペーン詳細(Campaign)：未対応

# タスク

対応済み画面（商品詳細、受注詳細、入荷詳細）のコードを参照し変更内容を把握し、未対応画面(返品・交換詳細、発注詳細、発注先詳細、出荷詳細、会員詳細、組織グループ詳細、コンタクト詳細、キャンペーン詳細)
について、フロントエンド側の作成者・更新者表示のフォーマット統一を行ってください。
(API側の対応は完了しました。)

# 参考資料

## schema.prisma修正内容

/Users/yasuke_kuroda/work/headless/regolith-docker/regolith-api-ctr/regolith-api/prisma/migrations/20260128010304_add_creator_admin_member_id_and_updater_admin_member_id_to_product_receive_order_order_return_stock_order_supplier_arrival_shipping_customer_customer_company_contact_campaign/migration.sql
を参照して下さい。prisma の モデル内容は全て修正済みです。

## 商品詳細

### API

修正 prisma/schema.prisma
修正 src/modules/content/products/model/products.model.ts
修正 src/modules/content/products/products.service.ts
修正 src/modules/content/products/products.type.ts

### フロントエンド

修正 src/common/gql/product.ts
修正 src/common/model/content/product.ts
修正 src/components/container/form/product/ProductFomTitle.tsx
修正 src/components/container/form/product/ProductForm.tsx
修正 src/components/container/form/product/relation/ProductCoreForm.tsx

## 受注詳細

### API

修正 prisma/schema.prisma
修正 src/modules/order/receive-orders/model/receive-orders.model.ts
修正 src/modules/order/receive-orders/receive-orders.service.ts
修正 src/modules/order/receive-orders/receive-orders.type.ts

### フロントエンド

修正 src/common/gql/receiveOrder.ts
修正 src/common/model/order/receiveOrder.ts
修正 src/components/container/form/orderReturn/OrderReturnForm.tsx
修正 src/components/container/form/receiveOrder/ReceiveOrderForm.tsx
修正 src/components/container/modules/orderReturn/ReceiveOrderReturnOrigin.tsx

## 入荷詳細

### API

修正 prisma/schema.prisma
修正 src/modules/order/arrivals/arrivals.service.ts
修正 src/modules/order/arrivals/arrivals.type.ts
修正 src/modules/order/arrivals/model/arrivals.model.ts

### フロントエンド

修正 src/common/gql/arrival.ts
修正 src/common/model/order/arrival.ts
修正 src/components/container/form/arrival/ArrivalForm.tsx
修正 src/components/container/form/arrival/block/ArrivalOverview.tsx

## 共通コンポーネント

### API

src/common/util/admin-member.util.ts

### フロントエンド

src/components/view/atoms/adminMember/UpdaterAdminMember.tsx // 必ず利用すること
src/components/view/molecules/adminMember/CreatorAdminMember.tsx // 参考にすること。利用できそうなら利用すること

## storybookモックデータ修正

修正 src/stories/container/modal/modalMock.ts
修正 src/stories/mock/content/productMock.tsx
修正 src/stories/mock/content/productSkuMock.tsx
修正 src/stories/mock/order/receiveOrderMock.tsx

## その他API修正

A prisma/migrations/20260128010304_add_creator_admin_member_id_and_updater_admin_member_id_to_product_receive_order_order_return_stock_order_supplier_arrival_shipping_customer_customer_company_contact_campaign/migration.sql
M prisma/schema.prisma
M src/admin.gql
M src/front.gql
M src/modules/content/suppliers/suppliers.admin.resolver.ts
M src/modules/content/suppliers/suppliers.model.ts
M src/modules/content/suppliers/suppliers.service.ts
A src/modules/content/suppliers/suppliers.type.ts
M src/modules/order/campaigns/campaigns.service.ts
M src/modules/order/campaigns/campaigns.type.ts
M src/modules/order/campaigns/model/campaigns.model.ts
M src/modules/order/order-returns/model/order-returns.model.ts
M src/modules/order/order-returns/order-returns.service.ts
M src/modules/order/order-returns/order-returns.type.ts
M src/modules/order/receive-orders/processors/shipping-address-dto-upsert.processor.ts
M src/modules/order/shippings/model/shippings.model.ts
M src/modules/order/shippings/shippings.service.ts
M src/modules/order/shippings/shippings.type.ts
M src/modules/order/stock-orders/model/stock-orders.model.ts
M src/modules/order/stock-orders/stock-order-mail.service.ts
M src/modules/order/stock-orders/stock-orders.service.ts
M src/modules/order/stock-orders/stock-orders.type.ts
M src/modules/user/contacts/contacts.service.ts
M src/modules/user/contacts/contacts.type.ts
M src/modules/user/contacts/mail/contact-mail.service.ts
M src/modules/user/contacts/model/contacts.model.ts
M src/modules/user/customers/customer-company.service.ts
M src/modules/user/customers/customer-segments.service.ts
M src/modules/user/customers/customers.admin.resolver.ts
M src/modules/user/customers/customers.service.ts
M src/modules/user/customers/customers.type.ts
M src/modules/user/customers/model/customers.model.ts
