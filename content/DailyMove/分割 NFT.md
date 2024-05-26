---
title: 分割 NFT
---
```yaml
original: 
  author: Greg
  x_post: "https://x.com/Greg_Nazario/status/1755696024159735890"
  GitHub_url: "https://github.com/aptos-labs/daily-move/blob/main/snippets/fractional-token/sources/fractional_token.move"
note: 已校对
```
# 中文

另一位构建者问我：

“我如何分割一个 NFT ？”

[源代码](https://github.com/aptos-labs/daily-move/blob/main/snippets/fractional-token/sources/fractional_token.move)完全涵盖了如何将其分割，并且使用扩展示例，你实际上可以在此基础上添加更多！

早上好！人们一直在问我，你如何分割一个 NFT ？让我们在这一集的 #DailyMove 中深入探讨一种可能的数字资产分割方式。

首先，什么是分割资产?

分割资产是指将单个物品分割成部分所有权，即整体物品的一部分。

你可以把资产看作是一个拼图，你能够拥有整个拼图的一个单独的部分，或者多个部分，但你拥有的不是整个拼图。

让我们思考一下我们对可替代资产的要求：

- 可与其他系统互操作
- 表示实际资产（锁定）
- 允许拥有不同大小的部分

我们将使用可替代资产来进行分割。让我们来看一下数字资产的存储。

我们希望允许锁定数字资产，并且如果所有者持有 100％ 的资产部分，则可以解锁它。

我们在这里存储了数字资产以进行锁定。

`ExtendRef` 允许某人仅在拥有 100％ 时对资产进行分割，而 `BurnRef` 将允许在代币被认领时销毁这些被分割的部分。

如果我们发现我们缺少某些功能，可以使用 `ObjectGroup` 使我们在未来扩展这一点。

```rust
#[resource_group_member(group = aptos_framework::object::ObjectGroup)]
/// A locker for a digital asset and fractionalizes it accordingly
struct FractionalDigitalAsset has key {
	/// The address of the locked up token
	asset: Object<TokenObject>,
	/// For transferring the locked up token back out
	extend_ref: ExtendRef,
	/// For burning the tokens at the end
	burn_ref: BurnRef,
	/// For locking/unlocking the token from the object containing the token
	transfer_ref: TransferRef,
}
```

好的，现在让我们开始进行分割！

我们首先需要使用 `AptosTokenObjects` 库检索 `Token` 信息，然后我们可以构建分割资产的对象。

我们明确将其设置为粘性对象（sticky object），因为可替代资产要求元数据（metadata）不可删除。

这是因为我们希望确保资产可供其他系统使用，并且不会消失。

然后，我们继续从源数字资产构建一些有关可替代资产的信息。

```rust
/// Fractionalizes an asset.  We specifically keep it below u128 for simplicity
entry fun fractionalize_asset(caller: &signer, asset: Object<TokenObject>, supply: u64) {
	// Assert ownership before fractionalizing
	let caller_address = signer::address_of(caller);
	assert!(object::is_owner(asset, caller_address), E_NOT_OWNER);

	// Pull data from the original asset
	let asset_name = token::name(asset);
	let asset_uri = token::uri(asset);

	// Build the object to hold the fractionalized asset
	// This must be a named object (a non-deleteable object) to be fungible
	let constructor = object::create_named_object(caller, OBJECT_SEED);
	let extend_ref = object::generate_extend_ref(&constructor);
	let object_signer = object::generate_signer(&constructor);
	let object_address = object::address_from_constructor_ref(&constructor);

	// Create names based on the asset's name
	let name = string_utils::format1(&b"Fractionalized {}", asset_name);
	let asset_name_bytes = string::bytes(&asset_name);
	let symbol = string_utils::format1(&b"FRAC-{}", string::utf8(vector[*vector::borrow(asset_name_bytes, 0)]));
```

这里是有趣的部分！

我们可以简单地将可替代资产附加到对象上，以使其作为可替代资产的元数据使用。

在这一点上，我们保存 `burn_ref` 以供以后清理时使用，并实际锁定资产，同时铸造我们想要的股份数量。

请注意，`mint_ref` 在此函数结束时被丢弃。无法再铸造额外的权益。

此时，如果支持可交换资产，你可以直接使用你喜爱的钱包或 DeFi 工具与分割资产一起使用。

```rust
primary_fungible_store::create_primary_store_enabled_fungible_asset(
		&constructor,
		option::some((supply as u128)),
		name,
		symbol,
		0,
		asset_uri,
		string::utf8(b"") // Empty project URI, maybe put something else here
	);

	// Add mint and burn refs, to be able to burn the shares at the end.
	let mint_ref = fungible_asset::generate_mint_ref(&constructor);
	let burn_ref = fungible_asset::generate_burn_ref(&constructor);
	let transfer_ref = object::generate_transfer_ref(&constructor);
	object::disable_ungated_transfer(&transfer_ref);

	move_to(&object_signer, FractionalDigitalAsset {
		asset,
		extend_ref,
		burn_ref,
		transfer_ref,
	});

	// Lock asset up in the object
	object::transfer(caller, asset, object_address);

	// Mint fungible asset, and store at the owner
	primary_fungible_store::mint(&mint_ref, caller_address, supply);
}
```

但是，如果你只想要收回数字资产呢？

如果你有所有的权益（shares），你可以简单地重新组合所有权益（shares），并烧毁所有被分割的部分，将数字资产解锁，使其回到你的钱包。

```rust
/// A fractionalized asset can be removed, if and only if the owner controls all of the fungible assets
/// in the primary store
entry fun recombine_asset(caller: &signer, metadata_object: Object<Metadata>) acquires FractionalDigitalAsset {
	let caller_address = signer::address_of(caller);

	// Check that this is a fractionalized asset
	let metadata_object_address = object::object_address(&metadata_object);
	assert!(exists<FractionalDigitalAsset>(metadata_object_address), E_NOT_FRACTIONALIZED_DIGITAL_ASSET);

	// Check the balance to ensure you have the whole asset
	// We enforce that balance must be u64 and exist
	let caller_balance = primary_fungible_store::balance(caller_address, metadata_object);
	let total_supply = (option::destroy_some(fungible_asset::supply(metadata_object)) as u64);
	assert!(caller_balance == total_supply, E_NOT_COMPLETE_OWNER);

	let FractionalDigitalAsset {
		asset,
		extend_ref,
		burn_ref,
		transfer_ref,
	} = move_from<FractionalDigitalAsset>(metadata_object_address);

	let object_signer = &object::generate_signer_for_extending(&extend_ref);
	// Move the asset back to the owner
	object::enable_ungated_transfer(&transfer_ref);
	object::transfer(object_signer, asset, caller_address);

	// Burn the digital assets, then destroy as much as possible to recoop gas
	primary_fungible_store::burn(&burn_ref, caller_address, total_supply);

	// Note that the fungible asset metadata will stay around forever in the object, but no actual fungible assets
	// will exist.
}
```

接下来呢？

这里有大量的扩展可以处理：

- 将其制作成DAO，使NFT可以在抵押和其他地方使用
- 允许使用DAO铸造额外的股份
- 使可交换资产也成为数字资产，以便在钱包中显示为NFT
- 还有许多其他！

感谢大家阅读这一集的 [#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)

特别感谢[@AptosNoob](https://twitter.com/AptosNoob)提出这个问题！

祝顺利！

另外，这些片段的源代码：

[https://github.com/aptos-labs/daily-move/blob/main/snippets/fractional-token/sources/fractional_token.move](https://github.com/aptos-labs/daily-move/blob/main/snippets/fractional-token/sources/fractional_token.move)





---
# English

Another builder asked me:

"How do I fractionalize an NFT?"

The source code goes fully into how to fractionalize it, and using the extending example, you can actually add more on top!

gm ! People have been asking me, how do you fractionalize an NFT? Let's dive into one possible way to fractionalize a Digital Asset on this episode of [#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)

First, what is a fractionalized asset.

A fractionalized asset is when a single item is split into fractional ownership, a percentage of the full item.

Think of this as a puzzle, you own an individual piece of the whole puzzle, or multiple pieces, but not the whole puzzle.

Let's think about the requirements we want for our fungible asset:

- Interoperable with other systems
- Represents the actual asset (locked up)
- Allows for owning variable size parts

We'll use a Fungible Asset to fractionalize it. Let's take a look at the storage for the Digital Asset.

We want to allow locking up the digital asset, and the ability to unlock it if the owner holds 100% of the fractionalized parts.

We have stored here the DigitalAsset here to lockup.

The ExtendRef for allows someone to defractionalize the asset only if they have 100%, and the BurnRef will allow destroying the fractionalized pieces when the token is claimed.

Having the "ObjectGroup" allows us to extend this in the future, if we find that we're missing something.


![image_1](https://pbs.twimg.com/media/GF13P8mbEAAvE-u?format=png&name=small)


Okay, let's now start fractionalizing!

We first need to retrieve the token information, with the AptosTokenObjects library and then we can build the object for the fractionalized asset.

We specifically make this a sticky object, because fungible assets require that the metadata is not deletable.

This is because we want to make sure the asset is usable by other systems, and not to disappear.

Then, we go ahead and build up some information about the Fungible Asset from the Digital Asset that was its source.

![https://pbs.twimg.com/media/GF15db1bAAEx4HX?format=jpg&name=medium](https://pbs.twimg.com/media/GF15db1bAAEx4HX?format=jpg&name=medium)

Here's the fun part!

We can simply attach fungible asset to the object to allow it to be used as the metadata for the fungible asset.

At this point, we save the burn ref for cleanup later, and actually lock the asset up, while minting the number of shares we wanted.

Note, the mint ref is thrown away at the end of this function. No additional shares can be minted.

At this point your favorite wallet or defi tools can be used with the fractional asset directly if the support fungible assets.

![image_2](https://pbs.twimg.com/media/GF16A8FagAABXeq?format=png&name=900x900)

But, what if you just want the Digital Asset back?

You can simply recombine all the shares if you have them, and burn all of the fractionalized pieces, unlocking the Digital Asset back to your wallet.


![image_3](https://pbs.twimg.com/media/GF17gzFbIAAlXU-?format=jpg&name=medium)

What next?

There's tons of extensions that can be handled here:

- Make it into a DAO, so the NFT can be used in staking and other places
- Allow minting extra shares with the DAO
- Make the fungible asset also a Digital Asset, so that it shows up in your wallet like a NFT
- And many more!

Thanks everyone for reading this episode of

[#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)

and special thanks to

[@AptosNoob](https://twitter.com/AptosNoob)

for suggesting it!

LFM

Also, source code for these snippets:

[](https://t.co/nXP3nt7tJs)

[https://github.com/aptos-labs/daily-move/blob/main/snippets/fractional-token/sources/fractional_token.move](https://github.com/aptos-labs/daily-move/blob/main/snippets/fractional-token/sources/fractional_token.move)

