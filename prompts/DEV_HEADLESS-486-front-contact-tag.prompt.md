---
agent: agent
description: 顧客管理タグ(CustomerTag)や入出荷管理タグ(ArrivalShippingTag)の既存実装を参考にして、管理画面にコンタクト管理タグ(ContactTag)を新規構築したい。
tools: ["vscode", "execute", "read", "edit", "search", "web", "agent", "todo"]
model: Claude Opus 4.5 (copilot)
---

# 概要

顧客管理タグ(CustomerTag)や入出荷管理タグ(ArrivalShippingTag)の既存実装を参考にして、管理画面にコンタクト管理タグ(ContactTag)を新規構築したい。
APIは構築済みです。フロントエンド部分(Next.js)の実装をお願いします。

# タスク

src配下の既存コードを全て読み込み、既存の構成を理解してください。
DB構成はPrismaスキーマを参照してください。
既存の顧客管理タグ(CustomerTag)の構成に合わせる形で、フロントエンド部分(Next.js)のコンタクト管理タグ(ContactTag)を実装してください。

・コンタクト管理タグ一覧(新規構築)：regolith-admin/src/app/(authentificated)/(standard)/contact/tag/list
・コンタクト管理タグ詳細(新規構築)：regolith-admin/src/app/(authentificated)/(standard)/contact/tag/new
・コンタクト管理タグ新規(新規構築)：regolith-admin/src/app/(authentificated)/(standard)/contact/tag/edit/[code]
・コンタクト一覧(実装追加対象です)：regolith-admin/src/app/(authentificated)/(standard)/contact/(contact)/list/page.tsx
・コンタクト詳細(実装追加対象です)：regolith-admin/src/app/(authentificated)/(standard)/contact/(contact)/edit/[serial]/page.tsx
・コンタクト新規(実装追加対象です)：regolith-admin/src/app/(authentificated)/(standard)/contact/(contact)/new/page.tsx

## ユビキタス(コンタクト管理タグ)

コンタクト管理タグ：ContactTag

## 機能概要(コンタクト管理タグ)

/コンタクト
コンタクトにタグ付けして管理できる、コンタクトタグ機能を提供する。
コンタクト管理タグは、タグ種別を持たないことに注意してください。(コンタクト管理タグとは、タグ種別部分のみが異なります。)

コンタクト管理タグ一覧：

- （※タグ種別は無い事に注意してください。）
- リファレンス(あり or なし)のチェックボックスで、中間テーブルの有無(ContactContactTag)を対象にフィルタリング可能。ありを選択した場合は、少なくとも1つ以上のコンタクトに紐づいているタグを表示。なしを選択した場合は、どのコンタクトにも紐づいていないタグを表示。
- タグ名で部分一致検索可能
- コンタクト管理タグ名、コンタクト管理タグコード、リファレンスを一覧表示

コンタクト管理タグ編集・新規

- （※タグ種別は無い事に注意してください。）
- コンタクト管理タグ名の入力必須
- コンタクト管理タグコードの任意入力
- 用途の任意入力
- リファレンスを表示
- タグマージモーダルから、既存のコンタクト管理タグとマージ可能（マージ元とマージ先のタグは単数選択を想定する）

コンタクト一覧：

- 「コンタクト管理タグ」でフィルタリング可能
- 一覧に「コンタクト管理タグ」の登録データを表示

コンタクト詳細・新規：

- （※タグ種別は無い事に注意してください。）
- 「コンタクト管理タグ」で複数のコンタクト管理タグの登録・解除が可能
- 「コンタクト管理タグ」マスタが多い場合は「もっと見る」ボタンからモーダルで選択可能

```prisma
// コンタクト
model Contact {
  contactContactTags ContactContactTag[]
}
// コンタクト管理タグ(新規追加済みです)
model ContactTag {
  id               String @id @default(cuid()) @db.VarChar(30)
  name             String @unique @db.VarChar(255)
  code             String @unique @db.VarChar(255)
  description      String @db.Text @default("")

  contactContactTags ContactContactTag[]

  createdAt        DateTime @default(now())
  updatedAt        DateTime @updatedAt
}
// コンタクト-コンタクト管理タグ中間テーブル(新規追加済みです)
model ContactContactTag {
  contact         Contact @relation(fields: [contactId], references: [id], onDelete: Cascade)
  contactId       String @db.VarChar(30)
  contactTag      ContactTag @relation(fields: [contactTagId], references: [id], onDelete: Cascade)
  contactTagId    String @db.VarChar(30)

  @@id([contactId, contactTagId])
}
```

