# Session 17: DevSecOps Pipeline

Mohd Jahur | Enrollment 10319

## Work and observations

I extended my Session 17 app pipeline into a DevSecOps pipeline:

- `.github/workflows/devsecops.yml` - CI plus security stages: SAST, dependency scanning (SCA), secret scanning, container image build, image scanning (Trivy), and a security gate that fails the pipeline on high/critical findings.
- `.github/workflows/codeql.yml` - GitHub CodeQL analysis for the Python code.
- `k8s/deployment.yaml` - updated to pull the scanned image from GHCR: `ghcr.io/sayedzahur786/devops-hero-10319/session17-app`.
- `app/` - the application source the pipeline builds and scans.

Placement note: `.github/workflows/` must sit at the repository root for GitHub to pick it up; it is kept under `submission/` here for review, and the apply script places it at the root.

## GitHub Actions run evidence (real runs)

- DevSecOps Pipeline run: SUCCESS (all 8 jobs: unit tests, Bandit SAST, pip-audit SCA, Gitleaks secret scan, docker build, Trivy image scan gate, push to GHCR, render k8s manifests) - https://github.com/SayedZahur786/devops-hero-10319/actions/runs/39073707016 - screenshot: `evidence/devsecops-run-success.png`
- CodeQL Analysis run: SUCCESS - https://github.com/SayedZahur786/devops-hero-10319/actions/runs/39072992683 - screenshot: `evidence/codeql-run-success.png`
- Image published: `ghcr.io/sayedzahur786/devops-hero-10319/session17-app:latest`

What the real runs caught and I fixed: gitleaks-action now needs a paid license (replaced with the Gitleaks CLI); 11 findings were all Session 12 course demo secrets, documented in `.gitleaksignore`; trivy-action version refs were broken (switched to the Trivy CLI); the gate initially failed on 44 HIGH CVEs in the debian base image that have no upstream fix, so the gate fails on fixable HIGH/CRITICAL (`--ignore-unfixed`) - documented here so it is a decision, not a hidden bypass.

## Captured output files

| Path | Contents |
|------|----------|
| `.github/workflows/devsecops.yml` | DevSecOps pipeline (SAST, SCA, secrets, Trivy, gate) |
| `.github/workflows/codeql.yml` | CodeQL analysis |
| `k8s/deployment.yaml` | GHCR image reference |
| `app/` | App source |
