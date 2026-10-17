# Session 16 Mini-Project: Final CI/CD Pipeline (GitHub Actions)

Mohd Jahur | Enrollment 10319

## Work and observations

I built the final CI/CD pipeline project for the course: a small Flask application with a full GitHub Actions pipeline.

- `app/` - Flask app (the same app I containerized in Session 17).
- `tests/` - pytest suite. **8/8 tests pass locally** (`pytest`).
- `Dockerfile` - container image build for the app.
- `.github/workflows/ci.yml` - on every push/PR: install deps, run flake8 lint, run pytest, build the Docker image.
- `.github/workflows/cd.yml` - on push to main: build and push the image to GHCR (`ghcr.io/sayedzahur786/devops-hero-10319/...`).
- `k8s/` - deployment manifests for the built image.

## GitHub Actions run evidence (real runs)

- CI Pipeline run: SUCCESS - https://github.com/SayedZahur786/devops-hero-10319/actions/runs/39072826847 (lint, 8/8 tests, docker build) - screenshot: `evidence/ci-run-success.png`
- CD Pipeline run: SUCCESS - https://github.com/SayedZahur786/devops-hero-10319/actions/runs/39073262938 (image built and pushed to `ghcr.io/sayedzahur786/devops-hero-10319/session16-app:latest`, deploy manifests rendered) - screenshot: `evidence/cd-run-success.png`

Fixed during real runs: GHCR rejects uppercase repository owners, so image tags use the lowercase `sayedzahur786` path.

## Captured output files

| Path | Contents |
|------|----------|
| `app/`, `tests/` | Application + test suite (8 passing tests) |
| `.github/workflows/ci.yml` | CI: lint, test, docker build |
| `.github/workflows/cd.yml` | CD: build + push to GHCR |
| `k8s/` | Kubernetes manifests for the app |