# 参考情報(顧客管理タグ)

関連ファイルは、文字列"customerTag"で検索してください。

## ユビキタス(顧客管理タグ)

顧客管理タグ：CustomerTag
顧客管理タグ＞タグ種別＞会員：customerCustomerTag
顧客管理タグ＞タグ種別＞組織グループ：customerCompanyCustomerTag
会員：Customer
組織グループ：CustomerCompany

## パス(顧客管理タグ)

顧客管理タグ一覧：regolith-admin/src/app/(authentificated)/(standard)/customer/tag/list/page.tsx
顧客管理タグ編集：regolith-admin/src/app/(authentificated)/(standard)/customer/tag/edit/[code]/page.tsx
顧客管理タグ新規：regolith-admin/src/app/(authentificated)/(standard)/customer/tag/new/page.tsx

会員一覧：regolith-admin/src/app/(authentificated)/(standard)/customer/(customer)/list/page.tsx
会員詳細：regolith-admin/src/app/(authentificated)/(standard)/customer/(customer)/edit/[serial]/page.tsx
会員新規：regolith-admin/src/app/(authentificated)/(standard)/customer/(customer)/new/page.tsx

組織グループ一覧：regolith-admin/src/app/(authentificated)/(standard)/customer/company/list/page.tsx
組織グループ詳細：regolith-admin/src/app/(authentificated)/(standard)/customer/company/edit/[serial]/page.tsx
組織グループ新規：regolith-admin/src/app/(authentificated)/(standard)/customer/company/new/page.tsx

## 機能概要(顧客管理タグ)

会員と顧客グループにタグ付けして管理できる、顧客タグ機能を提供する。
顧客管理タグは、タグ種別を持つ。

顧客管理タグ一覧：

- タグ種別(会員 or 組織グループ)のチェックボックスで、DBカラム(customerEnabled or customerCompanyEnabled)を対象にフィルタリング可能
- リファレンス(会員 or 組織グループ)のチェックボックスで、中間テーブルの有無(CustomerCustomerTag or CustomerCompanyCustomerTag)を対象にフィルタリング可能
- タグ名で部分一致検索可能
- タグ種別、顧客管理タグ名、顧客管理タグコード、リファレンスを一覧表示

顧客管理タグ編集・新規

- タグ種別(会員 or 組織グループ)の選択必須
- 顧客管理タグ名の入力必須
- 顧客管理タグコードの任意入力
- 用途の任意入力
- タグマージモーダルから、既存の顧客管理タグとマージ可能（マージ元とマージ先のタグは単数選択を想定する）

会員一覧：

- 「管理タグ」でフィルタリング可能
- 一覧に「顧客管理タグ」の登録データを表示

会員詳細・新規：

- 顧客管理タグの種別が「会員」のものを対象に表示する
- 「管理タグ」で複数の顧客管理タグの登録・解除が可能
- 「管理タグ」マスタが多い場合は「もっと見る」ボタンからモーダルで選択可能
- タグ種別が指定されていない機能側で登録済のタグ名を指定しタグを登録しようとした場合には、新規登録ではなくタグ種別を追加する形で対応する。

組織グループ一覧：

「顧客管理タグ」に関する機能は無し

組織グループ詳細・新規：

- 顧客管理タグの種別が「組織グループ」のものを対象に表示する
- 「管理タグ」で複数の顧客管理タグの登録・解除が可能
- 「管理タグ」マスタが多い場合は「もっと見る」ボタンからモーダルで選択可能
- タグ種別が指定されていない機能側で登録済のタグ名を指定しタグを登録しようとした場合には、新規登録ではなくタグ種別を追加する形で対応する。

## DB定義(Prisma schema)(顧客管理タグ)

