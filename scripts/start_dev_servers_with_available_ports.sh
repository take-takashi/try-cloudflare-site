#!/usr/bin/env sh
set -eu

find_port() {
	# OS に空き port を選ばせ、Wrangler に渡す値として使う。
	node -e "require('node:net').createServer().listen(0, '127.0.0.1', function () { console.log(this.address().port); this.close(); })"
}

cleanup() {
	# Astro が終了したときに、background 起動した API だけを片付ける。
	if [ -n "${API_PID:-}" ]; then
		kill "${API_PID}" 2>/dev/null || true
	fi
}

wait_for_api() {
	# Wrangler の生存確認と Hono の /health 応答確認をまとめて行う。
	API_BASE_URL="${API_BASE_URL}" API_PID="${API_PID}" node <<'NODE'
const url = `${process.env.API_BASE_URL}/health`;
const pid = Number(process.env.API_PID);
const deadline = Date.now() + 30000;
const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

while (Date.now() < deadline) {
	// background 起動した Wrangler が落ちた場合は、Astro を起動せず失敗させる。
	try {
		process.kill(pid, 0);
	} catch {
		console.error(`API プロセスが終了しました: ${url}`);
		process.exit(1);
	}

	// Hono の health check が応答してから Web を起動する。
	try {
		const response = await fetch(url, { signal: AbortSignal.timeout(1000) });
		if (response.ok) {
			process.exit(0);
		}
	} catch {
	}

	await sleep(250);
}

console.error(`API の起動確認がタイムアウトしました: ${url}`);
process.exit(1);
NODE
}

# API 側は Astro に URL を渡す必要があるため、先に空き port を決める。
API_PORT="$(find_port)"
API_BASE_URL="http://127.0.0.1:${API_PORT}"

# Wrangler の inspector port も 0 にして、複数 worktree 起動時の衝突を避ける。
echo "API ${API_BASE_URL}"
(cd apps/api && pnpm exec wrangler dev --port "${API_PORT}" --inspector-port 0) &
API_PID="$!"

# Astro 終了時や Ctrl-C 時に、background 起動した API も停止する。
trap cleanup EXIT INT TERM

wait_for_api

# Astro には公開環境変数として API URL を渡す。
echo "Web PUBLIC_API_BASE_URL=${API_BASE_URL}"
(cd apps/web && PUBLIC_API_BASE_URL="${API_BASE_URL}" pnpm exec astro dev --host 127.0.0.1)
