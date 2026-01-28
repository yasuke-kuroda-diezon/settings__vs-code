---
agent: agent
description: 商品一覧画面の既存実装を参考に、対象の一覧画面に「登録日時」と「更新日時」項目を追加する。
tools: ["vscode", "execute", "read", "edit", "search", "web", "agent", "todo"]
model: Gemini 3 Pro (Preview) (copilot)
---

# タスク

商品一覧画面の既存実装を参考に、対象の一覧画面に「登録日時」と「更新日時」項目を追加してください。
APIは既に対応済みです。Next.jsのフロントエンド側の実装を行います。
対象の一覧画面：シナリオ一覧画面
・一覧画面コンポーネント：ScenarioListPage
・ListShownModel：作成しない

# 仕様

- 一覧画面の検索条件の項目は、「登録日時」と「更新日時」が存在する状態にする。
- 一覧画面の検索条件の項目名が「作成日」「登録日」「登録日時」「更新日時」などあるが、全て「登録日時」「更新日時」に統一する。
- 一覧画面の検索条件の項目に「登録日時」「更新日時」の項目がなければ追加する。文言が異なる場合は修正する。
- 一覧画面の検索条件の項目「登録日時」「更新日時」は、日付範囲選択コンポーネントとする。検索フィールドは年/月/日を選択可能とする（時間は指定不可）。
- 一覧テーブルのヘッダーの項目名は「登録日時」「更新日時」とする。
- 一覧テーブルのヘッダーの項目「登録日時」「更新日時」は並び替え可能とする。ListHeaderSortButtonを利用する。
- 一覧テーブルの行コンポーネントに「登録日時」「更新日時」の表示を追加する。フォーマットはYYYY/MM/DD HH:mm:ssとする。
- 商品一覧画面は既に期待する実装がされている。以下に参考情報を一部記載する。ファイルを参照しながら不足している情報をキャッチアップし、対象の一覧画面に同様の実装を行う。

# 参考情報(商品一覧画面の実装例)

商品一覧画面コンポーネント：ProductListPage

## データ取得(APIモジュール)側の実装例

/Users/yasuke_kuroda/work/headless/regolith-docker/regolith-admin-ctr/regolith-admin/src/common/api/modules/product.ts

### 検索条件「登録日時」「更新日時」の検索条件定義

検索条件定義カスタムフック：useProductSearchCondition

```
export const ProductOrderBy = {
  // 省略
  CREATED_AT_ASC: 'created-at-asc',
  CREATED_AT_DESC: 'created-at-desc',
  UPDATED_AT_ASC: 'updated-at-asc',
  UPDATED_AT_DESC: 'updated-at-desc'
} as const

export type ProductOrderBy = (typeof ProductOrderBy)[keyof typeof ProductOrderBy]

export interface ProductSearchCondition extends SearchConditionBase {
  // 省略
  createdAtFrom: string | null
  createdAtTo: string | null
  updatedAtFrom: string | null
  updatedAtTo: string | null
  orderBy: ProductOrderBy | null
}

const productSearchConditionParam: SearchConditionParam[] = [
  // 省略
  {
    name: 'createdAtFrom',
    type: 'string'
  },
  {
    name: 'createdAtTo',
    type: 'string'
  },
  {
    name: 'updatedAtFrom',
    type: 'string'
  },
  {
    name: 'updatedAtTo',
    type: 'string'
  },
  {
    name: 'orderBy',
    type: 'string'
  }
]
```

### 検索条件のユーザー入力値からGraphQLクエリへの変換関数

