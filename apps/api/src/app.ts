import { healthResponseSchema } from "@try-cloudflare-site/api-contract";
import { Hono } from "hono";

export const app = new Hono().get("/health", (c) => {
	// 共有 schema でレスポンスを組み立て、API 契約から実装が外れないようにする。
	const response = healthResponseSchema.parse({
		ok: true,
		service: "api",
	});

	return c.json(response);
});

export type AppType = typeof app;
