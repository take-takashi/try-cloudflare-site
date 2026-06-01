# ローカル開発

## 決定事項

- パッケージ管理は pnpm を使う。
- pnpm は mise と `packageManager` で `11.5.0` に固定する。
- pnpm は `minimumReleaseAge: 10080` を設定し、公開から 7 日未満の package version を install / update 対象にしない。
- 定型タスクは `mise run <task>` で起動する。
- `install` は `pnpm install` を実行する。
- `dev` は API を空きポートで先に起動し、その URL を Web に渡して起動する。
- `lint` は Biome による静的解析を実行する。
- `format` は Biome による自動整形を実行する。
- `test` は workspace 配下に定義された test script を実行する。
- `security` は `pnpm audit --prod` による本番依存関係の脆弱性監査を実行する。
- `security:all` は `pnpm audit` による開発依存関係を含む脆弱性監査を実行する。
- `deps:outdated` は依存関係の更新候補を確認する。
- `check` は `lint` と `test` を実行する軽量検証とする。
- `verify` は `check`、`security:all`、`test:all`、`build` を実行する総合検証とする。
- Husky は `9.1.7` に固定し、`pre-commit` では `mise run check` を実行する。
- Husky の `post-checkout` は `node_modules` が無い場合だけ `mise run install` を実行し、新規 worktree 作成直後の依存関係を用意する。
- `mise run dev` は FE と BE をまとめて起動する。
- `mise run dev` は `scripts/start_dev_servers_with_available_ports.sh` で FE / BE の起動順と port を制御する。
- Backend は Wrangler + Hono で起動する。API の空き port は Astro に `PUBLIC_API_BASE_URL` として渡す。
- Web は API の `/health` が応答してから起動する。
- 実行直前だけ環境変数を変更する運用は禁止する。環境やモードは mise task の usage で定義した引数として渡す。

## 依存関係のセキュリティ運用

- 脆弱性は、まず直接依存または上流 package の通常アップデートで解消する。
- 通常アップデートで解消できない transitive dependency の脆弱性に限り、`pnpm-workspace.yaml` の `overrides` を例外的に許可する。
- `overrides` は対象 package をできるだけ狭く指定し、理由と解除条件をコメントで残す。
- 定期的に `mise run deps:outdated` と `mise run security:all` を実行し、上流更新で解消できるようになった `overrides` は削除する。

## 未決事項

- Astro から Backend API へ接続する具体的な base URL 注入方法。
- FE/BE をまたぐ E2E test の導入範囲。
