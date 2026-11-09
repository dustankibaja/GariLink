# Contributing to GariLink

Read [README](README.md), [DEVELOPMENT](DEVELOPMENT.md), and the [senior developer handover](docs/SENIOR_DEVELOPER_HANDOVER.md) before changing code. The active implementation is Flutter plus Supabase. Legacy NestJS/React Native sources and historical reports are preserved for provenance.

## Choose the correct baseline

`main` is not necessarily the newest product implementation. Check current remote refs, open PRs, workflow results, and the handover. Use a focused branch or isolated worktree from the agreed reviewed integration baseline; record its base SHA in the PR. Do not blindly combine divergent identity/security branches.

Before editing, inspect `git status --short`, `git worktree list`, and the relevant diff. Preserve other contributors' changes. Do not force-push, rewrite shared history, delete another worktree, or include unrelated generated files in a cleanup. Never use a global `safe.directory=*` workaround; if a trusted local checkout has an ownership mismatch, scope any exception to that exact directory.

Use descriptive branches such as `fix/booking-retry`, `feat/workspace-subscriptions`, or `chore/developer-docs`. Prefer small commits with a clear purpose, following the repository's descriptive style: `fix(auth): ...`, `feat(owner): ...`, `docs: ...`, `test: ...`, or `chore: ...`. Keep generated-artifact cleanup separate from documentation and behavior changes.

## Implement and verify

- Keep tenant, actor, capability, lifecycle, and idempotency checks on the server. A UI role or workspace selection never grants authority.
- Preserve public request/response contracts unless a documented defect or approved product change requires an update. Update client, API, SQL, and regression evidence together when a contract changes.
- Keep retries safe: unchanged intent retains its request ID; edited input is a new intent. Test stale responses, account/workspace changes, and authorization failures when relevant.
- Prefer a small, tested correction over a broad architectural rewrite. Document map-based model or widget complexity debt rather than pretending the current project enforces layers it does not.
- Use existing design tokens and accessible controls. Include loading, empty, retry, disabled, and failure states. Synthetic widget images are layout evidence, not device certification.

The exact prerequisite and execution instructions are in [DEVELOPMENT](DEVELOPMENT.md). With the pinned Flutter 3.41.7/Dart 3.11.5 toolchain, run from `mobile_flutter/`:

```powershell
flutter pub get --enforce-lockfile
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test --no-pub --reporter expanded
```

Run the focused regression file list and synthetic-render command defined by [Flutter CI](.github/workflows/flutter-ci.yml) when validating an integration or UI change. If formatting is needed, run `dart format` on the touched files, inspect the diff, and repeat the check. Do not regenerate the lockfile with a different SDK to make a local run pass; dependency changes require review of the pinned toolchain and lockfile diff.

From `supabase/`, `npm ci` and `npm test` run portable tests with the Node/Python prerequisites documented in the development guide. They do not replace actual PostgreSQL or Supabase platform tests. [Database CI](.github/workflows/database-certification.yml) separately exercises authorization SQL, migration replay, Auth, and Storage on disposable infrastructure.

## Database migrations and security review

Read all later overrides of a function, policy, or serializer before editing its behavior. Migration filenames are ordered history; do not edit an already-shared migration to conceal a deployment difference.

1. Use the repository-pinned Supabase CLI and inspect `migration new --help` before creating a migration. Use the CLI to generate the new file name.
2. Develop against a disposable database. A reset/replay command belongs only to that disposable environment; never run it against a hosted or shared project as a testing shortcut.
3. Review table grants, RLS, function execution grants, `search_path`, actor/session checks, and tenant ownership together. `SECURITY DEFINER` requires an explicit reason and a minimal, tested privilege boundary.
4. Add positive and negative assertions for the changed contract. Cover anonymous access, unrelated users/workspaces, inactive or revoked access, replay, and concurrency where applicable.
5. Run the migration chain and relevant SQL/platform tests. A parser check or mocked API test alone is not evidence that SQL executes or that Storage accepts/rejects the intended operation.
6. Explain schema effects, compatibility, deployment order, data implications, and recovery strategy in the PR. Production migration or configuration changes require separate release review and explicit authorization.

Never authorize from editable user metadata, trust a client actor ID, expose service-role keys in Flutter, or treat a stale JWT claim as proof of current access. Sensitive authorization uses current database state and session checks. Keep precise location, identity evidence, phone numbers, tokens, OTPs, and provider payloads out of public projections and logs. Inspect real payload paths as well as UI visibility.

## Configuration and external services

Use [ENVIRONMENT](ENVIRONMENT.md) and safe placeholders. Keep secrets, local configuration, signing keys, APKs/AABs, caches, and generated build outputs out of source commits. Tests use mocks or explicitly disposable infrastructure by default. Production resources, real SMS, customer charges, and Play publication are outside routine development authorization.

Beem delivery remains pending live credentials and authorized delivery tests. Snippe is the confirmed subscription provider, but a provider choice is not a billing implementation. Rental settlement remains off-platform. Android payment flows require a documented Google Play policy decision. Do not label phone possession as completed identity/KYC verification, and do not enable a closed verification foundation by changing only a client flag.

## Pull requests and completion criteria

Open a draft PR early enough for review. Describe the concrete problem and final behavior, then provide:

- Base/head commits and related issue; include the migration and API impact where relevant.
- Focused diff summary and any preserved legacy files or deliberately deferred work.
- Exact checks run, environment/tool versions, results, and links to CI/artifacts. State precise failures and unexecuted checks without converting them into passes.
- Security/privacy implications, compatibility considerations, and rollback or recovery plan appropriate to the change.

Review is required before merging; security-sensitive work needs explicit review of its authorization boundaries and negative tests. Do not merge into `main` or deploy as a side effect of maintenance. Keep the master roadmap and sprint issues consistent with demonstrated completion rather than code volume.

A change is done when its intended behavior is implemented, relevant checks pass, documentation and links match the code, no unrelated work or secrets entered the diff, and remaining limitations are visible. For an integration candidate, run Flutter and database certification on the **same exact commit**. Path-filtered CI may skip documentation-only changes; dispatch both workflows explicitly when fresh certification is required. Green disposable CI does not establish hosted reconciliation, live SMS/payment success, Android device behavior, or production approval.
