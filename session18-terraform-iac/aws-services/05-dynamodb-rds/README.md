# 05. DynamoDB and RDS - Database Services

Mohd Jahur | Enrollment 10319

## DynamoDB

### What it is

DynamoDB is AWS's fully managed **NoSQL** key-value/document database. No servers to manage, single-digit millisecond reads at any scale, billed per request (on-demand) or per provisioned capacity.

### NoSQL

NoSQL means no joins, no SQL, no fixed schema per row. You design tables around the exact queries the app makes ("access-pattern-first" design), instead of normalizing and joining later. That is what lets it scale horizontally.

### Tables

A table is the only structure. Items in a table can have different attributes (schemaless apart from the key). You create a table by choosing its key schema; capacity and indexes come after.

### Items

An item is one record, like a row. Max size 400 KB. Example: `{"user_id": "u123", "created_at": "2026-10-18", "name": "Sayed", "plan": "pro"}`.

### Attributes

The fields of an item, like columns, but each item can carry its own set. Types: string, number, binary, bool, list, map, set.

### Partition key

The required part of the primary key. DynamoDB hashes it to decide which physical partition stores the item. A good partition key has many distinct values and even access (e.g. user_id); a hot key (one value getting all traffic) is the classic DynamoDB mistake.

### Sort key

Optional second part of the key. Items with the same partition key are stored together, ordered by the sort key. Enables range queries: "all orders of user u123 between two dates" = partition key user_id, sort key order_date.

### Use cases

- Session stores, shopping carts, user profiles.
- High-traffic apps needing predictable fast reads (gaming, ad tech).
- Serverless backends with Lambda + API Gateway.
- IoT and event data with time-series access patterns.

---

## RDS

### What it is

RDS (Relational Database Service) is managed **SQL** databases: AWS runs the engine, handles patching, backups, failover and read scaling; you use it like a normal database. You do not get root on the host.

### Supported engines

MySQL, PostgreSQL, MariaDB, Oracle, SQL Server, and Amazon Aurora (AWS's own MySQL/PostgreSQL-compatible engine with better performance and storage replication).

### DB instances

A DB instance is the database server: an instance class (e.g. `db.t3.micro`) plus storage (gp3 or io1). It lives in private subnets inside a VPC and is reached through an endpoint (hostname + port).

### Security

- Runs in private subnets; security groups control which app servers can connect (no 0.0.0.0/0 on a database, ever).
- Encryption at rest with KMS, in transit with TLS.
- IAM database authentication as an alternative to passwords.
- Automated backups plus manual snapshots.

### Backups

Automated daily backups + transaction logs give point-in-time restore to any second within the retention window (up to 35 days). Manual snapshots are kept until you delete them. Restoring creates a new instance; you then point the app at it.

### Multi-AZ

A synchronous standby replica in another Availability Zone. On failure (or patching), RDS fails over to the standby automatically - same endpoint, typically 1-2 minutes of downtime. Multi-AZ is for **availability**, not read scaling.

### Read replicas

Asynchronous copies you can read from. Offload reporting and heavy reads from the primary. Can be promoted to a standalone database. Read replicas are for **scaling reads**, not failover.

### Use cases

- Traditional apps that need SQL, joins and transactions (e-commerce, ERP).
- WordPress/Django/Rails backends.
- Anything where the team knows SQL and does not want to run database servers.

---

## DynamoDB vs RDS in one line

If your access patterns are simple key lookups at large scale, pick DynamoDB; if you need SQL, joins and flexible ad-hoc queries, pick RDS.
