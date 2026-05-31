# Database

## 決定事項

- Database は Cloudflare D1 を使う。
- ORM / schema 管理には Drizzle を使う。
- Drizzle schema から SQL migration を生成する。
- D1 への migration 適用は Wrangler の migration 機構で行う。
- migration の生成と適用は分ける。
- `mise run db:generate` で migration SQL を生成する。
- `mise run db:migrate --env <env>` で指定環境に適用する。
- production D1 へ直接 SQL を実行しない。
- D1 の schema 定義と migration は `apps/api` 配下で管理する。

## 推奨配置

```txt
apps/api/
  src/db/schema.ts
  drizzle.config.ts
  drizzle/
    migrations/
```

## 未決事項

- D1 database 名と binding 名。
- Drizzle config の具体的な設定。
- local / preview / production の migration 適用手順。
- seed データの扱い。
