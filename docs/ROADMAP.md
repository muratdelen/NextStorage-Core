# NextStorage Roadmap

NextStorage-Core is the object storage layer of the NextLife platform. It is based on MinIO and provides S3-compatible storage for NextDocs and other modules.

## Architectural position

```text
NextDocs      -> document metadata, lifecycle, OCR and workflow
NextStorage   -> physical object storage, buckets, object policies and storage audit
NextID        -> identity provider
NextRole      -> authorization and policy decisions
NextLog       -> audit and operation logs
NextSearch    -> indexed metadata and OCR search
```

NextStorage must not become a document-management module. It stores objects and enforces storage-level access rules. NextDocs owns document meaning and lifecycle.

## Safety rules

- Do not break the existing MinIO image behavior.
- Keep MinIO upstream licensing and notices intact.
- Start with additive configuration and documentation.
- Do not expose the MinIO root user to applications.
- Use service users and bucket policies for application access.
- Send security and object-operation events to NextLog.

## Phase 0 - Baseline

- Keep the GHCR MinIO distribution working.
- Document required environment variables.
- Define bucket naming and policy rules.
- Define audit event contract.

## Phase 1 - NextLife bucket model

Recommended buckets:

| Bucket | Owner module | Purpose |
|---|---|---|
| `nextdocs-originals` | NextDocs | Original uploaded files |
| `nextdocs-derived` | NextDocs | OCR text, thumbnails and previews |
| `nextdocs-archive` | NextDocs | Long-term archived files |
| `nextlife-temp` | Platform | Temporary upload handoff |
| `nextlife-backups` | Platform | Backups and exports |

## Phase 2 - Access control

Access must be role and policy based.

Rules:

- Users do not directly use MinIO root credentials.
- Applications use short-lived or scoped credentials.
- NextDocs checks document-level permission before requesting object access.
- NextStorage enforces bucket/object-level policies.
- Every denied access attempt must be logged.

## Phase 3 - NextLog audit

NextStorage sends audit events for:

- bucket created
- bucket policy changed
- object uploaded
- object downloaded
- object deleted
- object copied
- object version restored
- object retention changed
- access denied
- root credential usage detected

## Phase 4 - NextRole integration

Initial implementation can read roles from NextID claims. Later, NextStorage asks NextRole for policy decisions.

Required roles:

- NEXTSTORAGE_ADMIN
- NEXTSTORAGE_OPERATOR
- NEXTSTORAGE_SERVICE
- NEXTSTORAGE_AUDITOR
- NEXTSTORAGE_READONLY

## Phase 5 - Production hardening

- Enable TLS.
- Enable bucket versioning for critical buckets.
- Enable object retention for archive buckets.
- Define backup and replication policy.
- Rotate credentials.
- Disable direct public bucket access.
- Monitor storage usage and quotas.