```prisma
// 既存テーブル
model Customer {
  customerCustomerTags CustomerCustomerTag[]
}
// 既存テーブル
model CustomerCompany {
  customerCompanyCustomerTags CustomerCompanyCustomerTag[]
}
// 既存テーブル
model CustomerTag {
  id               String @id @default(cuid()) @db.VarChar(30)
  name             String @unique @db.VarChar(255)
  code             String @unique @db.VarChar(255)
  description      String @db.Text @default("")
  customerEnabled  Boolean @default(false)
  customerCompanyEnabled Boolean @default(false)

  customerCustomerTags CustomerCustomerTag[]
  customerCompanyCustomerTags CustomerCompanyCustomerTag[]

  createdAt        DateTime @default(now())
  updatedAt        DateTime @updatedAt
}
// 既存テーブル
model CustomerCustomerTag {
  customer         Customer @relation(fields: [customerId], references: [id], onDelete: Cascade)
  customerId       String @db.VarChar(30)
  customerTag      CustomerTag @relation(fields: [customerTagId], references: [id], onDelete: Cascade)
  customerTagId    String @db.VarChar(30)

  @@id([customerId, customerTagId])
}
// 既存テーブル
model CustomerCompanyCustomerTag {
  customerCompany  CustomerCompany @relation(fields: [customerCompanyId], references: [id], onDelete: Cascade)
  customerCompanyId String @db.VarChar(30)
  customerTag      CustomerTag @relation(fields: [customerTagId], references: [id], onDelete: Cascade)
  customerTagId    String @db.VarChar(30)

  @@id([customerCompanyId, customerTagId])
}
```

## ファイル一覧(顧客管理タグ)(抜け漏れがあるかもしれません)

### API側(NestJS)(顧客管理タグ)

Prisma
prisma/migrations/20251204024729_create_customer_tag_and_customer_customer_tag_and_customer_company_customer_tag/migration.sql
prisma/schema.prisma

GraphQL
src/admin.gql
src/front.gql

Customers / Customer Tags
src/modules/user/customers/customers.module.ts
src/modules/user/customers/customers.type.ts
src/modules/user/customers/customer-company.service.ts

Customer Tags（新規）
src/modules/user/customers/customer-tags.admin.resolver.ts
src/modules/user/customers/customer-tags.service.ts
src/modules/user/customers/customer-tags.type.ts
src/modules/user/customers/model/customer-tags.model.ts

DTO
src/modules/user/customers/dto/create-customer-company.dto.ts
src/modules/user/customers/dto/create-customers.dto.ts
src/modules/user/customers/dto/create-customer-tags.dto.ts
src/modules/user/customers/dto/customer-company-pagination.args.ts
src/modules/user/customers/dto/customer-pagination.args.ts
src/modules/user/customers/dto/customer-tag-pagination.args.ts

Model
src/modules/user/customers/model/customers.model.ts

Utility
src/modules/util/code/code.params.ts

### フロントエンド側（Next.js）(顧客管理タグ)(抜け漏れがあるかもしれません)

App Router（pages）
src/app/(authentificated)/(standard)/customer/(customer)/edit/[serial]/page.tsx
src/app/(authentificated)/(standard)/customer/(customer)/list/page.tsx
src/app/(authentificated)/(standard)/customer/company/list/page.tsx
src/app/(authentificated)/(standard)/customer/tag/edit/[code]/page.tsx
src/app/(authentificated)/(standard)/customer/tag/list/page.tsx
src/app/(authentificated)/(standard)/customer/tag/new/page.tsx

API Modules
src/common/api/modules/customer.ts
src/common/api/modules/customerCompany.ts
src/common/api/modules/customerTag.ts
src/common/api/modules/master.ts

App Modules / Routing
src/common/app/modules/customerTag.ts
src/common/app/modules/tag.ts
src/common/app/path.ts

GraphQL
src/common/gql/customer.ts
src/common/gql/customerCompany.ts
src/common/gql/customerTag.ts

