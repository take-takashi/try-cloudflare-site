import { z } from "zod";

// FE/BE の疎通確認で共有する最初の API レスポンス契約を定義する。
export const healthResponseSchema = z.object({
	ok: z.literal(true),
	service: z.literal("api"),
});

export type HealthResponse = z.infer<typeof healthResponseSchema>;
