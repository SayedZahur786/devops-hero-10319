# 01. IAM - Identity and Access Management (Governance)

Mohd Jahur | Enrollment 10319

## What is IAM?

IAM (Identity and Access Management) is the AWS service that controls **who** can do **what** in an AWS account. Every API call to AWS is checked against IAM: the caller has to be authenticated (who are you?) and authorized (are you allowed?). IAM itself is free and global (not tied to a region).

## Users

An IAM user is a single identity for one person or one application. It has long-term credentials: a password for the console, and/or access keys for the CLI and APIs. Root should never be used for daily work; the first thing you do in a new account is create IAM users and lock the root away with MFA.

## Groups

A group is a named collection of users. You attach permissions to the group, and every user in it gets them. Example: a `Developers` group with read/write on EC2 and S3, an `Admins` group with full access. Users can be in several groups. Groups cannot be nested.

## Roles

A role is an identity with no long-term credentials. It is **assumed** temporarily by whoever needs it: an EC2 instance, a Lambda function, another AWS account, or a user logging in through SSO. When a role is assumed, AWS hands out short-lived credentials (usually 1 hour). This is the correct way to give an app on EC2 access to S3 - never put access keys on the instance.

## Policies

A policy is a JSON document that lists permissions. The main parts:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "arn:aws:s3:::my-app-bucket/*"
    }
  ]
}
```

- **Effect**: Allow or Deny. An explicit Deny always wins.
- **Action**: the API calls covered.
- **Resource**: which ARNs the actions apply to.

Types: AWS managed policies (maintained by AWS), customer managed policies (yours, reusable), and inline policies (stuck to one identity).

## Permissions

Evaluation logic, in order:
1. Default is **deny** everything.
2. Any explicit **Deny** overrides all Allows.
3. At least one matching **Allow** is required.
4. Permission boundaries and SCPs (organization rules) cap the maximum a policy can grant.

## Least privilege

Give each identity only the permissions it actually needs, nothing more. In practice: start with nothing, add the exact actions on the exact resources the job requires, and review later with IAM Access Analyzer and credential reports. Wide-open `Action: "*", Resource: "*"` on a user or role is the classic breach cause.

## IAM best practices

1. Lock away the root user, enable MFA on it, never use it.
2. MFA on every human user.
3. Use roles for applications and cross-account access, not access keys.
4. Prefer groups over per-user policies.
5. Rotate credentials; remove unused users and keys (credential report).
6. Grant least privilege; scope `Resource` to exact ARNs where possible.
7. Use IAM Access Analyzer to find resources shared externally.

## Common use cases

- Giving each team member their own login with only the access their job needs.
- Letting an EC2 app write to one S3 bucket via an instance role.
- Temporary access for a contractor through an assumable role.
- CI/CD deploy keys with permission to push to one ECR repo and update one ECS service.