Form / Schema
src/common/form/schema.ts
src/components/container/form/category/CategoryRuleForm.tsx
src/components/container/form/category/categorySchema.ts
src/components/container/form/customer/customerSchema.ts
src/components/container/form/customer/relations/CustomerInfoForm.tsx
src/components/container/form/customerCompany/customerCompanyFormSchema.ts
src/components/container/form/customerCompany/relations/CustomerCompanyStatusForm.tsx
src/components/container/form/customerTag/CustomerTagForm.tsx
src/components/container/form/customerTag/customerTagSchema.ts
src/components/container/form/customerTagMerge/CustomerTagMergeForm.tsx
src/components/container/form/customerTagMerge/customerTagMergeSchema.ts
src/components/container/form/filter/FilterValueForm.tsx
src/components/container/form/filter/filterSchema.ts
src/components/container/form/product/productSchema.ts
src/components/container/form/product/relation/ProductCoreForm.tsx
src/components/container/form/productTag/ProductTagForm.tsx
src/components/container/form/tagMerge/TagMergeForm.tsx

Form Widgets
src/components/container/form/widgets/FormMasterTextField.tsx
src/components/container/form/widgets/FormValueMasterTextField.tsx
src/components/container/form/widgets/MasterNameSelect.tsx
src/components/container/form/widgets/MasterSelect.tsx

Layout
src/components/container/layout/AppNavigation.tsx

Modal（Customer / CustomerTag）
src/components/container/modal/customer/customerCompany/table/CustomerCompanyListRow.tsx
src/components/container/modal/customer/customerCompany/table/CustomerCompanySearchConditionField.tsx
src/components/container/modal/customer/customerTag/merge/CustomerTagMergeModal.tsx
src/components/container/modal/customer/customerTag/merge/CustomerTagMergeModalProvider.tsx
src/components/container/modal/customer/customerTag/table/CustomerTagListRow.tsx
src/components/container/modal/customer/customerTag/table/CustomerTagListTable.tsx
src/components/container/modal/customer/customerTag/table/CustomerTagSearchConditionField.tsx

Modal Widgets
src/components/container/modal/widgets/FormValueMasterSelectList.tsx
src/components/container/modal/widgets/FormValueMasterSelectModal.tsx
src/components/container/modal/widgets/FormValueMasterSelectModalProvider.tsx

Modules / Pages
src/components/container/modules/customer/table/CustomerListRow.tsx
src/components/container/modules/customer/table/CustomerSearchConditionField.tsx
src/components/container/modules/tag/PrivateTagSelect.tsx
src/components/container/page/customer/CustomerEditPage.tsx // FormValueMasterSelectModalProviderの追加が必要.
src/components/container/page/customer/company/CustomerCompanyEditPage.tsx // FormValueMasterSelectModalProviderの追加が必要.
src/components/container/page/customer/tag/CustomerTagEditPage.tsx
src/components/container/page/customer/tag/CustomerTagListPage.tsx

Models
src/common/model/content/operationMemo.ts // CUSTOMER_TAG_LIST, CUSTOMER_TAG_EDITを追加
src/common/model/listShown.ts
src/common/model/master.ts
src/common/model/user/customer.ts

Story / Mock
src/stories/mock/user/customerMock.ts

# 参考情報(入出荷管理タグ)

関連ファイルは、文字列"arrivalShippingTag"で検索してください。

## ユビキタス(入出荷管理タグ)

入出荷管理タグ：ArrivalShippingTag
入出荷管理タグ＞タグ種別＞入荷：arrivalArrivalShippingTag(ArrivalShippingTag.arrivalEnabled)
入出荷管理タグ＞タグ種別＞出荷：shippingArrivalShippingTag(ArrivalShippingTag.shippingEnabled)
入荷：Arrival
出荷：Shipping

## パス(入出荷管理タグ)

入出荷管理タグ一覧：regolith-admin/src/app/(authentificated)/(standard)/arrival-shipping/tag/list
入出荷管理タグ詳細：regolith-admin/src/app/(authentificated)/(standard)/arrival-shipping/tag/new
入出荷管理タグ新規：regolith-admin/src/app/(authentificated)/(standard)/arrival-shipping/tag/edit/[code]

