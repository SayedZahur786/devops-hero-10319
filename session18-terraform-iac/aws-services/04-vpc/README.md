# 04. VPC - Virtual Private Cloud (Networking)

Mohd Jahur | Enrollment 10319

## What is VPC?

A VPC is your own isolated virtual network inside AWS. You choose the IP range, carve it into subnets, and decide what can talk to what. Every EC2 instance, RDS database, and Lambda (optionally) runs inside a VPC. Each account gets a default VPC; serious work uses a custom one.

## CIDR

The VPC's IP range in CIDR notation, e.g. `10.0.0.0/16` (65,536 addresses). Subnets take slices of it, like `10.0.1.0/24` (256 addresses). Ranges cannot overlap with networks you peer or VPN to, so plan them. AWS reserves 5 addresses in every subnet (network, VPC router, DNS, future use, broadcast).

## Subnets

A subnet lives in one Availability Zone. Split your VPC across at least two AZs for high availability. A subnet is "public" or "private" purely based on its route table: if it has a route to an internet gateway, it is public.

## Route tables

Each subnet is associated with one route table that says where traffic goes. Typical public route table: `10.0.0.0/16 -> local`, `0.0.0.0/0 -> igw`. Typical private one: `10.0.0.0/16 -> local`, `0.0.0.0/0 -> nat-gateway`.

## Internet Gateway

The IGW is the VPC component that connects it to the internet. One per VPC. Public subnets route `0.0.0.0/0` to it. Without an IGW route, a public IP alone does not make an instance reachable.

## NAT Gateway

Lets instances in **private** subnets make outbound internet calls (updates, API calls) without being reachable inbound. It sits in a public subnet with an Elastic IP; private route tables point `0.0.0.0/0` at it. Billed hourly plus data - often the surprise line item.

## Security Groups

Instance-level stateful firewall (covered in the EC2 notes): allow rules only, inbound + outbound, stateful return traffic. Attached to the resource (ENI).

## Network ACLs

Subnet-level stateless firewall. Rules are numbered and evaluated in order, and support both allow and **deny**. Stateless means you must allow both request and return traffic (ephemeral ports 1024-65535) explicitly. Default NACL allows everything; custom ones deny everything until you add rules.

## Public vs private subnet

- **Public**: route to IGW. For load balancers, bastion hosts, NAT gateways.
- **Private**: no IGW route. For app servers, databases - anything that should never be directly reachable from the internet. Standard 3-tier layout: public subnets (LB) -> private subnets (app) -> isolated subnets (DB).

## Common use cases

- Isolating production, staging and dev into separate VPCs or subnets.
- Keeping databases off the internet entirely.
- Hybrid cloud: VPN or Direct Connect from the office into the VPC.
- Segmentation: separate SG/NACL rules per tier.
