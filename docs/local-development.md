# ローカル開発

## 決定事項

- パッケージ管理は pnpm を使う。
- 定型タスクは `mise run <task>` で起動する。
- `mise run dev` は FE と BE をまとめて起動する。
- Backend は Wrangler + Hono を空きポートで起動し、そのポートを Astro に渡す。
- 実行直前だけ環境変数を変更する運用は禁止する。環境やモードは mise task の usage で定義した引数として渡す。

## 未決事項

- `mise run dev` の具体的な orchestration 実装。
- Astro へ Backend port を渡す方法。
- `install`, `build`, `test`, `lint`, `format`, `check`, `verify` の具体的な中身。
- husky hook の具体的な検証内容。