```
export const convertConditionToFindProductSearchListVars = (
  condition: ProductSearchCondition
): FindProductSearchListVars => {
  // 省略
  return {
    page: condition.page,
    perPage: condition.perPage,
    where: {
      // 省略
      ...((condition.createdAtFrom || condition.createdAtTo) && {
        createdAt: {
          ...(condition.createdAtFrom && {
            gte: dateToRequest(condition.createdAtFrom)
          }),
          ...(condition.createdAtTo && {
            lte: dateToRequest(condition.createdAtTo, { lte: true })
          })
        }
      }),
      ...((condition.updatedAtFrom || condition.updatedAtTo) && {
        updatedAt: {
          ...(condition.updatedAtFrom && {
            gte: dateToRequest(condition.updatedAtFrom)
          }),
          ...(condition.updatedAtTo && {
            lte: dateToRequest(condition.updatedAtTo, { lte: true })
          })
        }
      })
    },
    orderBy: {
      ...(condition.orderBy == ProductOrderBy.CREATED_AT_ASC && {
        createdAt: SortOrder.ASC
      }),
      ...(condition.orderBy == ProductOrderBy.CREATED_AT_DESC && {
        createdAt: SortOrder.DESC
      }),
      ...(condition.orderBy == ProductOrderBy.UPDATED_AT_ASC && {
        updatedAt: SortOrder.ASC
      }),
      ...(condition.orderBy == ProductOrderBy.UPDATED_AT_DESC && {
        updatedAt: SortOrder.DESC
      })
    }
  }
}
```

### 検索APIカスタムフック

検索APIカスタムフック：useProductSearchApi

```
export const useProductSearchApi = (condition: ProductSearchCondition) => {
  return useSWR<FindProductSearchListResponse, Response, [string, FindProductSearchListVars]>(
    [SEARCH_PRODUCTS, convertConditionToFindProductSearchListVars(condition)],
    apiDefaultFetcher,
    { revalidateOnMount: true, revalidateIfStale: true }
  )
}

/Users/yasuke_kuroda/work/headless/regolith-docker/regolith-admin-ctr/regolith-admin/src/common/gql/product.ts
export const SEARCH_PRODUCTS = gql`
  query SearchProducts(
    $page: Int
    $perPage: Int
    $where: ProductSearchWhereInput
    $orderBy: ProductSearchOrderByInput
    $include: ProductInclude
  ) {
    count
    pageCount
    items {
      createdAt // 追加箇所
      updatedAt // 追加箇所
    }
  }
`
```

### 検索条件のクリア処理の定数定義

```
export const PRODUCT_SEARCH_CONDITION_CLEAR: ProductSearchCondition = {
  // 省略
  createdAtFrom: null,
  createdAtTo: null,
  updatedAtFrom: null,
  updatedAtTo: null,
  orderBy: null
}
```

## フロントエンド側の実装例

### 一覧表示項目定義モデル

/Users/yasuke_kuroda/work/headless/regolith-docker/regolith-admin-ctr/regolith-admin/src/common/model/listShown.ts

```
export const ListShownModel = {
  PRODUCT: 'PRODUCT', // 商品一覧
  RECEIVE_ORDER: 'RECEIVE_ORDER', // 受注一覧
  ORDER_RETURN: 'ORDER_RETURN', // 返品・交換一覧
  CUSTOMER: 'CUSTOMER', // 会員一覧
  CUSTOMER_SEGMENT: 'CUSTOMER_SEGMENT', // 会員リスト一覧
  SHIPPING: 'SHIPPING', // 出荷一覧
  ARRIVAL: 'ARRIVAL', // 入荷一覧
  CONTACT: 'CONTACT', // コンタクト一覧
  CAMPAIGN: 'CAMPAIGN', // キャンペーン一覧
  STOCK_ORDER: 'STOCK_ORDER', // 発注一覧
  // シナリオは追加しなくて良いです。
} as const

export type ListShownModel = (typeof ListShownModel)[keyof typeof ListShownModel]
```

### 検索条件「登録日時」「更新日時」の定数定義

/Users/yasuke_kuroda/work/headless/regolith-docker/regolith-admin-ctr/regolith-admin/src/common/model/listShown.ts

```
export const ListShownProductItem = {
  CREATED_AT: 'createdAt', // 追加箇所
  UPDATED_AT: 'updatedAt', // 追加箇所
} as const

export type ListShownProductItem = (typeof ListShownProductItem)[keyof typeof ListShownProductItem]
```

### 一覧テーブルのヘッダー定義

```
/Users/yasuke_kuroda/work/headless/regolith-docker/regolith-admin-ctr/regolith-admin/src/common/model/listShown.ts
export const convertProductListShownItemToName = (item: ListShownProductItem): string => {
  switch (item) {
    case ListShownProductItem.CREATED_AT:
      return '登録日時'
    case ListShownProductItem.UPDATED_AT:
      return '更新日時'
  }
}
```

### 検索条件コンポーネントの実装例(年/月/日を選択可能とする（時間は指定不可）。)

