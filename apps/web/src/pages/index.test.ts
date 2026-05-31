import { healthResponseSchema } from "@try-cloudflare-site/api-contract";
import { describe, expect, it } from "vitest";

describe("web API contract import", () => {
	it("Web から共有 API 契約を参照できる", () => {
		const result = healthResponseSchema.parse({
			ok: true,
			service: "api",
		});

		expect(result.service).toBe("api");
	});
});
