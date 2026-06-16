ARG MINIO_IMAGE=minio/minio:latest
FROM ${MINIO_IMAGE}

LABEL org.opencontainers.image.title="NextStorage Core"
LABEL org.opencontainers.image.description="NextLife object storage server image based on MinIO"
LABEL org.opencontainers.image.source="https://github.com/muratdelen/NextStorage-Core"
LABEL org.opencontainers.image.vendor="NextLife"
