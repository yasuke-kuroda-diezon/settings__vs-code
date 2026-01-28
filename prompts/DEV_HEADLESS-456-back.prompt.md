---
agent: agent
description: 商品CSV(Upload/Download)とカテゴリCSV(Upload/Download)の既存実装を参考に、会員CSV(Upload/Download)機能をNestJSのバックエンド側に新規構築する。
tools: ['vscode', 'execute', 'read', 'edit', 'search', 'web', 'agent', 'todo']
model: Gemini 3 Pro (Preview) (copilot)
---

# 概要
会員機能に対して「会員CSV登録」「会員CSV出力」機能を新規構築したい。
CustomersModule に対して機能構築を行う。

# タスク
商品CSV(upload: importProductCsv, download: exportProductCsv)とカテゴリCSV(upload: importCategoryCsv, download: exportCategoryCsv)の既存実装を参考に、会員CSV(upload: importCustomerCsv, download: exportCustomerCsv)機能をNestJSのバックエンド側に新規構築して下さい。
参考情報、参照ファイル及びモジュール内のコードを参照しながら、周辺コードを読み込んでください。

# 期待する成果物
実際のコードを確認しながら、必要に応じて追加・修正を行って下さい。(既に実装があるものの参照されてない場合や、コメントアウトされている場合もありますので注意して下さい。)
会員CSV登録：CustomersCsvImporter,CUSTOMER_CSV_IMPORT_HEADER
会員CSV出力：CustomersCsvExporter,CUSTOMER_CSV_EXPORT_HEADER
ヘッダ定義：customers-csv.param.ts
## 会員CSV機能のファイル構成
```
- src
  - modules
    - user
      - customers
        - customers-csv.importer.ts // (新規作成)
        - customers-csv.exporter.ts // (新規作成)
        - customers-csv.param.ts // (修正)｜ヘッダ定義追加
            - JobType.CUSTOMER_CSV_EXPORT // (新規追加)
            - JobType.CUSTOMER_CSV_IMPORT // (新規追加)
        - customers.admin.resolver.ts // (修正)｜エンドポイント追加（`exportCustomerCsv`、`importCustomerCsv`）
        - customers.module.ts // (修正)
    - job
      - csv-import-job-consumer-adapter.ts // (修正)｜会員CSV用のアダプタ登録
      - csv-export-job-consumer-adapter.ts // (修正)｜会員CSV用のアダプタ登録
      - job.param.ts // (修正)
          - JobType.CUSTOMER_CSV_IMPORT: 'CUSTOMER_CSV_IMPORT' // (新規追加)
          - JobType.CUSTOMER_CSV_EXPORT: 'CUSTOMER_CSV_EXPORT' // (新規追加)
      - job.service.ts // (修正)
      - job-mail.service.ts // (修正)
    - util
      - csv
        - csv-formats.model.ts // (修正)｜CsvFormatModel.CUSTOMER // (新規追加)
  - admin.gql // 修正不要です。NestJSのGraphQLモジュールが自動生成します。
  - front.gql // 修正不要です。NestJSのGraphQLモジュールが自動生成します。
```

# 参考情報
・CSV登録の共通の仕組みは、CSV登録時は同期的にチェックを行い、エラーなければジョブに登録します。ジョブコンシューマーがタスクを非同期で実行し、非同期のバリデーションがなければデータを取り込みます。
・CSV出力の共通の仕組みは、CSV出力時はジョブに登録します。ジョブコンシューマーがタスクを非同期で実行し、ジョブ実行結果としてCSVデータをダウンロードできるようになります。

## カテゴリ
カテゴリCSV登録：CategoriesCsvImporter,CATEGORY_CSV_IMPORT_HEADER
カテゴリCSV出力：CategoriesCsvExporter,CATEGORY_CSV_EXPORT_HEADER
ヘッダ定義：categories-csv.param.ts
###　カテゴリCSV機能のファイル構成
```
- src
  - modules
    - content
      - tags
        - categories-csv.importer.ts
        - categories-csv.exporter.ts
        - categories-csv.param.ts
            - CATEGORY_CSV_IMPORT_HEADER
            - CATEGORY_CSV_EXPORT_HEADER
        - tags.admin.resolver.ts // エンドポイント: `exportCategoryCsv`、`importCategoryCsv`
        - tags.module.ts
    - job
      - csv-import-job-consumer-adapter.ts // CategoriesCsvImporter登録
      - csv-export-job-consumer-adapter.ts // CategoriesCsvExporter登録
      - job.param.ts
          - JobType.CATEGORY_CSV_IMPORT: 'CATEGORY_CSV_IMPORT'
          - JobType.CATEGORY_CSV_EXPORT: 'CATEGORY_CSV_EXPORT'
          - JOB_QUEUES: 対応するQueueType設定
      - job.service.ts
      - job-mail.service.ts
    - util
      - csv
        - csv-formats.model.ts
            - CsvFormatModel.CATEGORY: 'CATEGORY'
```

## 商品
ヘッダ定義：products-csv.param.ts
商品CSV登録：ProductsCsvImporter,PRODUCT_CSV_IMPORT_HEADER
商品CSV出力：ProductsCsvExporter,PRODUCT_CSV_EXPORT_HEADER
###　商品CSV機能のファイル構成
```
- src
  - modules
    - content
      - products
        - products-csv.importer.ts
        - products-csv.exporter.ts
        - products-csv.param.ts
            - PRODUCT_CSV_IMPORT_HEADER
            - PRODUCT_CSV_EXPORT_HEADER
        - products.admin.resolver.ts // エンドポイント: `exportProductCsv`、`importProductCsv`
        - products.module.ts
    - job
      - csv-import-job-consumer-adapter.ts // ProductsCsvImporter登録
      - csv-export-job-consumer-adapter.ts // ProductsCsvExporter登録
      - job.param.ts
          - JobType.PRODUCT_CSV_IMPORT: 'PRODUCT_CSV_IMPORT'
          - JobType.PRODUCT_CSV_EXPORT: 'PRODUCT_CSV_EXPORT'
          - JOB_QUEUES: 対応するQueueType設定
      - job.service.ts
      - job-mail.service.ts
    - util
      - csv
        - csv-formats.model.ts
            - CsvFormatModel.PRODUCT: 'PRODUCT'
```

## ジョブ
CSV出力ジョブ実行アダプタ：CsvExportJobConsumerAdapter
CSV登録ジョブ実行アダプタ：CsvImportJobConsumerAdapter

## 会員
// 例：会員データを取得するコード例
const customers = await this.dbClient.prisma.customer.findMany({
  where: {},
})