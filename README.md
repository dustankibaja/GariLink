# GariLink

GariLink is a vehicle rental marketplace for Tanzania. Renters discover vehicles and request rentals; individual owners and fleet operators manage workspace inventory and rental requests. Rental settlement happens outside GariLink. Approval is not proof of payment.

## Start here

- [Developer setup](DEVELOPMENT.md)
- [Current architecture](docs/architecture/CURRENT_ARCHITECTURE.md)
- [Senior developer handover](docs/SENIOR_DEVELOPER_HANDOVER.md)
- [Contributing](CONTRIBUTING.md)
- [Environment configuration](ENVIRONMENT.md)
- [Repository structure audit](docs/audits/REPOSITORY_STRUCTURE.md)
- [Production roadmap and Sprint 5 issues](https://github.com/dustankibaja/GariLink/issues/4)
- [Documentation index](docs/README.md)

## Active stack and repository

| Path | Role |
| --- | --- |
| `mobile_flutter/` | Active Flutter client: Riverpod, GoRouter, Dio, secure token storage |
| `supabase/` | Active backend source: Auth, PostgreSQL/PostGIS migrations, RPC authorization, Storage and Edge Functions |
| `.github/workflows/` | Flutter regression and disposable database certification |
| `backend/` | Preserved legacy NestJS/Prisma implementation and deployment adapters |
| `mobile/` | Preserved earlier React Native implementation |
| Root sprint reports | Historical decisions and evidence; not current release certification |

Flutter calls the `garilink-api` Edge Function through Dio. The facade validates authentication and invokes narrow database RPCs. Database functions enforce account, session, workspace and capability boundaries. Selected server operations use a service-role credential; that credential must never enter the mobile application.

## Development baseline

The cleanup branch starts at `d54423cfb89b1b82f936dfaf63c5b45ef596360d`, also published as `codex/garilink-rc-20261105`. `main` is older. PR #2 integrates the product work onto FLEX; PR #3 contains the Flutter lockfile and formatting corrections. None is implicitly approved for production.

On that exact baseline, [Flutter CI](https://github.com/dustankibaja/GariLink/actions/runs/41995560370) and [disposable database certification](https://github.com/dustankibaja/GariLink/actions/runs/41995868296) passed on November 5, 2026. These are historical baseline results, not fresh cleanup results or hosted deployment evidence.

## Quick check

Install Flutter **3.41.7** (Dart **3.11.5**), Git, Node **22.20.0**, and Python with `pglast==7.21` for SQL parser tests.

```powershell
Set-Location mobile_flutter
flutter pub get --enforce-lockfile
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test --no-pub
Set-Location ../supabase
npm ci --ignore-scripts
npm test
```

See the development guide before starting a backend or building Android. Debug builds require an explicit local/staging `API_BASE_URL`. Do not use production for onboarding.

## Current limitations

Authenticated same-account phone linking, consent-based contact sharing, subscription billing, account deletion and production operations are unfinished. Beem delivery has not been certified with live credentials. Snippe is the confirmed intended subscription provider, but no live payment certification is claimed. KYC is a closed foundation, not an active identity-verification service. Hosted migration drift and real Android device journeys still need certification.

Uncommitted phone, subscription, UI and release-preparation work is preserved in separate local worktrees; it is not part of this baseline. Legacy Render/Vercel/Docker files remain for provenance and must not be treated as current deployment instructions.