入荷一覧：regolith-admin/src/app/(authentificated)/(standard)/arrival/(arrival)/list/page.tsx
入荷詳細：regolith-admin/src/app/(authentificated)/(standard)/arrival/(arrival)/edit/[serial]/page.tsx
入荷新規：regolith-admin/src/app/(authentificated)/(standard)/arrival/(arrival)/new/page.tsx

出荷一覧：regolith-admin/src/app/(authentificated)/(standard)/shipping/(shipping)/list/page.tsx
出荷詳細：regolith-admin/src/app/(authentificated)/(standard)/shipping/(shipping)/edit/[serial]/page.tsx
出荷新規：regolith-admin/src/app/(authentificated)/(standard)/shipping/(shipping)/new/page.tsx

## 機能概要(入出荷管理タグ)

入荷と出荷にタグ付けして管理できる、入出荷管理タグ機能を提供する。
入出荷管理タグは、タグ種別（入荷:arrivalEnabled、出荷:shippingEnabled）を持つ。
入出荷管理タグは、リレーション（入荷:arrivalArrivalShippingTag、出荷:shippingArrivalShippingTag）を持つ。

## DB定義(Prisma schema)(入出荷管理タグ)

```prisma
// 入荷
model Arrival {
  arrivalArrivalShippingTags ArrivalArrivalShippingTag[]
}
// 出荷
model Shipping {
  shippingArrivalShippingTags ShippingArrivalShippingTag[]
}
// 入出荷管理タグ
model ArrivalShippingTag {
  id               String @id @default(cuid()) @db.VarChar(30)
  name             String @unique @db.VarChar(255)
  code             String @unique @db.VarChar(255)
  description      String @db.Text @default("")
  arrivalEnabled  Boolean @default(false)
  shippingEnabled Boolean @default(false)

  arrivalArrivalShippingTags ArrivalArrivalShippingTag[]
  shippingArrivalShippingTags ShippingArrivalShippingTag[]

  createdAt        DateTime @default(now())
  updatedAt        DateTime @updatedAt
}
// 入荷-入出荷管理タグ中間テーブル
model ArrivalArrivalShippingTag {
  arrival         Arrival @relation(fields: [arrivalId], references: [id], onDelete: Cascade)
  arrivalId       String @db.VarChar(30)
  arrivalShippingTag      ArrivalShippingTag @relation(fields: [arrivalShippingTagId], references: [id], onDelete: Cascade)
  arrivalShippingTagId    String @db.VarChar(30)

  @@id([arrivalId, arrivalShippingTagId])
}
// 出荷-入出荷管理タグ中間テーブル
model ShippingArrivalShippingTag {
  shipping         Shipping @relation(fields: [shippingId], references: [id], onDelete: Cascade)
  shippingId       String @db.VarChar(30)
  arrivalShippingTag      ArrivalShippingTag @relation(fields: [arrivalShippingTagId], references: [id], onDelete: Cascade)
  arrivalShippingTagId    String @db.VarChar(30)

  @@id([shippingId, arrivalShippingTagId])
}
```

## ファイル一覧(入出荷管理タグ)(抜け漏れがあるかもしれません)

### API側(NestJS)(入出荷管理タグ)(抜け漏れがあるかもしれません)

追加 prisma/migrations/20260116084850_create_arrival_shipping_tag_and_arrival_arrival_shipping_tag_and_shipping_arrival_shipping_tag/migration.sql
修正 prisma/schema.prisma
修正 src/admin.gql
修正 src/front.gql
修正 src/modules/order/arrivals/arrivals.service.ts
修正 src/modules/order/arrivals/arrivals.type.ts
修正 src/modules/order/arrivals/dto/arrival-pagination.args.ts
修正 src/modules/order/arrivals/dto/create-arrival.dto.ts
修正 src/modules/order/arrivals/model/arrivals.model.ts
追加 src/modules/order/shippings/arrival-shipping-tags.admin.resolver.ts
追加 src/modules/order/shippings/arrival-shipping-tags.service.ts
追加 src/modules/order/shippings/arrival-shipping-tags.type.ts
追加 src/modules/order/shippings/dto/arrival-shipping-tag-pagination.args.ts
追加 src/modules/order/shippings/dto/create-arrival-shipping-tags.dto.ts
修正 src/modules/order/shippings/dto/create-shipping.dto.ts
修正 src/modules/order/shippings/dto/shipping-pagination.args.ts
追加 src/modules/order/shippings/model/arrival-shipping-tags.model.ts
修正 src/modules/order/shippings/model/shippings.model.ts
修正 src/modules/order/shippings/shippings.module.ts
修正 src/modules/order/shippings/shippings.service.ts
修正 src/modules/order/shippings/shippings.type.ts
修正 src/modules/util/code/code.params.ts

