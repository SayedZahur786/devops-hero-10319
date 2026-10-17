# GitOps

Mohd Jahur | Enrollment 10319

## What is GitOps?

GitOps is running infrastructure and applications the same way you run code: the desired state of the system lives in a Git repository, and an agent inside the cluster continuously makes reality match the repo. You never kubectl apply by hand in production; you merge a pull request, and the cluster converges.

## Git as the source of truth

The repo holds the complete, versioned description of what should run: manifests, Helm values, Kustomize overlays. Every change is a commit with an author, a review and a diff. Rollback is `git revert`. Audit is `git log`. If the cluster burns down, you point a new one at the same repo.

## Declarative configuration

You declare WHAT you want (2 replicas, this image tag, these resource limits), not the steps to get there. Kubernetes manifests are already declarative; GitOps extends the same idea to the delivery process.

## Continuous reconciliation

An operator in the cluster (Argo CD, Flux) watches both the repo and the live state in a loop:
1. Repo changed -> pull, diff, apply.
2. Live state drifted from the repo (someone scaled a deployment by hand) -> detect drift and revert it (self-heal), or at least report OutOfSync.

## GitOps workflow

Developer pushes change -> CI builds and tests the image -> CI (or a bot) updates the image tag in the config repo -> Argo CD notices the new commit -> syncs the cluster -> reports Synced/Healthy.

## Kubernetes + GitOps

Argo CD runs as a controller in the cluster. An `Application` CR binds a repo path to a destination cluster/namespace with a sync policy. With `automated` sync + `selfHeal`, the manual `kubectl scale` I did in the demo was reverted back to the Git-defined replica count within the reconciliation window - that is continuous reconciliation working.
