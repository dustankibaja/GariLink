# GariLink environments and secrets

GariLink currently supports development and production. No staging environment is claimed.

| Name | Component/location | Owner/supplier | Required |
| --- | --- | --- | --- |
| `API_BASE_URL` | Flutter `--dart-define` | Developer / release operator | Required for debug and profile builds (local or staging). Release builds with `APP_ENV=production` use the approved production endpoint when it is omitted |
| `APP_ENV` | Flutter `--dart-define` | Release operator | Defaults to `production` only in release builds and `development` otherwise. Any non-production value is refused if it points at the production project |

Debug and profile builds no longer fall back to production. Without `API_BASE_URL` the app starts, but every request fails with a clear configuration message. Example local run: `flutter run --dart-define=API_BASE_URL=http://10.0.2.2:54321/functions/v1/garilink-api`. Deliberate production debugging requires `--dart-define=APP_ENV=production`.
| `GARILINK_KEYSTORE_FILE` | Protected build environment | Company | Signed release |
| `GARILINK_KEYSTORE_PASSWORD` | Protected build environment | Company | Signed release |
| `GARILINK_KEY_ALIAS` | Protected build environment | Company | Signed release |
| `GARILINK_KEY_PASSWORD` | Protected build environment | Company | Signed release |
| `BEEM_API_KEY` | Supabase Edge Function secret | Company/Beem | Live SMS |
| `BEEM_SECRET_KEY` | Supabase Edge Function secret | Company/Beem | Live SMS |
| `BEEM_SENDER_ID` | Supabase Edge Function secret | Company/Beem | Live SMS |
| `SEND_SMS_HOOK_SECRET` | Supabase secret/Auth hook | Supabase/company | Signed SMS hook |
| Supabase built-in keys/URL | Supabase managed function secrets | Supabase | API/functions |
| Monitoring DSN/config | Protected build/deployment environment | Company | Crash monitoring |
| `SEED_*_PASSWORD` | Local development environment only | Developer | Legacy local seed only |

Release builds reject local or non-HTTPS API endpoints. Android production cleartext is
disabled. Never put service-role keys, Beem secrets, monitoring credentials, database
passwords, signing passwords, OTPs, or private tokens in Flutter source or documentation.

