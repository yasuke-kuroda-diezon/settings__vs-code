---
agent: agent
description: 顧客管理タグ(CustomerTag)の既存実装を参考にして、管理画面に入出荷管理タグ(ArrivalShippingTag)を新規構築したい。
tools: ["vscode", "execute", "read", "edit", "search", "web", "agent", "todo"]
model: Gemini 3 Pro (Preview) (copilot)
---

# 概要

顧客管理タグ(CustomerTag)の既存実装を参考にして、管理画面に入出荷管理タグ(ArrivalShippingTag)を新規構築したい。
APIは構築済みです。フロントエンド部分(Next.js)の実装をお願いします。

# タスク

src配下の既存コードを全て読み込み、既存の構成を理解してください。
DB構成はPrismaスキーマを参照してください。
既存の顧客管理タグ(CustomerTag)の構成に合わせる形で、フロントエンド部分(Next.js)の入出荷管理タグ(ArrivalShippingTag)を実装してください。

・入出荷管理タグ一覧(新規構築)：regolith-admin/src/app/(authentificated)/(standard)/arrival-shipping/tag/list
・入出荷管理タグ詳細(新規構築)：regolith-admin/src/app/(authentificated)/(standard)/arrival-shipping/tag/new
・入出荷管理タグ新規(新規構築)：regolith-admin/src/app/(authentificated)/(standard)/arrival-shipping/tag/edit/[code]
・入荷一覧(実装追加対象です)：regolith-admin/src/app/(authentificated)/(standard)/arrival/(arrival)/list/page.tsx
・出荷一覧(実装追加対象です)：regolith-admin/src/app/(authentificated)/(standard)/shipping/(shipping)/list/page.tsx
・入荷詳細(実装追加対象です)：regolith-admin/src/app/(authentificated)/(standard)/arrival/(arrival)/edit/[serial]/page.tsx
・入荷新規(実装追加対象です)：regolith-admin/src/app/(authentificated)/(standard)/arrival/(arrival)/new/page.tsx
・出荷詳細(実装追加対象です)：regolith-admin/src/app/(authentificated)/(standard)/shipping/(shipping)/edit/[serial]/page.tsx
・出荷新規(実装追加対象です)：regolith-admin/src/app/(authentificated)/(standard)/shipping/(shipping)/new/page.tsx

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

## DB定義(Prisma schema)

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

## ファイル一覧(抜け漏れがあるかもしれません)

### API側(NestJS)

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

### フロントエンド側（Next.js）

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
