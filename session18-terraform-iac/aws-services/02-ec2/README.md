# 02. EC2 - Elastic Compute Cloud (Compute)

Mohd Jahur | Enrollment 10319

## What is EC2?

EC2 is AWS's virtual server service. You rent virtual machines (instances) by the second, pick the OS and size, and AWS runs them on its hardware. You get full root access and can install anything.

## AMI

An AMI (Amazon Machine Image) is the template an instance boots from: OS + optional preinstalled software + disk layout. AWS publishes Amazon Linux and Ubuntu AMIs; you can also build your own AMI from a configured instance and reuse it (the base of auto scaling and golden images).

## Instance types

The size family of the VM, named like `t3.micro` or `m5.large`:
- **t (burstable)**: cheap, baseline CPU with burst credits. Good for dev and low-traffic apps.
- **m (general purpose)**: balanced CPU/RAM.
- **c (compute optimized)**: more CPU per rupee, for CPU-heavy work.
- **r/x (memory optimized)**: big RAM, for caches and in-memory DBs.
- **g/p (GPU)**: ML and graphics.

`t2.micro` / `t3.micro` are the free-tier sizes used for learning.

## Key pairs

SSH access to Linux instances uses a key pair: AWS keeps the public key on the instance, you keep the `.pem` private key. Connect with `ssh -i key.pem ec2-user@<ip>`. Losing the pem file means losing access (no password reset by default).

## Security Groups

A security group is a stateful virtual firewall attached to the instance. It has inbound and outbound rules: protocol, port range, source/destination CIDR or another SG. Default: all inbound denied, all outbound allowed. Stateful means return traffic is allowed automatically. Typical web server: allow 22 (SSH, your IP), 80 and 443 from 0.0.0.0/0.

## EBS

EBS (Elastic Block Store) is the network-attached disk for EC2. Volumes persist independently of the instance (if "delete on termination" is off). Types: gp3 (general SSD), io2 (fast provisioned IOPS), st1/sc1 (HDD). You can snapshot a volume to S3 and resize it live.

## Public vs private IP

- **Private IP**: from the VPC range, always present, only reachable inside the VPC.
- **Public IP**: optional, changes on stop/start unless it is an **Elastic IP** (a static public IP you own and attach).
- Instances in a private subnet get no public IP and reach the internet through a NAT gateway.

## Instance lifecycle

`pending -> running -> stopping -> stopped -> terminated` (plus `rebooting`). Stopped instances keep their EBS and can be restarted (billing for compute stops, EBS still billed). Terminated instances are gone; EBS is deleted if delete-on-termination is set (default for root).

## Common use cases

- Web/app servers and APIs.
- Bastion (jump) hosts into private subnets.
- Batch and cron workers.
- Self-managed databases or tools you cannot get as a managed service.
- Learning Linux administration with full root control.
