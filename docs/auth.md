# 認証

## 決定事項

- 認証には better-auth を使う。
- 認証処理の実体は `apps/api` に置く。
- `apps/web` は API 経由で認証状態を扱う。
- `apps/web` は認証の server secret を保持しない。
- 認証関連 secret をログや回答に出力しない。

## 未決事項

- better-auth の adapter / DB schema 設計。
- session / cookie の設定。
- OAuth provider の有無。
- preview / production の secret 管理。
