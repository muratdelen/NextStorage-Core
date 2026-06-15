# NextStorage Audit Event Contract

This document defines the first NextLog audit contract for NextStorage.

## Event envelope

```json
{
  "eventId": "uuid",
  "module": "nextstorage",
  "action": "storage.object.uploaded",
  "result": "success",
  "actorUserId": "nextid-sub-or-service-id",
  "actorUsername": "username-or-service-account",
  "serviceAccount": "svc-nextdocs-storage",
  "bucket": "nextdocs-originals",
  "objectKey": "tenant/unit/document-id/file.pdf",
  "objectVersion": "version-id",
  "requestId": "request-id",
  "timestamp": "2026-06-15T00:00:00Z",
  "ipAddress": "127.0.0.1",
  "userAgent": "client-or-service",
  "details": {}
}
```

## Required fields

| Field | Description |
|---|---|
| eventId | Unique event id |
| module | Always `nextstorage` |
| action | Storage action name |
| result | `success`, `failure`, `denied`, `error` |
| actorUserId | NextID user id or service id |
| actorUsername | Username or service account |
| serviceAccount | Service account used for storage operation |
| bucket | Bucket name |
| objectKey | Object key when available |
| objectVersion | Object version when available |
| requestId | Request correlation id |
| timestamp | UTC event time |
| ipAddress | Request source IP |
| userAgent | Client user agent |
| details | Extra structured data |

## Actions

```text
storage.bucket.created
storage.bucket.deleted
storage.bucket.policy_changed
storage.bucket.versioning_enabled
storage.bucket.retention_changed
storage.object.uploaded
storage.object.downloaded
storage.object.deleted
storage.object.copied
storage.object.metadata_changed
storage.object.version_restored
storage.object.retention_changed
storage.access.denied
storage.credential.created
storage.credential.revoked
storage.root_credential_used
storage.quota.exceeded
```

## Result values

```text
success
failure
denied
error
```

## Sensitive data rule

Do not send object contents, document full text, raw file bytes or secrets to NextLog.

Allowed:

```json
{
  "mimeType": "application/pdf",
  "size": 524288,
  "documentId": "DOC-2026-00001"
}
```

Not allowed:

```json
{
  "fileContent": "base64-file-content",
  "accessKey": "secret-access-key",
  "secretKey": "secret-secret-key"
}
```

## Delivery rule

NextStorage audit delivery must be fail-open for object storage availability but must log local delivery failures.

If NextLog is down:

- Storage operation may continue if policy allowed it.
- Delivery failure is written to local logs.
- Retriable delivery can be added later through NextEventBus.

## Correlation with NextDocs

When NextDocs triggers storage operations, it should pass:

```text
documentId
processId
requestId
actorUserId
actorUsername
```

NextStorage includes these values in `details` so NextLog can connect document and storage events.
