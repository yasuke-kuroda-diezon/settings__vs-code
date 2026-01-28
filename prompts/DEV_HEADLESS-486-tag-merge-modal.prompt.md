---
agent: agent
description: タグを統合する機能に関して、TagMergeModalとTagMergeModalProviderに統一する。Query, Mutationや表示文字のみ切り替える。
tools: ["vscode", "execute", "read", "edit", "search", "web", "agent", "todo"]
model: Claude Opus 4.5 (copilot)
---

# 概要

・(商品)タグ(Tag)
・顧客管理タグ(CustomerTag)
・入出荷管理タグ(ArrivalShippingTag)
・コンタクト管理タグ(ContactTag)
・受注管理タグ(ReceiveOrderTag)

のタグを統合する機能は文言のみが異なり機能自体は同一である。
TagMergeModalとTagMergeModalProviderに統一する。Query, Mutationや表示文字のみ切り替えるようにする。

# タスク

src配下の既存コードを全て読み込み、既存の構成を理解してください。

また以下のファイル群を詳細に読み込み、既存の構成を理解してください。
・src/components/container/modal/arrival/arrivalShippingTag/merge/ArrivalShippingTagMergeModal.tsx
・src/components/container/modal/arrival/arrivalShippingTag/merge/ArrivalShippingTagMergeModalProvider.tsx
・src/components/container/modal/contact/contactTag/merge/ContactTagMergeModal.tsx
・src/components/container/modal/contact/contactTag/merge/ContactTagMergeModalProvider.tsx
・src/components/container/modal/customer/customerTag/merge/CustomerTagMergeModal.tsx
・src/components/container/modal/customer/customerTag/merge/CustomerTagMergeModalProvider.tsx
・src/components/container/modal/product/tag/merge/TagMergeModal.tsx
・src/components/container/modal/product/tag/merge/TagMergeModalProvider.tsx
・src/components/container/modal/receiveOrder/receiveOrderTag/merge/ReceiveOrderTagMergeModal.tsx
・src/components/container/modal/receiveOrder/receiveOrderTag/merge/ReceiveOrderTagMergeModalProvider.tsx

既存コードを参考に、TagMergeModalとTagMergeModalProviderに統一してください。
期待される成果物は以下の2ファイルです。
・src/components/container/modal/tag/merge/TagMergeModal.tsx
・src/components/container/modal/tag/merge/TagMergeModalProvider.tsx

TagTypeを定義しました。
TagType.ARRIVAL_SHIPPINGのような形でタグの種類を指定してください。
既存の(商品)タグ、顧客管理タグ、入出荷管理タグ、コンタクト管理タグ、受注管理タグのタグ統合機能の実装箇所を、共通化したTagMergeModalとTagMergeModalProviderを使用するように修正してください。

以下のファイルは削除してください。
・src/components/container/modal/arrival/arrivalShippingTag/merge/ArrivalShippingTagMergeModal.tsx
・src/components/container/modal/arrival/arrivalShippingTag/merge/ArrivalShippingTagMergeModalProvider.tsx
・src/components/container/modal/contact/contactTag/merge/ContactTagMergeModal.tsx
・src/components/container/modal/contact/contactTag/merge/ContactTagMergeModalProvider.tsx
・src/components/container/modal/customer/customerTag/merge/CustomerTagMergeModal.tsx
・src/components/container/modal/customer/customerTag/merge/CustomerTagMergeModalProvider.tsx
・src/components/container/modal/product/tag/merge/TagMergeModal.tsx
・src/components/container/modal/product/tag/merge/TagMergeModalProvider.tsx
・src/components/container/modal/receiveOrder/receiveOrderTag/merge/ReceiveOrderTagMergeModal.tsx
・src/components/container/modal/receiveOrder/receiveOrderTag/merge/ReceiveOrderTagMergeModalProvider.tsx
