---
agent: agent
description: 受注詳細画面(受注登録画面)から、受注を作成(更新)した際、updateReceiveOrder を実行する。その中で、受注管理タグ(ReceiveOrderTag)をupsert する実装を行いたい。
tools: ["vscode", "execute", "read", "edit", "search", "web", "agent", "todo"]
model: Gemini 3 Pro (Preview) (copilot)
---

# 概要

受注詳細画面(受注登録画面)から、受注を作成(更新)した際、updateReceiveOrder を実行する。その中で、受注管理タグ(ReceiveOrderTag)をupsert する実装を行いたい。

# タスク

src配下の既存コードを全て読み込み、既存の構成を理解してください。
既存の構成に合わせる形で、ReceiveOrderTagDtoUpsertProcessorクラスと、
ReceiveOrdersService.upsertReceiveOrderReceiveOrderTags()関数を実装してください。

# 参考情報

ReceiveOrderTagDtoUpsertProcessorは、GraphQL から modelへデータ変換を行うクラスです。
ReceiveOrderTagDtoUpsertProcessorは、ReceiveOrder.receiveOrderReceiveOrderTagsのモデルを作成するのが責務です。

GraphQLリクエスト例は以下です。

```graphql
mutation UpdateReceiveOrder(
  $id: ID!
  $channel: ConnectOnlyInput
  $usedPoint: Float
  $managementCode: String
  $held: Boolean
  $holdMemo: String
  $calculating: Boolean
  $campaigns: OrderCampaignRelationInput
  $shippingAddresses: OrderShippingAddressRelationInput
  $receiveOrderStatus: ConnectOnlyInput
  $items: ReceiveOrderItemRelationInput
  $receiveOrderCustomer: UpdateOrderCustomerInput
  $receiveOrderPayments: ReceiveOrderPaymentRelationInput
  $receiveOrderTags: MasterMultiRelationInput
) {
  updateReceiveOrder(
    id: $id
    channel: $channel
    usedPoint: $usedPoint
    managementCode: $managementCode
    held: $held
    holdMemo: $holdMemo
    calculating: $calculating
    campaigns: $campaigns
    shippingAddresses: $shippingAddresses
    receiveOrderStatus: $receiveOrderStatus
    items: $items
    receiveOrderCustomer: $receiveOrderCustomer
    receiveOrderPayments: $receiveOrderPayments
    receiveOrderTags: $receiveOrderTags
  ) {
    id
    serial
  }
}
{
  "managementCode": "",
  "holdMemo": "",
  "channel": {
    "connect": {
      "id": "front"
    }
  },
  "held": false,
  "usedPoint": 0,
  "receiveOrderPointAdjusts": [],
  "calculating": true,
  "taxConfig": {
    "priceTaxRegisteredRule": "INCLUDE",
    "priceTaxShownRule": "INCLUDE"
  },
  "updatedAt": "2026-01-05T17:00:02.694Z",
  "id": "cmk0eclgn03a13y353amnkyuj",
  "note": "aaaa",
  "receiveOrderStatus": {
    "connect": {
      "id": "cm0c5g0hc00nv3s3ir6y6bz64"
    }
  },
  "items": {
    "update": [
      {
        "id": "uttvcei57f6kak2zw580yvtm",
        "adjustPrice": null,
        "adjustMemo": null,
        "quantity": 2,
        "originPrice": 3371
      }
    ]
  },
  "receiveOrderCustomer": {
    "customer": {
      "connect": {
        "id": "cly3pfyhy00033w3bugmmlohq"
      }
    },
    "zip": "2210856",
    "prefecture": 14,
    "address1": "横浜市神奈川区三ツ沢上町",
    "address2": "ヨコハマ",
    "address3": "ビル10001",
    "phone": "0900000000",
    "firstName": "弘輝",
    "lastName": "笹渕",
    "corporation": "株式会社Diezonモービー",
    "email": "hiroki.sasabuchi@diezon.co.jp",
    "firstNameKana": "ヒロキ",
    "lastNameKana": "ササブチ"
  },
  "receiveOrderPayments": {
    "update": [
      {
        "id": "cmk0eclk503a93y35vmg0cq0l",
        "amount": 6742,
        "paymentMethodId": "cly3p3yqy00043wcp5umbri3b",
        "paymentStatusId": "WAITING",
        "paidAmount": null
      }
    ]
  },
  "receiveOrderTags": {
    "connectOrCreate": [{ "name": "name 998" }, { "name": "name 1" }, { "name": "name 11" }, { "name": "name 1001" }],
    "disconnect": [{ "id": "id 2" }]
  }
}
```

          - create-customer-tags.dto.ts
          - customer-tag-pagination.args.ts
        - model
          - customer-tags.model.ts

