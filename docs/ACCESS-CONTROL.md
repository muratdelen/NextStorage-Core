# NextStorage Access Control

This document defines the first NextLife access-control model for NextStorage.

## Core principle

NextStorage stores files. It does not decide document business meaning. NextDocs, NextRole and NextID decide who is allowed to perform a business action. NextStorage must still enforce bucket and object level controls to prevent direct unauthorized access.

## Identity sources

| Source | Usage |
|---|---|
| NextID | User identity and token claims |
| NextRole | Central authorization and policy decisions |
| NextDocs | Document ownership, lifecycle and sharing rules |
| NextLog | Audit trail for allowed and denied operations |

## Roles

```text
NEXTSTORAGE_ADMIN
NEXTSTORAGE_OPERATOR
NEXTSTORAGE_SERVICE
NEXTSTORAGE_AUDITOR
NEXTSTORAGE_READONLY
```

### Role meanings

| Role | Meaning |
|---|---|
| NEXTSTORAGE_ADMIN | Full storage administration |
| NEXTSTORAGE_OPERATOR | Bucket and object operations without root access |
| NEXTSTORAGE_SERVICE | Service-to-service access for modules such as NextDocs |
| NEXTSTORAGE_AUDITOR | Read audit metadata and storage reports |
| NEXTSTORAGE_READONLY | Read-only object access where policy allows |

## Application access model

Applications must not use root credentials.

Recommended service accounts:

| Service account | Used by | Scope |
|---|---|---|
| `svc-nextdocs-storage` | NextDocs | nextdocs buckets only |
| `svc-nextbackup-storage` | Backup jobs | backup buckets only |
| `svc-nextsearch-storage` | NextSearch indexing jobs | derived text and allowed read paths |

## Bucket policy model

Recommended bucket separation:

```text
nextdocs-originals
nextdocs-derived
nextdocs-archive
nextlife-temp
nextlife-backups
```

### Rules

- `nextdocs-originals`: no public read, no anonymous write.
- `nextdocs-derived`: no public read unless explicitly published by an application.
- `nextdocs-archive`: versioning and retention should be enabled.
- `nextlife-temp`: short lifecycle expiration.
- `nextlife-backups`: restricted to backup service accounts.

## Permission flow

```text
User -> NextID login -> NextDocs action request
     -> NextDocs checks document permission
     -> NextDocs requests object operation using service identity
     -> NextStorage enforces bucket/object policy
     -> NextStorage/NextDocs sends audit event to NextLog
```

## Direct user access

Direct browser access to MinIO Console must be restricted to storage admins and auditors.

Normal users should access files through NextDocs, not through the MinIO Console.

## Deny-by-default rule

If policy cannot be evaluated, access must be denied except for explicitly configured internal fail-open health checks.

## Emergency access

Root credentials are for break-glass administration only.

Root usage must be logged as a security event:

```text
storage.root_credential_used
```
