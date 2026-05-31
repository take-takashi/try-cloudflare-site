# AGENTS.md

## 基本方針

- 回答は日本語で行う。
- 作業前に既存コード、設定ファイル、関連 docs を確認する。
- 既存のユーザー変更を勝手に戻さない。
- 秘密情報や token の値をログや回答に出力しない。
- AGENTS.md は作業契約として保ち、詳細は `docs/` に分ける。

## 採用スタック

- Frontend: Astro / Cloudflare Pages
- Backend: Hono / Cloudflare Workers
- API 型共有: Hono RPC
- API 入出力検証: Zod
- Database: Cloudflare D1
- DB schema / migration 生成: Drizzle
- Auth: better-auth
- Billing: Stripe
- Tooling: mise, pnpm, Wrangler
- Git: husky, git worktree, Conventional Commits

## 構成

- Frontend は `apps/web` に置く。
- Backend は `apps/api` に置く。
- FE/BE で共有する API 契約と Zod schema は `packages/api-contract` に置く。
- `apps/web` から `apps/api` への runtime import を禁止する。Hono `AppType` などの type-only import は許可する。
- DB schema は Drizzle、API schema は Zod として責務を分ける。

## タスク

- パッケージ管理は pnpm を使う。
- 定型タスクは `mise run <task>` で実行する。
- `install`, `dev`, `build`, `test`, `lint`, `format`, `check`, `verify` を基本タスクとして維持する。
- 追加タスクは `test:*`, `db:*`, `deploy:*` のように役割が分かる namespace を優先する。
- `check` は日常的に実行する軽量な総合確認とする。
- `verify` は PR 前やリリース前の重い総合確認とし、`check`、`test:all`、`build` などを含めてよい。
- 環境変数を一時的に上書きして `mise run` してはいけない。環境やモードは usage で定義した引数として渡す。

## 開発

- `mise run dev` はローカル開発に必要な FE + BE をまとめて起動する。
- Backend は Wrangler + Hono を空きポートで起動し、そのポートを Astro に渡す。
- 詳細は `docs/local-development.md` を参照する。

## デプロイ

- デプロイは `mise run deploy --env <env>` で実行する。
- `--env` は mise task の usage で必須パラメータとして定義する。
- 初期の deploy env は `preview` と `production` とする。
- GitHub Actions はデプロイや検証コマンドを直接書かず、`mise run` タスクを呼び出す。
- Pull Request は `preview`、`main` への push は `production` にデプロイする。手動実行も用意する。
- 詳細は `docs/deployment.md` を参照する。

## DB / Auth / Billing

- D1 migration は Wrangler の migration 機構で適用する。
- schema 定義と migration SQL 生成には Drizzle を使う。
- migration の生成と適用は分ける。
- `mise run db:generate` で migration SQL を生成する。
- `mise run db:migrate --env <env>` で指定環境に適用する。
- production D1 へ直接 SQL を実行しない。
- 認証の詳細は `docs/auth.md`、課金の詳細は `docs/billing.md`、DB の詳細は `docs/database.md` を参照する。

## Git

- commit は Conventional Commits 形式にし、本文は日本語で書く。
- hook が定義されている場合は迂回しない。
- pre-commit は軽量検証のみを想定し、最終確認は必要に応じて `mise run check` または `mise run verify` で行う。
- 複数タスクを並行する場合、大きめの実装、PR 単位の作業では git worktree を使う。
- 小さな文書修正や単発の軽微な変更では、既存 worktree で作業してよい。
- worktree は `.worktree/<branch-name>` に作る。branch 名に `/` が含まれる場合、path では `/` を `--` に置き換える。
- branch 名は `<type>/<topic>` を基本とし、`<type>` は Conventional Commits の type に合わせる。
- worktree や branch は必要に応じて作成してよいが、削除や初期化はユーザー確認なしに行わない。
