# Aqua IaC Scanning Demo

Every file here is **intentionally misconfigured** to generate findings. Nothing is built or deployed.

| Folder | Type |
|---|---|
| `terraform/` | Terraform HCL (plan JSON generated in CI into `terraform-plan/`) |
| `cloudformation/` | AWS CloudFormation |
| `kubernetes/` | Kubernetes manifests |
| `kustomize/` | Kustomize |
| `helm/` | Helm chart |
| `docker/` | Dockerfile |
| `arm/` | Azure ARM template |

## Setup
1. Add repo secrets `AQUA_KEY` and `AQUA_SECRET` (Settings → Secrets and variables → Actions).
2. Push to `main` or run the workflow manually.
3. View results in Aqua → Supply Chain Security, or from the CLI:

```bash
export AQUA_KEY=... AQUA_SECRET=...
./scripts/get-iac-results.sh
```
