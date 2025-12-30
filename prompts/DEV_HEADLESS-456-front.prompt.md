---
agent: agent
description: 商品CSV(Upload/Download)とカテゴリCSV(Upload/Download)の既存実装を参考に、会員CSV(Upload/Download)機能をNext.jsのフロントエンド側に新規構築する。
tools: ['vscode', 'execute', 'read', 'edit', 'search', 'web', 'agent', 'todo']
model: Gemini 3 Pro (Preview) (copilot)
---

# 概要
会員機能に対して「会員CSV登録」「会員CSV出力」機能を新規構築したい。

# タスク
商品CSV(upload: importProductCsv, download: exportProductCsv)とカテゴリCSV(upload: importCategoryCsv, download: exportCategoryCsv)の既存実装を参考に、会員CSV(upload: importCustomerCsv, download: exportCustomerCsv)機能をNext.jsのフロントエンド側に新規構築してください。
参考情報、参照ファイル及びモジュール内のコードを参照しながら、周辺コードを読み込んでください。
なお、NestJSのAPI側は既に実装済みです。API側の実装内容も読み込んでください。

# 期待する成果物
実際のコードを確認しながら、必要に応じて追加・修正を行って下さい。(既に実装があるものの参照されてない場合や、コメントアウトされている場合もありますので注意して下さい。)
## 会員CSV機能のファイル構成
```
- src
  - app
    - (authentificated)
      - (standard)
        - customer
          - list
            - page.tsx # CustomerCsvUploadModalProviderとCsvDownloadModalProviderをラップ
  - common
    - api
      - modules
        - customer.ts # 会員検索API (useCustomerSearchApi)
        - csvFormat.ts # CSVフォーマット一覧API (useFindCsvFormatListApi) ※既存
    - app
      - modules
        - csvUpload.ts # CSV Upload用カスタムフック (useCsvUploadApiForm) ※既存
        - csvFormat.ts # CSVフォーマット表示名変換 (csvFormatModelName) ※既存
    - form
      - csv.ts # CSVアップロードフォームスキーマ ※既存
    - gql
      - customer.ts # GraphQL定義に追加 (IMPORT_CUSTOMER_CSV, EXPORT_CUSTOMER_CSV)
    - model
      - csvFormat.ts # CsvFormatModel列挙型に CUSTOMER 追加 ※既存
      - content
        - customer.ts # Customer型定義 ※既存
  - components
    - container
      - form
        - customerCsv
          - CustomerCsvForm.tsx # 会員CSVアップロードフォーム ※新規作成
        - csvDownload
          - CsvDownloadForm.tsx # CSV出力フォーム（共通）※既存、CUSTOMER対応追加
        - widgets
          - csv
            - CsvUploadArea.tsx # CSVファイルアップロードエリア（共通）※既存
            - CsvUploadFormContent.tsx # CSVアップロードフォームコンテンツ（共通）※既存
            - CsvUploadImageZip.tsx # 画像ZIPアップロード（共通）※既存 ※会員では不要の可能性
      - modal
        - customer
          - csv
            - CustomerCsvUploadModal.tsx # 会員CSVアップロードモーダル ※新規作成
            - CustomerCsvUploadModalProvider.tsx # 会員CSVモーダルプロバイダー ※新規作成
        - csvDownload
          - CsvDownloadModalProvider.tsx # CSV出力モーダルプロバイダー（共通）※既存
      - modules
        - csvUpload
          - CsvUploadResult.tsx # CSVアップロード結果表示（共通）※既存
        - csvFormat
          - CsvUploadFormatDownload.tsx # CSVフォーマットダウンロード（共通）※既存
      - page
        - customer
          - CustomerListPage.tsx # 会員一覧ページ (showUploadModal, showDownloadModal呼び出し追加)
```

