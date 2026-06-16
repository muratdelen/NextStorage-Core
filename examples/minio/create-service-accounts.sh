#!/usr/bin/env sh
set -eu

: "${MINIO_ALIAS:=nextstorage}"
: "${MINIO_ENDPOINT:=http://localhost:9000}"
: "${MINIO_ROOT_USER:=nextlife}"
: "${MINIO_ROOT_PASSWORD:=change_me}"
: "${NEXTDOCS_STORAGE_USER:=svc-nextdocs-storage}"
: "${NEXTDOCS_STORAGE_PASSWORD:=change_me_nextdocs_storage}"

mc alias set "$MINIO_ALIAS" "$MINIO_ENDPOINT" "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD"

mc admin policy create "$MINIO_ALIAS" nextdocs-service-policy ./examples/minio/policies/nextdocs-service-policy.json || true
mc admin user add "$MINIO_ALIAS" "$NEXTDOCS_STORAGE_USER" "$NEXTDOCS_STORAGE_PASSWORD" || true
mc admin policy attach "$MINIO_ALIAS" nextdocs-service-policy --user "$NEXTDOCS_STORAGE_USER"

echo "NextDocs storage service account configured."
