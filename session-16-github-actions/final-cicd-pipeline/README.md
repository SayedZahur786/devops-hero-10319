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

Honest status: the workflows are written and YAML-validated, and the test suite passes locally. The GitHub Actions runs themselves will execute when this is pushed to the repo (push happens after review, so there are no Actions run links yet).

## Captured output files

| Path | Contents |
|------|----------|
| `app/`, `tests/` | Application + test suite (8 passing tests) |
| `.github/workflows/ci.yml` | CI: lint, test, docker build |
| `.github/workflows/cd.yml` | CD: build + push to GHCR |
| `k8s/` | Kubernetes manifests for the app |
