# NextStorage-Core

NextStorage-Core is the NextLife platform object storage distribution.

It republishes the official MinIO container image under the NextLife GHCR
namespace so deployments can use a consistent NextLife image source:

```text
ghcr.io/muratdelen/nextstorage-core:latest
```

## Upstream

- Project: [MinIO](https://github.com/minio/minio)
- Official image: [minio/minio](https://hub.docker.com/r/minio/minio)
- License: GNU Affero General Public License v3.0 (AGPL-3.0)

This repository does not replace or relicense MinIO. MinIO copyright,
license, source availability and attribution requirements continue to apply.
See [UPSTREAM.md](./UPSTREAM.md).

## NextLife Usage

NextStorage provides S3-compatible object storage for NextDocs and other
NextLife modules. Authentication and authorization integrations will be
coordinated through NextID and NextRole.

The image keeps the standard MinIO entrypoint and command:

```bash
docker run --rm \
  -p 9000:9000 \
  -p 9001:9001 \
  -e MINIO_ROOT_USER=nextlife \
  -e MINIO_ROOT_PASSWORD=change_me \
  ghcr.io/muratdelen/nextstorage-core:latest \
  server /data --console-address ":9001"
```

Persistent deployments must mount `/data` to durable storage.

## Image Publishing

GitHub Actions copies the configured official upstream MinIO image to:

- `ghcr.io/muratdelen/nextstorage-core:latest`
- `ghcr.io/muratdelen/nextstorage-core:git-<commit>`

No upstream source files or license notices are deleted or modified.
