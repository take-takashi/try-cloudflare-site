import { describe, expect, it } from "vitest";
import { app } from "./app";

describe("app", () => {
	it("GET /health で API の稼働状態を返す", async () => {
		const response = await app.request("/health");

		expect(response.status).toBe(200);
		await expect(response.json()).resolves.toEqual({
			ok: true,
			service: "api",
		});
	});

	it("未定義の route は 404 を返す", async () => {
		const response = await app.request("/missing");

		expect(response.status).toBe(404);
	});
});
