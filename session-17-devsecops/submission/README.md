# Session 17: DevSecOps Pipeline

Mohd Jahur | Enrollment 10319

## Work and observations

I extended my Session 17 app pipeline into a DevSecOps pipeline:

- `.github/workflows/devsecops.yml` - CI plus security stages: SAST, dependency scanning (SCA), secret scanning, container image build, image scanning (Trivy), and a security gate that fails the pipeline on high/critical findings.
- `.github/workflows/codeql.yml` - GitHub CodeQL analysis for the Python code.
- `k8s/deployment.yaml` - updated to pull the scanned image from GHCR: `ghcr.io/sayedzahur786/devops-hero-10319/session17-app`.
- `app/` - the application source the pipeline builds and scans.

Placement note: `.github/workflows/` must sit at the repository root for GitHub to pick it up; it is kept under `submission/` here for review, and the apply script places it at the root.

Honest status: all workflow YAML is validated, but no workflow run exists yet - Actions will run for real when this is pushed to GitHub.

## Captured output files

| Path | Contents |
|------|----------|
| `.github/workflows/devsecops.yml` | DevSecOps pipeline (SAST, SCA, secrets, Trivy, gate) |
| `.github/workflows/codeql.yml` | CodeQL analysis |
| `k8s/deployment.yaml` | GHCR image reference |
| `app/` | App source |
