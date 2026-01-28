---
agent: agent
description: 顧客管理タグ(CustomerTag)の既存実装を参考に、「受注」「出荷」「コンタクト」管理タグ機能のAPIコード設計を行う。
tools: ['vscode', 'execute', 'read', 'edit', 'search', 'web', 'agent', 'todo']
model: Gemini 3 Pro (Preview) (copilot)
---

# 概要
顧客管理タグ(CustomerTag)の既存実装を参考に、
・受注管理タグ(ReceiveOrderTag)機能を新規構築したい。
・出荷管理タグ(ShippingTag)機能を新規構築したい。
・コンタクト管理タグ(ContactTag)機能を新規構築したい。
それぞれDB設計は行ったので、APIコード設計を行いたい。

# タスク
CustomersModule及び、顧客管理タグ(CustomerTag)の既存実装を参考にしてください。
・ReceiveOrdersModuleに追加する、受注管理タグ(ReceiveOrderTag)機能のAPIコード設計を行ってください。
・ShippingsModuleに追加する、出荷管理タグ(ShippingTag)機能のAPIコード設計を行ってください。
・ContactsModuleに追加する、コンタクト管理タグ(ContactTag)機能のAPI

# 期待する成果物
以下の「参考情報」と同じフォーマットで、
・受注管理タグ機能のファイル構成
・受注管理タグ機能のファイル生成コマンド
・出荷管理タグ機能のファイル構成
・出荷管理タグ機能のファイル生成コマンド
・コンタクト管理タグ機能のファイル構成
・コンタクト管理タグ機能のファイル生成コマンド
を作成してください。

# 参考情報
## ファイル構成
### 顧客管理タグ機能
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