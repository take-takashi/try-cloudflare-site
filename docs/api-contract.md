# API 契約

## 決定事項

- FE/BE 間の型共有は Hono RPC を使う。
- API 入出力の検証には Zod を使う。
- FE/BE で共有する Zod schema は `packages/api-contract` に置き、workspace package 名は `@try-cloudflare-site/api-contract` とする。
- `apps/web` から `apps/api` の runtime code を import しない。
- Hono `AppType` は必要に応じて `apps/web` から type-only import で参照する。
- DB schema は Drizzle、API schema は Zod として責務を分ける。

## 推奨配置

```txt
apps/
  web/
    src/lib/api.ts
  api/
    src/app.ts
    src/routes/
packages/
  api-contract/
    src/schemas/
    src/index.ts
```

## 未決事項

- `AppType` の export path。
- API client の base URL 注入方法。
- Zod schema の粒度と命名規則。
