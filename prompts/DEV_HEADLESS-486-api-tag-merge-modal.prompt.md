---
agent: agent
description: API側のタグを統合する機能に関して、Mutation定義とDto定義を統一する。
tools: ["vscode", "execute", "read", "edit", "search", "web", "agent", "todo"]
model: Claude Opus 4.5 (copilot)
---

type Mutation {
mergeTag(id: ID!, toTagIds: [ID!]!): Result!
mergeCustomerTag(id: ID!, toCustomerTagIds: [ID!]!): Result!
mergeContactTag(id: ID!, toContactTagId: ID!): Result!
mergeReceiveOrderTag(id: ID!, toReceiveOrderTagId: ID!): Result!
mergeArrivalShippingTag(id: ID!, toArrivalShippingTagId: ID!): Result!
}

について、期待するMutation定義は以下になります。
type Mutation {
mergeTag(id: ID!, toTagId: ID!): Result!
mergeCustomerTag(id: ID!, toTagId: ID!): Result!
mergeContactTag(id: ID!, toTagId: ID!): Result!
mergeReceiveOrderTag(id: ID!, toTagId: ID!): Result!
mergeArrivalShippingTag(id: ID!, toTagId: ID!): Result!
}

・統合先は単数指定で統一します。
・統合先はtoTagIdで統一します。

期待するDto定義は以下になります。
@ArgsType()
export class MergeArrivalShippingTagDto {
@Field(() => ID)
@IsString()
id: string
@Field(() => ID) // 配列ではなくID指定になります。
@IsString() // @IsStringを付与します。
toTagId: string // "toTagId"という名前でstringとします。
}

toTagIds
toCustomerTagIds
toContactTagId
toReceiveOrderTagId
toArrivalShippingTagId

をtoTagIdに置換し、API定義を改修してください。

admin.gqlは自動生成されるファイルなので、admin.gqlを直接編集する必要はないことに注意してください。

MergeTag
MergeCustomerTag
MergeContactTag
MergeReceiveOrderTag
MergeArrivalShippingTag
