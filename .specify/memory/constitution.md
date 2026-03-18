<!--
SYNC IMPACT REPORT
==================
Version change: (uninitialised template) → 1.0.0
Bump rationale: MINOR — initial population of all principles and governance rules; no prior version exists.

Modified principles:
  (none — first adoption)

Added sections:
  I.   Rails Architecture
  II.  Database Integrity
  III. Test-First Development (NON-NEGOTIABLE)
  IV.  Code Quality
  V.   Naming Conventions
  CI/CD Pipeline
  Development Workflow
  Governance

Templates reviewed:
  ✅ .specify/templates/plan-template.md
       Constitution Check gate section is a dynamic placeholder filled per plan — no changes needed.
  ✅ .specify/templates/spec-template.md
       No Rails-specific mandatory sections conflict; spec structure is language-agnostic and compatible.
  ⚠  .specify/templates/tasks-template.md
       Line 11 states "Tests are OPTIONAL — only include them if explicitly requested".
       This CONFLICTS with Principle III (TDD-first, tests MUST be written before implementation).
       Recommended fix: update tasks-template.md to mark test tasks as MANDATORY for all new
       models, operations, services, workers, policies, and API endpoints.
  ✅ .specify/templates/agent-file-template.md
       Generic template; no outdated principle references found.

Deferred TODOs:
  None — all placeholders resolved.
-->

# Hotwire Kanban Board Constitution

## Core Principles

### I. Rails Architecture

All code MUST follow default Ruby on Rails best practices and conventions. This
includes RESTful resource design, the MVC pattern, ActiveRecord for persistence,
and the Rails module/autoloading namespace conventions. Deviations require
explicit justification documented in the feature plan's Complexity Tracking
table.

- Convention over configuration MUST be the default stance.
- No custom abstractions MUST be introduced unless Rails conventions are
  provably insufficient for the requirement.
- Operations (service objects) are permitted and follow the `Namespace::Action`
  pattern (see Principle V).

### II. Database Integrity

Every database migration MUST pass both `strong_migrations` and
`database_consistency` checks before it is merged.

- `strong_migrations`: prevents locking, unsafe column renames, and other
  operations that cause downtime or data loss.
- `database_consistency`: enforces alignment between ActiveRecord validations,
  database constraints, and associations.
- Migrations that cannot satisfy these checks MUST be restructured (e.g., via
  batched backfills or multi-step migrations) rather than bypassing the checks.
- CI MUST run `database_consistency` as a blocking gate (see CI/CD Pipeline).

### III. Test-First Development (NON-NEGOTIABLE)

Tests MUST be written BEFORE the implementation they cover. The Red-Green-Refactor
cycle is strictly enforced:

1. Write a failing spec (Red).
2. Obtain approval to proceed.
3. Write the minimum implementation to pass (Green).
4. Refactor without breaking tests (Refactor).

**Scope**: Every new model, operation, service, worker, policy, and API endpoint
MUST have corresponding specs. Coverage MUST meet the minimum threshold enforced
by SimpleCov; the threshold is configured in `.simplecov` and MUST NOT be lowered
without a constitution amendment.

**Toolchain** (all MUST be present and configured):

| Concern | Tool |
| --- | --- |
| Framework | RSpec + rspec-rails |
| Test data | FactoryBot + FFaker (no fixtures for dynamic data; JSON fixtures only for static payloads) |
| Model assertions | shoulda-matchers |
| N+1 detection | bullet gem (enabled in test environment) |
| HTTP isolation | WebMock (globally enabled; no real HTTP in tests) |
| DB cleanup | database_cleaner-active_record (transaction strategy) |
| Query counting | rspec-sqlimit (performance-sensitive paths) |
| Coverage | SimpleCov (minimum threshold enforced) |

**Spec structure** MUST mirror `app/` exactly (e.g., `app/models/user.rb` →
`spec/models/user_spec.rb`).

### IV. Code Quality

All Ruby code MUST pass RuboCop with the following active plugins:

- `rubocop-rails`
- `rubocop-rspec`
- `rubocop-rspec_rails`
- `rubocop-factory_bot`

**Non-negotiable configuration baselines**:

- Max line length: **120 characters** (`Layout/LineLength: Max: 120`).
- `RSpec/ExampleLength` max: **10 lines**.
- All new cops MUST be enabled by default; opt-out requires inline comment with
  justification.

RuboCop MUST be a blocking CI gate. No PR may be merged with outstanding
violations.

### V. Naming Conventions

All contributors MUST follow these naming rules consistently:

| Artefact | Convention | Example |
| --- | --- | --- |
| Operations (service objects) | `Namespace::Action` | `Users::Create`, `Boards::Archive` |
| Background workers | `*Worker` suffix | `DiariesFeedbacks::SendToTgWorker` |
| Policy objects | `*Policy` suffix | `BoardPolicy`, `CardPolicy` |
| Entity objects | `*Entity` suffix | `UserEntity`, `CardEntity` |
| Factories | Match model name exactly; use traits and sequences | `factory :user`, `trait :admin` |

Factories MUST use traits for variant states and sequences for unique attributes.
Hardcoded unique values in factories are forbidden.

## CI/CD Pipeline

Every CI run MUST execute the following gates in order; all MUST pass for a PR
to be mergeable:

1. `bundle exec rspec` — full test suite with SimpleCov coverage check.
2. `bundle exec rubocop` — zero violations.
3. `bundle exec bundler-audit check --update` — no known CVEs in dependencies.
4. `bundle exec database_consistency` — no model/DB mismatches.

No gate may be skipped or bypassed (`--no-verify`, inline disable without
justification, etc.).

## Development Workflow

- Branch off `main`; name branches `###-short-description`.
- Every feature MUST have a spec written and failing before implementation
  begins (Principle III).
- Migrations are reviewed against Principles II before PR approval.
- PRs MUST NOT lower SimpleCov thresholds or add RuboCop inline disables without
  a constitution-level justification comment in the PR description.
- `database_consistency` output MUST be clean locally before pushing.

## Governance

This constitution supersedes all other implicit practices. Any contradiction
between a team norm and this document is resolved in favour of this document
until an amendment is ratified.

**Amendment procedure**:

1. Open a PR with the proposed change to `.specify/memory/constitution.md`.
2. State the version bump (MAJOR / MINOR / PATCH) and rationale.
3. Update the Sync Impact Report comment at the top of the file.
4. Propagate any changes to dependent templates (`.specify/templates/`).
5. Obtain at least one peer review and approval before merging.

**Versioning policy** (semantic):

- MAJOR: backward-incompatible governance change, principle removal, or
  redefinition that invalidates existing compliant code.
- MINOR: new principle or section added, or materially expanded guidance.
- PATCH: clarification, wording, or typo fix with no semantic change.

**Compliance review**: CI gates (Principle IV + CI/CD Pipeline section) provide
continuous automated compliance. Manual review occurs during PR code review.

**Runtime guidance**: See `CLAUDE.md` (if present) for agent-specific development
guidance that supplements this constitution.

**Version**: 1.0.0 | **Ratified**: 2026-03-17 | **Last Amended**: 2026-03-17
