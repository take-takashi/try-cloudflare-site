import { describe, expect, it } from "vitest";
import { healthResponseSchema } from "./index";

describe("healthResponseSchema", () => {
	it("API の health response として期待する形だけを許可する", () => {
		const result = healthResponseSchema.parse({
			ok: true,
			service: "api",
		});

		expect(result).toEqual({
			ok: true,
			service: "api",
		});
	});

	it("service 名が異なる response を拒否する", () => {
		expect(() =>
			healthResponseSchema.parse({
				ok: true,
				service: "web",
			}),
		).toThrow();
	});
});
