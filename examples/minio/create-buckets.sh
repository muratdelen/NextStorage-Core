#!/usr/bin/env sh
set -eu

: "${MINIO_ALIAS:=nextstorage}"
: "${MINIO_ENDPOINT:=http://localhost:9000}"
: "${MINIO_ROOT_USER:=nextlife}"
: "${MINIO_ROOT_PASSWORD:=change_me}"

mc alias set "$MINIO_ALIAS" "$MINIO_ENDPOINT" "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD"

mc mb --ignore-existing "$MINIO_ALIAS/nextdocs-originals"
mc mb --ignore-existing "$MINIO_ALIAS/nextdocs-derived"
mc mb --ignore-existing "$MINIO_ALIAS/nextdocs-archive"
mc mb --ignore-existing "$MINIO_ALIAS/nextlife-temp"
mc mb --ignore-existing "$MINIO_ALIAS/nextlife-backups"

mc version enable "$MINIO_ALIAS/nextdocs-originals"
mc version enable "$MINIO_ALIAS/nextdocs-derived"
mc version enable "$MINIO_ALIAS/nextdocs-archive"
mc version enable "$MINIO_ALIAS/nextlife-backups"

mc anonymous set none "$MINIO_ALIAS/nextdocs-originals"
mc anonymous set none "$MINIO_ALIAS/nextdocs-derived"
mc anonymous set none "$MINIO_ALIAS/nextdocs-archive"
mc anonymous set none "$MINIO_ALIAS/nextlife-temp"
mc anonymous set none "$MINIO_ALIAS/nextlife-backups"

echo "NextStorage buckets created and locked down."
