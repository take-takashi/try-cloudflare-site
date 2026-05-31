# 課金

## 決定事項

- 課金には Stripe を使う。
- Stripe webhook は `apps/api` 側で受ける。
- 課金状態は API / DB を通じて扱い、Frontend だけで信頼しない。
- Stripe secret や webhook secret をログや回答に出力しない。

## 未決事項

- 商品 / price / subscription の設計。
- Stripe webhook route。
- webhook event の検証と冪等性。
- preview / production の Stripe account または key の扱い。
