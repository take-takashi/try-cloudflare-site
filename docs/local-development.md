# ローカル開発

## 決定事項

- パッケージ管理は pnpm を使う。
- pnpm は mise と `packageManager` で `11.5.0` に固定する。
- pnpm は `minimumReleaseAge: 10080` を設定し、公開から 7 日未満の package version を install / update 対象にしない。
- 定型タスクは `mise run <task>` で起動する。
- `install` は `pnpm install` を実行する。
- `dev` は workspace 配下に定義された dev script を並列実行する。
- `lint` は Biome による静的解析を実行する。
- `format` は Biome による自動整形を実行する。
- `test` は workspace 配下に定義された test script を実行する。
- `check` は `lint` と `test` を実行する軽量検証とする。
- `verify` は `check`、`test:all`、`build` を実行する総合検証とする。
- Husky は `9.1.7` に固定し、`pre-commit` では `mise run check` を実行する。
- Husky の `post-checkout` は `node_modules` が無い場合だけ `mise run install` を実行し、新規 worktree 作成直後の依存関係を用意する。
- `mise run dev` は FE と BE をまとめて起動する。
- `mise run dev` は root 直下の補助 script を使わず、workspace package の `dev` script を `pnpm -r --parallel --if-present dev` で起動する。
- Backend は Wrangler + Hono で起動する。初期構成では FE へ Backend port を自動注入しない。
- 実行直前だけ環境変数を変更する運用は禁止する。環境やモードは mise task の usage で定義した引数として渡す。

## 未決事項

- Astro から Backend API へ接続する具体的な base URL 注入方法。
- FE/BE をまたぐ E2E test の導入範囲。
