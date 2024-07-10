# 使用 indexer 

```tsx
interface LedgerInfoResponse {
	ledger_infos: {
	  chain_id: string
	}[]
}
const ntf_collection_info = aptos.queryIndexer<LedgerInfoResponse>({
  query: {
	query: `query GetLedgerInfo {
	ledger_infos {
	  chain_id
	}
  }`,
	variables: {}, // 如果查询不需要变量，这里可以是空对象
  },
})
.then((response) => {
  console.log('查询结果:', response.ledger_infos) // 打印查询结果
})
.catch((error) => {
  console.error('查询失败:', error) // 捕获并打印查询过程中的错误
})
```


https://aptos.dev/en/build/indexer/get-nft-collections