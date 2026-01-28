---
agent: agent
description: 顧客管理タグ(CustomerTag)の既存実装を参考に、「受注」「出荷」「コンタクト」管理タグ機能のGraphQL schema設計を行う。
tools: ['vscode', 'execute', 'read', 'edit', 'search', 'web', 'agent', 'todo']
model: Gemini 3 Pro (Preview) (copilot)
---

# 概要
顧客管理タグ(CustomerTag)の既存実装を参考に、
・受注管理タグ(ReceiveOrderTag)機能を新規構築したい。
・出荷管理タグ(ShippingTag)機能を新規構築したい。
・コンタクト管理タグ(ContactTag)機能を新規構築したい。
それぞれDB設計とAPIコード設計は行ったので、GraphQL schema設計を行いたい。

# タスク
CustomerTagsAdminResolver及び、admin.gqlの既存実装を参考にしてください。
・受注管理タグ(ReceiveOrderTag)機能のGraphQL schema設計を行ってください。
・出荷管理タグ(ShippingTag)機能のGraphQL schema設計を行ってください。
・コンタクト管理タグ(ContactTag)機能のGraphQL schema設計を行ってください。

# 期待する成果物
以下の「参考情報」と同じフォーマットで、
・受注管理タグ機能のGraphQL schema設計
・出荷管理タグ機能のGraphQL schema設計
・コンタクト管理タグ機能のGraphQL schema設計
を作成してください。

# 参考情報
## GraphQL schema設計
### 顧客管理タグ機能
```
customerTag(code: String!): CustomerTag!
customerTags(page: Int = 1, perPage: Int = 200, where: CustomerTagWhereInput, orderBy: CustomerTagOrderByInput): PaginatedCustomerTag!
createCustomerTag(id: ID, name: String!, code: String, description: String, customerEnabled: Boolean, customerCompanyEnabled: Boolean): CustomerTag!
updateCustomerTag(id: ID!, name: String, code: String, description: String, customerEnabled: Boolean, customerCompanyEnabled: Boolean): CustomerTag!
mergeCustomerTag(id: ID!, toCustomerTagIds: [ID!]!): Result!
deleteCustomerTag(id: ID!): CustomerTag!
```
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
```
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

# APIコード設計
## ファイル構成
### 受注管理タグ
```
- src
  - modules
    - order
      - receive-orders
        - receive-order-tags.admin.resolver.ts
        - receive-order-tags.service.ts
        - receive-order-tags.type.ts
        - dto
          - create-receive-order-tags.dto.ts
          - receive-order-tag-pagination.args.ts
        - model
          - receive-order-tags.model.ts

・モジュール作成しません。モジュールは既存の「ReceiveOrdersModule」を利用します。
```

### 出荷管理タグ
```
- src
  - modules
    - order
      - shippings
        - shipping-tags.admin.resolver.ts
        - shipping-tags.service.ts
        - shipping-tags.type.ts
        - dto
          - create-shipping-tags.dto.ts
          - shipping-tag-pagination.args.ts
        - model
          - shipping-tags.model.ts

・モジュール作成しません。モジュールは既存の「ShippingsModule」を利用します。
```

### コンタクト管理タグ
```
- src
  - modules
    - user
      - contacts
        - contact-tags.admin.resolver.ts
        - contact-tags.service.ts
        - contact-tags.type.ts
        - dto
          - create-contact-tags.dto.ts
          - contact-tag-pagination.args.ts
        - model
          - contact-tags.model.ts

・モジュール作成しません。モジュールは既存の「ContactsModule」を利用します。
```

### 顧客管理タグ
```
- src
  - modules
    - user
      - customers
        - customer-tags.admin.resolver.ts
        - customer-tags.service.ts
        - customer-tags.type.ts
        - dto
          - create-customer-tags.dto.ts
          - customer-tag-pagination.args.ts
        - model
          - customer-tags.model.ts

・モジュール作成しません。モジュールは既存の「CustomersModule」を利用します。
```