# 参考情報
##　カテゴリCSV機能のファイル構成
```
- src
  - app
    - (authentificated)
      - (standard)
        - product
          - category
            - list
              - page.tsx # CategoryCsvUploadModalProviderとCsvDownloadModalProviderをラップ
  - common
    - api
      - modules
        - category.ts # カテゴリ検索API (useCategorySearchApi)
        - csvFormat.ts # CSVフォーマット一覧API (useFindCsvFormatListApi)
    - app
      - modules
        - csvUpload.ts # CSV Upload用カスタムフック (useCsvUploadApiForm)
        - csvFormat.ts # CSVフォーマット表示名変換 (csvFormatModelName)
    - form
      - csv.ts # CSVアップロードフォームスキーマ
    - gql
      - category.ts # GraphQL定義 (IMPORT_CATEGORY_CSV, EXPORT_CATEGORY_CSV)
    - model
      - csvFormat.ts # CsvFormatModel列挙型
      - content
        - category.ts # Category型定義
  - components
    - container
      - form
        - categoryCsv
          - CategoryCsvForm.tsx # カテゴリCSVアップロードフォーム
        - csvDownload
          - CsvDownloadForm.tsx # CSV出力フォーム（共通）
        - widgets
          - csv
            - CsvUploadArea.tsx # CSVファイルアップロードエリア（共通）
            - CsvUploadFormContent.tsx # CSVアップロードフォームコンテンツ（共通）
            - CsvUploadImageZip.tsx # 画像ZIPアップロード（共通）
      - modal
        - category
          - csv
            - CategoryCsvUploadModal.tsx # カテゴリCSVアップロードモーダル
            - CategoryCsvUploadModalProvider.tsx # カテゴリCSVモーダルプロバイダー
        - csvDownload
          - CsvDownloadModalProvider.tsx # CSV出力モーダルプロバイダー（共通）
      - modules
        - csvUpload
          - CsvUploadResult.tsx # CSVアップロード結果表示（共通）
        - csvFormat
          - CsvUploadFormatDownload.tsx # CSVフォーマットダウンロード（共通）
      - page
        - product
          - category
            - CategoryListPage.tsx # カテゴリ一覧ページ (showUploadModal, showDownloadModal呼び出し)
```

##　商品CSV機能のファイル構成
```
- src
  - app
    - (authentificated)
      - (standard)
        - product
          - (product)
            - list
              - page.tsx # ProductCsvModalProviderとCsvDownloadModalProviderをラップ
  - common
    - api
      - modules
        - product.ts # 商品検索API (useProductSearchApi)
        - csvFormat.ts # CSVフォーマット一覧API (useFindCsvFormatListApi)
    - app
      - modules
        - csvUpload.ts # CSV Upload用カスタムフック (useCsvUploadApiForm)
        - csvFormat.ts # CSVフォーマット表示名変換 (csvFormatModelName)
    - form
      - csv.ts # CSVアップロードフォームスキーマ
    - gql
      - product.ts # GraphQL定義 (IMPORT_PRODUCT_CSV, EXPORT_PRODUCT_CSV)
    - model
      - csvFormat.ts # CsvFormatModel列挙型
      - content
        - product.ts # Product型定義
  - components
    - container
      - form
        - productCsv
          - ProductCsvForm.tsx # 商品CSVアップロードフォーム
        - csvDownload
          - CsvDownloadForm.tsx # CSV出力フォーム（共通）
        - widgets
          - csv
            - CsvUploadArea.tsx # CSVファイルアップロードエリア（共通）
            - CsvUploadFormContent.tsx # CSVアップロードフォームコンテンツ（共通）
            - CsvUploadImageZip.tsx # 画像ZIPアップロード（共通）
      - modal
        - product
          - csv
            - ProductCsvModal.tsx # 商品CSVアップロードモーダル
            - ProductCsvModalProvider.tsx # 商品CSVモーダルプロバイダー
        - csvDownload
          - CsvDownloadModalProvider.tsx # CSV出力モーダルプロバイダー（共通）
      - modules
        - csvUpload
          - CsvUploadResult.tsx # CSVアップロード結果表示（共通）
        - csvFormat
          - CsvUploadFormatDownload.tsx # CSVフォーマットダウンロード（共通）
      - page
        - product
          - ProductListPage.tsx # 商品一覧ページ (showUploadModal, showDownloadModal呼び出し)
```