/Users/yasuke_kuroda/work/headless/regolith-docker/regolith-admin-ctr/regolith-admin/src/components/container/modules/product/ProductSearchConditionField.tsx

```
<SortButtonList>
  {items.map((item) => (
    <Fragment key={item}>
      {item == ListShownProductItem.CREATED_AT && (
        <CreatedAtSelect condition={condition} setCondition={setCondition} /> // 追加箇所
      )}
      {item == ListShownProductItem.UPDATED_AT && (
        <UpdatedAtSelect condition={condition} setCondition={setCondition} /> // 追加箇所
      )}
    </Fragment>
  ))}
</SortButtonList>

const CreatedAtSelect = ({ condition, setCondition }: ItemProps) => {
  return (
    <DisclosureSortDateBetweenButton
      onComplete={(startAt, endAt) => {
        setCondition((condition) => ({
          ...condition,
          createdAtFrom: startAt ?? null,
          createdAtTo: endAt ?? null
        }))
      }}
      quantity={[condition.createdAtFrom, condition.createdAtTo].filter((date) => !!date).length}
      defaultStartValue={condition.createdAtFrom}
      defaultEndValue={condition.createdAtTo}
    >
      登録日時
    </DisclosureSortDateBetweenButton>
  )
}

const UpdatedAtSelect = ({ condition, setCondition }: ItemProps) => {
  return (
    <DisclosureSortDateBetweenButton
      onComplete={(startAt, endAt) => {
        setCondition((condition) => ({
          ...condition,
          updatedAtFrom: startAt ?? null,
          updatedAtTo: endAt ?? null
        }))
      }}
      quantity={[condition.updatedAtFrom, condition.updatedAtTo].filter((date) => !!date).length}
      defaultStartValue={condition.updatedAtFrom}
      defaultEndValue={condition.updatedAtTo}
    >
      更新日時
    </DisclosureSortDateBetweenButton>
  )
}
```

### 一覧テーブルのヘッダー実装。(ヘッダーの並び替え可能。)

```
/Users/yasuke_kuroda/work/headless/regolith-docker/regolith-admin-ctr/regolith-admin/src/components/container/modules/product/ProductListTable.tsx
const HeadItem = ({
  item,
  orderBy,
  onChangeOrderBy
}: {
  item: ListShownProductItem
  orderBy: ProductOrderBy | null
  onChangeOrderBy(orderBy: ProductOrderBy | null): void
}) => {
  switch (item) {
    case ListShownProductItem.CREATED_AT:
      return (
        <ListHeaderSortButton
          order={
            orderBy == ProductOrderBy.CREATED_AT_ASC
              ? 'asc'
              : orderBy == ProductOrderBy.CREATED_AT_DESC
              ? 'desc'
              : undefined
          }
          onChange={(order) =>
            onChangeOrderBy(
              order == 'desc' ? ProductOrderBy.CREATED_AT_DESC : ProductOrderBy.CREATED_AT_ASC
            )
          }
          text='登録日時'
        />
      )
    case ListShownProductItem.UPDATED_AT:
      return (
        <ListHeaderSortButton
          order={
            orderBy == ProductOrderBy.UPDATED_AT_ASC
              ? 'asc'
              : orderBy == ProductOrderBy.UPDATED_AT_DESC
              ? 'desc'
              : undefined
          }
          onChange={(order) =>
            onChangeOrderBy(
              order == 'desc' ? ProductOrderBy.UPDATED_AT_DESC : ProductOrderBy.UPDATED_AT_ASC
            )
          }
          text='更新日時'
        />
      )
    default:
  }
  return (
    <Text color={TextColor.SECONDARY}>
      {convertToListShownItemToName(ListShownModel.PRODUCT, item)}
    </Text>
  )
}
```

### 一覧テーブルの行コンポーネントの実装例(「登録日時」)

/Users/yasuke_kuroda/work/headless/regolith-docker/regolith-admin-ctr/regolith-admin/src/components/container/modules/product/ProductListRow.tsx

```
case ListShownProductItem.CREATED_AT:
  return (
    <TableRowItem width={88}> // widthは88に統一する。
      <Text size={13}>{dateTimeStr(product.createdAt)}</Text> // dateTimeStrを利用する。
    </TableRowItem>
  )
```
