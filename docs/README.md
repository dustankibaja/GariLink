# Documentation map

Start with the [project README](../README.md), then the [senior developer handover](SENIOR_DEVELOPER_HANDOVER.md). You do not need to read the historical sprint archive before working on the current application.

## Current entry points

| Document | Use it for |
| --- | --- |
| [Senior developer handover](SENIOR_DEVELOPER_HANDOVER.md) | Source baseline, active work, evidence, technical debt, and first contributions |
| [Current architecture](architecture/CURRENT_ARCHITECTURE.md) | Actual Flutter/Supabase boundaries and implemented versus planned behavior |
| [Development](../DEVELOPMENT.md) | Windows and CI setup, commands, and troubleshooting |
| [Contributing](../CONTRIBUTING.md) | Branches, review, migrations, tests, and completion criteria |
| [Environment and secrets](../ENVIRONMENT.md) | Configuration names, purpose, and environment separation |
| [Flutter package guide](../mobile_flutter/README.md) | Mobile entry point and build-specific details |
| [Supabase package guide](../supabase/README.md) | Backend entry point and test boundaries |

Current documentation describes the cleanup branch's source. The migration chain and tested implementation resolve conflicts with older prose. A historical certification claim applies only to its named commit, environment, and exercised checks.

## Product/domain references

These documents record design decisions and implementation stages. They remain useful background, but some proposals were superseded; consult the current architecture before treating a proposed enum, policy, or open decision as live behavior.

| Area | References |
| --- | --- |
| Product direction | [Product model V2](../GARILINK_PRODUCT_MODEL_V2.md), [V2 decision register](../GARILINK_V2_DECISION_REGISTER.md), [domain foundation](../GARILINK_V2_DOMAIN_FOUNDATION.md) |
| Vehicle model and operations | [V2 migration map](../GARILINK_V2_MIGRATION_MAP.md), [owner flow](../GARILINK_V2_OWNER_VEHICLE_FLOW.md), [vehicle operations](../GARILINK_VEHICLE_OPERATIONS_V2.md), [availability policy](../GARILINK_VEHICLE_AVAILABILITY_POLICY_V1.md) |
| Discovery | [Transport need](../GARILINK_TRANSPORT_NEED_DOMAIN.md), [suitability](../GARILINK_VEHICLE_SUITABILITY_ENGINE.md), [nearby discovery](../GARILINK_NEARBY_DISCOVERY.md), [discovery experience](../GARILINK_DISCOVERY_EXPERIENCE.md) |
| Location and pricing | [Location privacy](../GARILINK_LOCATION_PRIVACY_DOMAIN.md), [route distance](../GARILINK_ROUTE_DISTANCE_DOMAIN.md), [pricing](../GARILINK_RENTAL_PRICING_DOMAIN.md), [estimate domain](../GARILINK_RENTAL_PRICE_ESTIMATE_DOMAIN.md) |
| Renter and owner journeys | [Booking](../GARILINK_BOOKING_REQUEST_EXPERIENCE.md), [trips](../GARILINK_TRIPS_LIFECYCLE_EXPERIENCE.md), [owner/fleet architecture](../GARILINK_PHASE_4_OWNER_FLEET_ARCHITECTURE.md), [workspace context](../GARILINK_OWNER_WORKSPACE_CONTEXT.md) |
| Auth and verification | [Email-first design](../GARILINK_EMAIL_FIRST_AUTH_SPRINT_2.md), [progressive verification proposal](../GARILINK_PROGRESSIVE_VERIFICATION_AND_HANDOVER_ARCHITECTURE.md) |

In particular, the V2 decision register's proposed rental states are not the implemented rental state machine; the current architecture shows the actual actions. Verification proposals are not an enabled KYC service. Earlier references saying the payment provider is undecided predate the founder's Snippe confirmation; provider confirmation does not establish an implemented checkout or successful charge.

## Historical implementation and certification records

Root-level historical files remain at their original paths to preserve links and provenance. No past report was deleted or silently rewritten as current evidence.

- `GARILINK_SPRINT_*_CERTIFICATION.md`, `GARILINK_SPRINT_*_CI_REPORT.md`, and related fixture/signature reviews record particular sprint checkpoints. Examples: [Sprint 2.4 certification](../GARILINK_SPRINT_2_4_CERTIFICATION.md), [Sprint 3.5 certification](../GARILINK_SPRINT_3_5_CERTIFICATION.md), [Sprint 4.3 certification](../GARILINK_SPRINT_4_3_CERTIFICATION.md).
- [Phase 3 certification](../GARILINK_PHASE_3_CERTIFICATION.md), [Phase 4 certification](../GARILINK_PHASE_4_CERTIFICATION.md), [Phase 4 freeze](../GARILINK_PHASE_4_FREEZE.md), and [Phase 5 handoff](../GARILINK_PHASE_5_HANDOFF.md) describe earlier handoffs, not release approval for new commits.
- `SPRINT_1_MEDIA.md` through the later `SPRINT_*` reports describe earlier implementation passes. [Sprint 5 authentication](../SPRINT_5_AUTHENTICATION.md) and [Sprint 9 infrastructure](../SPRINT_9_INFRASTRUCTURE.md) can contain assumptions superseded by email-first Auth or the Supabase migration.
- [Migration report](../MIGRATION_REPORT.md), [original architecture decisions](../ARCHITECTURE_DECISIONS.md), [original Flutter architecture](../FLUTTER_ARCHITECTURE.md), [Flutter structure](../FLUTTER_STRUCTURE.md), and [Flutter navigation](../FLUTTER_NAVIGATION.md) are retained historical design documents.
- [UI audit](../FINAL_WOW_UI_AUDIT.md), [second-pass audit](../SECOND_PASS_AUDIT.md), and [Android demo QA](../GARILINK_ANDROID_DEMO_QA_2026_09_27.md) preserve earlier observations with their original scope.

## Operations references requiring current verification

[Hosted migration reconciliation](../GARILINK_HOSTED_MIGRATION_RECONCILIATION.md), [backup/restore](../BACKUP_RESTORE_RUNBOOK.md), [production operations](../PRODUCTION_OPERATIONS.md), [release checklist](../RELEASE_CHECKLIST.md), [production readiness](../PRODUCTION_READINESS.md), and [device QA](../DEVICE_QA_CHECKLIST.md) are useful checklists and historical guidance. Their existence does not prove a backup was restored, a deployment matches local migrations, or a real Android device passed testing. Reconcile them with the current handover and authorized environment before executing any operational command.

## Add documentation without losing history

Put maintained architecture documents in `docs/architecture/` and dated audits/evidence in `docs/audits/` or the relevant package's evidence directory. Record the exact commit, environment, command, outcome, and limitations for certification. Label a design proposal explicitly. If an old guide conflicts, add a dated pointer to the replacement while preserving its body; move or remove files only with verified reference updates and a documented reason.
