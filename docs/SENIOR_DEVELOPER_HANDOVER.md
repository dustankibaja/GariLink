# Senior developer handover

Status: November 2026 development baseline. This document describes the checked-in baseline, not unfinished local features.

GariLink serves Tanzanian renters, individual owners and fleet workspaces. Discovery is free; rental requests progress through owner approval and pickup/return operations. Rental payments are off-platform. Workspace subscription billing is a separate planned domain.

Read the [root README](../README.md), [development guide](../DEVELOPMENT.md), and [current architecture](architecture/CURRENT_ARCHITECTURE.md) first. Flutter and Supabase are the active source. NestJS/Prisma and React Native remain preserved legacy implementations.

## Branches and evidence

- `main`: older source; do not assume it contains current product work.
- `integration/garilink-product-2026-11`: PR #2 product integration.
- `fix/garilink-flutter-lockfile-2026-11-05`: PR #3 lockfile and formatter corrections.
- `codex/garilink-rc-20261105`: exact `d54423c` baseline with passing November 5 Flutter and disposable Supabase CI, linked in the root README.
- `chore/senior-developer-readiness-20261108`: this maintenance branch.
- Identity lifecycle/evidence branches are divergent experiments and certification work; do not merge them without dedicated security review.

Local phone-linking, subscription, UI-polish and release-preparation worktrees contain unfinished, uncommitted changes. Their branch names alone do not contain those changes. Preserve and review the working files before attempting integration.

## Verified scope and open gaps

Baseline CI exercised Flutter analysis/widget/unit tests and disposable database migration/authorization/Auth/Storage assertions. It does not establish current hosted configuration, real SMS delivery, live payment success or Android device behavior.

Highest-priority gaps are authenticated phone linking, consent-gated contact access, stale rental approval checks, hosted migration reconciliation, account deletion and operational readiness. Owner rental payloads currently expose customer phone data without the required consent/status gate. KYC remains closed. Monitoring has no certified production sink. Explore currently loads a single default page.

The legacy backend tracks generated `dist` files that an old Vercel adapter imports. Preserve them until clean regeneration and deployment dependencies are resolved. Historical root architecture documents conflict with current code; the new architecture guide takes precedence for onboarding, while old reports retain their evidence value.

## First contributions

1. Finish and certify the existing authenticated phone-linking work with same-account and revoked-session negative tests.
2. Implement consent-based rental contact authorization and verify actual payloads across tenant and rental-state boundaries.
3. Complete Explore pagination and accessibility regression tests from the isolated UI worktree.
4. Reproduce the legacy backend build and resolve generated-output deployment assumptions before removing tracked artifacts.
5. Review the subscription domain independently from Snippe transport and Google Play payment-policy decisions.

Use isolated branches and focused PRs. Keep migrations append-only, preserve historical evidence, and attach test results to the exact source commit. Production changes, real SMS, charges and merges into main require separate review and authorization.

Sprint 5.0A has passing candidate CI and awaits integration review. Phone linking and subscriptions have separate local work in progress. Consent-based rental contact is pending implementation. Hosted and device certification remain release gates. Track assignments and acceptance criteria in [production epic #4](https://github.com/dustankibaja/GariLink/issues/4).
