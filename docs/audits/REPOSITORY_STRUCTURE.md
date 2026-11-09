# Repository structure audit

Baseline `d54423cfb89b1b82f936dfaf63c5b45ef596360d`, published as `codex/garilink-rc-20261105`. GitHub Flutter and database workflows select `mobile_flutter/` and `supabase/`. Hosted configuration was outside this inspection.

| Component | Evidence and decision |
| --- | --- |
| `mobile_flutter/`, `supabase/` | Active packages with their own manifests, migrations and CI. Preserve source and package lockfiles. |
| `mobile/`, `backend/` | Legacy React Native and NestJS/Prisma packages. Preserve source, migrations, dependency manifests and deployment descriptors. |
| `backend/dist/` | 925 tracked generated files. The old Vercel adapter imports `../dist/app.module` and includes `dist/**`. Docker references `dist/main`, while the production npm script uses `dist/src/main.js`. Keep tracked artifacts until a clean legacy build can regenerate the required entry points and the deployment dependencies are resolved. The existing `dist/` ignore already covers newly generated files. |
| Root Flutter manifests | Identical historical manifests, no tracked caller found, and the root asset path does not exist. Archive both outside the package discovery path. Use `mobile_flutter/pubspec.yaml`. |
| Render, Vercel, Docker and `update_schema.py` | Legacy tooling with historical deployment or Prisma dependencies. Preserve at original paths. The schema helper writes to the legacy Prisma schema and should stay out of onboarding. |
| Sprint reports and security evidence | Preserve paths and original bodies. The documentation map provides a current entry point. |

Before cleanup, the root exposed duplicate Flutter manifests and historical guides without an onboarding entry point. After cleanup, the root README leads to current setup, architecture, environment and handover docs. The two historical manifests remain readable under `docs/history/root-manifests/`. Active application paths and database migrations stay in place.

The tracked-tree scan looked for private key headers and known GitHub and Supabase secret token patterns. It found no matches in those patterns. This was a targeted check, without a history-wide credential scan. Several historical certification scripts can retrieve service credentials and write hosted data. Treat them as operational tooling and use the disposable CI workflow for onboarding.
