# デプロイ

## 決定事項

- デプロイは Wrangler を使う。
- デプロイ入口は `mise run deploy --env <env>` に統一する。
- `--env` は mise task の usage で必須パラメータとして定義する。
- 初期の deploy env は `preview` と `production` とする。
- GitHub Actions は `mise run` タスクを呼び出す。
- Pull Request は `preview`、`main` への push は `production` にデプロイする。
- 手動実行も用意する。
- FE と BE の責務は分けるが、デプロイ実行入口は `mise run deploy` に集約する。

## 未決事項

- Cloudflare Pages / Workers の具体的な project 名。
- `preview` と `production` の binding、secret、D1 database の対応関係。
- 手動デプロイ時の承認フロー。
- rollback 方針。