### フロントエンド側（Next.js）(入出荷管理タグ)(抜け漏れがあるかもしれません)

追加 src/app/(authentificated)/(standard)/arrival-shipping/tag/edit/[code]/page.tsx
追加 src/app/(authentificated)/(standard)/arrival-shipping/tag/list/page.tsx
追加 src/app/(authentificated)/(standard)/arrival-shipping/tag/new/page.tsx
修正 src/common/api/modules/arrival.ts
追加 src/common/api/modules/arrivalShippingTag.ts
修正 src/common/api/modules/customer.ts
修正 src/common/api/modules/master.ts
修正 src/common/api/modules/shipping.ts
追加 src/common/app/modules/arrivalShippingTag.ts
修正 src/common/app/path.ts
修正 src/common/gql/arrival.ts
追加 src/common/gql/arrivalShippingTag.ts
修正 src/common/gql/shipping.ts
修正 src/common/model/content/operationMemo.ts
修正 src/common/model/order/arrival.ts
追加 src/common/model/order/arrivalShippingTag.ts
修正 src/common/model/order/shipping.ts
修正 src/components/container/form/arrival/ArrivalForm.tsx
修正 src/components/container/form/arrival/arrivalSchema.ts
修正 src/components/container/form/arrival/relation/ArrivalInfoForm.tsx
追加 src/components/container/form/arrivalShippingTag/ArrivalShippingTagForm.tsx
追加 src/components/container/form/arrivalShippingTag/arrivalShippingTagSchema.ts
追加 src/components/container/form/arrivalShippingTagMerge/ArrivalShippingTagMergeForm.tsx
追加 src/components/container/form/arrivalShippingTagMerge/arrivalShippingTagMergeSchema.ts
修正 src/components/container/form/customerTag/CustomerTagForm.tsx
修正 src/components/container/form/receiveOrder/receiveOrderSchema.ts
修正 src/components/container/form/shipping/ShippingForm.tsx
修正 src/components/container/form/shipping/relation/ShippingInfoForm.tsx
修正 src/components/container/form/shipping/shippingSchema.ts
修正 src/components/container/layout/AppNavigation.tsx
追加 src/components/container/modal/arrival/arrivalShippingTag/merge/ArrivalShippingTagMergeModal.tsx
追加 src/components/container/modal/arrival/arrivalShippingTag/merge/ArrivalShippingTagMergeModalProvider.tsx
追加 src/components/container/modal/arrival/arrivalShippingTag/table/ArrivalShippingTagListRow.tsx
追加 src/components/container/modal/arrival/arrivalShippingTag/table/ArrivalShippingTagListTable.tsx
追加 src/components/container/modal/arrival/arrivalShippingTag/table/ArrivalShippingTagSearchConditionField.tsx
修正 src/components/container/modal/customer/customerCompany/table/CustomerCompanySearchConditionField.tsx
修正 src/components/container/modules/arrival/table/ArrivalListRow.tsx
修正 src/components/container/modules/arrival/table/ArrivalSearchConditionField.tsx
修正 src/components/container/modules/customer/table/CustomerSearchConditionField.tsx
修正 src/components/container/modules/shipping/table/ShippingListRow.tsx
修正 src/components/container/modules/shipping/table/ShippingSearchConditionField.tsx
修正 src/components/container/modules/tag/PrivateTagSelect.tsx
追加 src/components/container/page/arrival-shipping/tag/ArrivalShippingTagEditPage.tsx
追加 src/components/container/page/arrival-shipping/tag/ArrivalShippingTagListPage.tsx
修正 src/components/container/page/arrival/ArrivalEditPage.tsx
修正 src/components/container/page/shipping/ShippingEditPage.tsx
