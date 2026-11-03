import assert from "node:assert/strict";
import { test } from "node:test";
import { createApi } from "../functions/garilink-api/handler.ts";

// Sprint 5.0A: distinct, allowlisted authorization codes. Provider text is
// matched exactly and never forwarded; unknown 42501 causes remain generic.
const config = {
  supabaseUrl: "https://project.supabase.co",
  anonKey: "public-test-key",
  origins: ["https://garilink.test"],
};
const listingId = "11111111-1111-4111-8111-111111111111";

function rentalRequest() {
  return new Request("https://example.test/garilink-api/rentals", {
    method: "POST",
    headers: { "Content-Type": "application/json", Authorization: "Bearer token" },
    body: JSON.stringify({ listingId, requestId: listingId, startDate: "2026-12-01", endDate: "2026-12-03" }),
  });
}

function apiFailingWith(detail: Record<string, unknown>, status = 403) {
  return createApi(config, async (url) => {
    if (String(url).endsWith("/auth/v1/user")) return Response.json({ id: "actor" });
    return Response.json(detail, { status });
  });
}

for (const [message, code] of [
  ["A confirmed account is required; verify contact before sensitive actions.", "VERIFIED_ACCOUNT_REQUIRED"],
  ["Sign in with an active, verified account to continue.", "VERIFIED_ACCOUNT_REQUIRED"],
  ["You cannot rent your own vehicle", "OWN_VEHICLE"],
  ["You cannot estimate your own vehicle", "OWN_VEHICLE"],
  ["Owners cannot manage their own rental", "OWN_VEHICLE"],
  ["Workspace access denied", "WORKSPACE_ACCESS_DENIED"],
] as const) {
  test(`42501 "${message}" maps to ${code}`, async () => {
    const response = await apiFailingWith({ code: "42501", message })(rentalRequest());
    assert.equal(response.status, 403);
    const body = await response.json();
    assert.equal(body.code, code);
    assert.notEqual(body.message, message, "SQL text is never forwarded verbatim");
    assert.ok(!/42501|sql|garilink_private/i.test(body.message));
  });
}

test("authorization causes stay distinguishable", async () => {
  const codes = new Set<string>();
  for (const message of [
    "A confirmed account is required; verify contact before sensitive actions.",
    "You cannot rent your own vehicle",
    "Workspace access denied",
    "Capability required",
  ]) {
    const response = await apiFailingWith({ code: "42501", message })(rentalRequest());
    codes.add((await response.json()).code);
  }
  assert.equal(codes.size, 4);
});

test("verified-account copy does not claim the only cause is a phone", async () => {
  const response = await apiFailingWith({
    code: "42501",
    message: "A confirmed account is required; verify contact before sensitive actions.",
  })(rentalRequest());
  const body = await response.json();
  assert.match(body.message, /isn't cleared for this action/);
});

for (const detail of [
  { code: "42501", message: "Capability required" },
  { code: "42501", message: "permission denied for function garilink_create_rental" },
  { code: "42501" },
  {},
]) {
  test(`unknown authorization failure stays generic: ${JSON.stringify(detail)}`, async () => {
    const response = await apiFailingWith(detail)(rentalRequest());
    assert.equal(response.status, 403);
    const body = await response.json();
    assert.equal(body.code, "PERMISSION_DENIED");
    assert.equal(body.message, "You do not have permission to perform this action.");
  });
}

test("non-allowlisted internal codes are never sent to the client", async () => {
  const response = await apiFailingWith({ code: "23505" }, 409)(rentalRequest());
  assert.equal(response.status, 409);
  const body = await response.json();
  assert.equal(body.code, undefined);
});

test("registration still hides whether an account exists", async () => {
  const api = createApi(config, async () =>
    Response.json({ error_code: "user_already_exists" }, { status: 422 }),
  );
  const response = await api(
    new Request("https://example.test/garilink-api/auth/register", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email: "person@example.com", password: "long-password-1" }),
    }),
  );
  const body = await response.json();
  assert.notEqual(body.code, "user_already_exists");
});
