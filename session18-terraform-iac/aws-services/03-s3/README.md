# 03. S3 - Simple Storage Service (Storage)

Mohd Jahur | Enrollment 10319

## What is S3?

S3 is AWS's object storage: unlimited-capacity, 99.999999999% (11 nines) durability, pay for what you store. You store files of any kind and get them back over HTTP(S). It is not a filesystem - there are no real folders, only keys that look like paths.

## Buckets

A bucket is the container for objects. Bucket names are **globally unique across all of AWS** (which is why `mybucket` is taken). Buckets live in a chosen region. Default settings block all public access - you open access deliberately.

## Objects

An object is a file plus its metadata, identified by its key (`reports/2026/sales.pdf`). Max object size is 5 TB; uploads over 100 MB should use multipart upload. Each object gets a URL when public or a presigned URL for temporary private access.

## Storage classes

- **S3 Standard**: hot data, milliseconds access.
- **S3 Standard-IA / One Zone-IA**: infrequent access, cheaper storage, retrieval fee.
- **S3 Glacier Instant / Flexible / Deep Archive**: archive, minutes-to-hours retrieval, cheapest.
- **S3 Intelligent-Tiering**: moves objects between tiers automatically.

## Versioning

Versioning keeps every version of an object. Overwrites and deletes create new versions / delete markers instead of destroying data. Once enabled it cannot be fully disabled, only suspended. It protects against accidental deletes and ransomware.

## Lifecycle policies

Rules that transition or expire objects automatically. Example: move logs to Glacier after 90 days, delete after 1 year. Also used to abort incomplete multipart uploads and clean old versions (versioned buckets grow forever otherwise).

## Encryption

- **At rest**: SSE-S3 (default, AWS-managed keys), SSE-KMS (your KMS keys, audit trail), SSE-C (you supply keys), or client-side encryption.
- **In transit**: HTTPS.

## Bucket policies

Resource-based JSON policies attached to the bucket. They decide who can access the bucket and its objects - for example allow read from a CloudFront distribution only, or deny anything that is not HTTPS. Together with IAM policies and the public-access block, they form the access story. Most S3 leaks in the news = a permissive bucket policy.

## Common use cases

- Static website hosting and asset storage (images, videos, downloads).
- Backups and archives with lifecycle rules.
- Data lakes (analytics on parquet/CSV with Athena).
- Terraform state storage and application logs.
- Presigned upload/download URLs in web apps.
