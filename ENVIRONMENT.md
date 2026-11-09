# Environment configuration

| Name | Where and why |
| --- | --- |
| `APP_ENV`, `API_BASE_URL` | Flutter build defines. Use an explicit development or staging facade URL. Release defaults to production. |
| `ENABLE_SUPABASE_OWNER_TOOLS` | Flutter owner tools switch. Database authorization still applies. |
| `ENABLE_VERIFICATION_PREVIEW` | Development UI preview for verification flows. |
| `SUPABASE_URL`, `SUPABASE_ANON_KEY` | Edge runtime project endpoint and public API key. |
| `SUPABASE_SERVICE_ROLE_KEY` | Server only. Signs media, persists trusted rental estimates and backs the SMS delivery ledger. |
| `GARILINK_AUTH_REDIRECT_URL` | Email confirmation/recovery callback. Use the exact callback allowlisted in `supabase/config.toml`. |
| `CORS_ORIGINS` | Comma-separated browser origins. |
| `GOOGLE_ROUTES_API_KEY` | Optional server credential for route estimates. |
| `SEND_SMS_HOOK_SECRET` | Server secret for verifying signed Auth hook requests. |
| `BEEM_API_KEY`, `BEEM_SECRET_KEY`, `BEEM_SENDER_ID` | SMS credentials and approved sender ID. Live delivery certification is pending. |
| `GARILINK_FLEX_OUTPUTS` | Local output directory for synthetic widget renders. |

Use [the server template](supabase/.env.example) for local configuration. Keep development, staging and production credentials separate. Never package server credentials in Flutter. For onboarding, use disposable Auth and Storage fixtures and leave live SMS disabled.

See [development](DEVELOPMENT.md) for commands and [the production roadmap](https://github.com/dustankibaja/GariLink/issues/4) for release gates.
