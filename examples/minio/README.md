# NextStorage MinIO Setup Examples

These examples show the first safe setup model for NextStorage buckets, service accounts and policies.

## Order

1. Start NextStorage / MinIO.
2. Create required buckets.
3. Enable versioning for critical buckets.
4. Create scoped service accounts.
5. Apply bucket policies.
6. Configure NextDocs to use the scoped service account.
7. Configure NextLog audit forwarding.

## Buckets

```text
nextdocs-originals
nextdocs-derived
nextdocs-archive
nextlife-temp
nextlife-backups
```

## Do not use root credentials in applications

Root credentials are only for initial setup and emergency administration. NextDocs must use a scoped service account such as:

```text
svc-nextdocs-storage
```

## Local setup

Use the scripts in this directory as a starting point. They are examples and should be reviewed before production use.
