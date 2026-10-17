# Session 18: Terraform IaC - Submission Notes

Mohd Jahur | Enrollment 10319

## Work and observations

**Task 1 - terraform-s3-demo:** I ran the full Terraform workflow for real: `init`, `fmt`, `validate`, `plan`, `apply` (3 resources added: S3 bucket, versioning, public-access block), `show`, `output`, and `destroy`. Every command's output is captured in `terraform-s3-demo/logs/`.

Honest note: I do not have an AWS account for this course, so the provider was pointed at a local AWS-compatible API (moto) via `local_override.tf`. The Terraform workflow, state handling, plan/apply cycle and outputs are real; the API endpoint is local, not AWS. `terraform.tfvars`, plan and apply logs are included so the difference is visible, not hidden.

**Task 2 - aws-services:** written documentation of five core AWS services with use cases and how they relate: `aws-services/01-iam` ... `05-dynamodb-rds`.

## Captured output files

| Path | Contents |
|------|----------|
| `terraform-s3-demo/logs/01-init.log` ... `08-destroy.log` | Real output of each Terraform step |
| `terraform-s3-demo/logs/apply-output.png` | Rendered from the real apply log |
| `terraform-s3-demo/main.tf`, `variables.tf`, `outputs.tf`, `provider.tf`, `local_override.tf` | Project code |
| `aws-services/01-iam` ... `05-dynamodb-rds` | Task 2 documentation |