・モジュール作成しません。モジュールは既存の「CustomersModule」を利用します。

```

## ファイル生成コマンド

### 顧客管理タグ機能

```

▼resolver
nest g resolver modules/user/customers/customer-tags.admin

▼service
nest g service modules/user/customers/customer-tags

▼type
nest g class modules/user/customers/customer-tags.type

▼dto ( query, mutation, model )
nest g class modules/user/customers/dto/create-customer-tags.dto
nest g class modules/user/customers/dto/customer-tag-pagination.args
nest g class modules/user/customers/model/customer-tags.model

````

## DB設計

### 顧客管理タグ機能

```prisma
model Customer {
  customerCustomerTags CustomerCustomerTag[]
}
model CustomerTag {
  id               String @id @default(cuid()) @db.VarChar(30)
  name             String @unique @db.VarChar(255)
  code             String @unique @db.VarChar(255)
  description      String @db.Text @default("")

  customerCustomerTags CustomerCustomerTag[]

  createdAt        DateTime @default(now())
  updatedAt        DateTime @updatedAt
}
model CustomerCustomerTag {
  customer         Customer @relation(fields: [customerId], references: [id], onDelete: Cascade)
  customerId       String @db.VarChar(30)
  customerTag      CustomerTag @relation(fields: [customerTagId], references: [id], onDelete: Cascade)
  customerTagId    String @db.VarChar(30)

  @@id([customerId, customerTagId])
}
````

### 受注管理タグ機能

```
// 既存テーブル
model ReceiveOrder {
  receiveOrderReceiveOrderTags ReceiveOrderReceiveOrderTag[]
}
// 新規作成予定
model ReceiveOrderTag {
  id               String @id @default(cuid()) @db.VarChar(30)
  name             String @unique @db.VarChar(255)
  code             String @unique @db.VarChar(255)
  description      String @db.Text @default("")

  receiveOrderReceiveOrderTags ReceiveOrderReceiveOrderTag[]

  createdAt        DateTime @default(now())
  updatedAt        DateTime @updatedAt
}
// 新規作成予定
model ReceiveOrderReceiveOrderTag {
  receiveOrder         ReceiveOrder @relation(fields: [receiveOrderId], references: [id], onDelete: Cascade)
  receiveOrderId       String @db.VarChar(30)
  receiveOrderTag      ReceiveOrderTag @relation(fields: [receiveOrderTagId], references: [id], onDelete: Cascade)
  receiveOrderTagId    String @db.VarChar(30)

  @@id([receiveOrderId, receiveOrderTagId])
}
```

### 出荷管理タグ機能

```
// 既存テーブル
model Shipping {
  shippingShippingTags ShippingShippingTag[]
}
// 新規作成予定
model ShippingTag {
  id               String @id @default(cuid()) @db.VarChar(30)
  name             String @unique @db.VarChar(255)
  code             String @unique @db.VarChar(255)
  description      String @db.Text @default("")

  shippingShippingTags ShippingShippingTag[]

  createdAt        DateTime @default(now())
  updatedAt        DateTime @updatedAt
}
// 新規作成予定
model ShippingShippingTag {
  shipping         Shipping @relation(fields: [shippingId], references: [id], onDelete: Cascade)
  shippingId       String @db.VarChar(30)
  shippingTag      ShippingTag @relation(fields: [shippingTagId], references: [id], onDelete: Cascade)
  shippingTagId    String @db.VarChar(30)

  @@id([shippingId, shippingTagId])
}
```

### コンタクト管理タグ機能

```
// 既存テーブル
model Contact {
  contactContactTags ContactContactTag[]
}
// 新規作成予定
model ContactTag {
  id               String @id @default(cuid()) @db.VarChar(30)
  name             String @unique @db.VarChar(255)
  code             String @unique @db.VarChar(255)
  description      String @db.Text @default("")

  contactContactTags ContactContactTag[]

  createdAt        DateTime @default(now())
  updatedAt        DateTime @updatedAt
}
// 新規作成予定
model ContactContactTag {
  contact         Contact @relation(fields: [contactId], references: [id], onDelete: Cascade)
  contactId       String @db.VarChar(30)
  contactTag      ContactTag @relation(fields: [contactTagId], references: [id], onDelete: Cascade)
  contactTagId    String @db.VarChar(30)

  @@id([contactId, contactTagId])
}
```
