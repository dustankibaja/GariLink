# Development

Run commands from the repository root unless a directory change is shown. The active Flutter package is `mobile_flutter/`; the historical duplicate manifests are archived in [the repository audit](docs/audits/REPOSITORY_STRUCTURE.md).

## Windows and CI prerequisites

- Git and PowerShell; Flutter 3.41.7 with bundled Dart 3.11.5.
- Node 22.20.0 (the CI pin), npm and Python with `python -m pip install pglast==7.21`.
- Android SDK/JDK for Android builds; run `flutter doctor -v` to inspect your workstation.
- Docker is required for the full local Supabase stack. Flutter widget tests and portable Node tests do not require Docker or WSL. CI runs on Ubuntu 24.04.

```powershell
Set-Location mobile_flutter
flutter --version
flutter pub get --enforce-lockfile
dart format --output=none --set-exit-if-changed lib test
flutter analyze --no-pub
flutter test --no-pub --reporter expanded
```

For synthetic renders, set `GARILINK_FLEX_OUTPUTS` to an absolute output directory and run `flutter test --no-pub --update-goldens test/flex_visual_review_test.dart`. These are fixture renders, not device screenshots.

Run the app against an explicitly configured local facade (Android emulator):

```powershell
flutter run --dart-define=APP_ENV=development --dart-define=API_BASE_URL=http://10.0.2.2:54321/functions/v1/garilink-api
```

The endpoint must actually be running. A physical device needs a reachable development endpoint; its localhost is not the workstation. Owner tools require `--dart-define=ENABLE_SUPABASE_OWNER_TOOLS=true` in an appropriately configured test build. This flag is not authorization.

## Backend tests

```powershell
Set-Location supabase
npm ci --ignore-scripts
npm test
```

Portable tests cover handler behavior and SQL structure. They do not execute PostgreSQL policies. For disposable database certification, use the checked-in GitHub Actions workflow `database-certification.yml`; it runs PostgreSQL logic and a real disposable Supabase stack, replays migrations, and checks Auth/Storage boundaries. Both workflows support manual dispatch on an explicit branch. Confirm their `headSha` matches the commit being reviewed.

For a new disposable local Supabase environment with Docker available, from the repository root:

```powershell
npx --yes supabase@2.114.0 start
npx --yes supabase@2.114.0 functions serve garilink-api
```

Supply server-only configuration through a local ignored environment file when required. Never reset or link an existing hosted database as part of onboarding. The older `run-local-sql.ps1` assumes PostgreSQL 18 at a fixed Windows path and a separately provisioned database; it is not a generic installer. The CI SQL runner deliberately refuses ordinary workstation execution.

## Android and troubleshooting

Use `flutter build apk --debug` with the same explicit development/staging defines as `flutter run`. Release builds default to the production environment and require separate release review and signing configuration. Do not use a release build as a shortcut for local testing.

The baseline `tool/build_android.ps1` does not reliably stop on every native-command failure; a corrected wrapper exists as separate uncommitted release-preparation work. Prefer explicit commands and check `$LASTEXITCODE` after each command until that work is reviewed.

On this Windows workstation, Java networking required a short writable temporary directory. If reproducing that specific failure, set `TEMP`, `TMP`, and Java's `java.io.tmpdir`/`jdk.net.unixdomain.tmpdir` to a dedicated short directory for the build process, then restore them. Do not patch the JDK or disable TLS.

For Git ownership errors, verify ownership and trust only the exact intended repository with `git config --global --add safe.directory <absolute-repository-path>` if appropriate. Never use a wildcard exception.

Do not run historical `certify:*`, demo provisioning, or user-creation scripts against a hosted project during onboarding: some retrieve privileged credentials and write data. Review their targets and side effects first.
