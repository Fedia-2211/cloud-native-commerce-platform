# Security Setup Guide

## Grafana Admin Secret

The Grafana admin password is now managed securely via Kubernetes Secrets instead of hardcoded values.

### Setup Instructions

Before deploying, create the Grafana admin secret:

```bash
# Create namespace if it doesn't exist
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

# Create the Grafana admin secret with a strong password
kubectl create secret generic grafana-admin-secret \
  --namespace monitoring \
  --from-literal=password=$(openssl rand -base64 32) \
  --dry-run=client -o yaml | kubectl apply -f -
```

Or use your own password:

```bash
kubectl create secret generic grafana-admin-secret \
  --namespace monitoring \
  --from-literal=password=YOUR_SECURE_PASSWORD_HERE \
  --dry-run=client -o yaml | kubectl apply -f -
```

### Retrieve Your Grafana Password

```bash
kubectl get secret grafana-admin-secret -n monitoring -o jsonpath='{.data.password}' | base64 --decode
```

### Environment Variables (Optional)

For automated deployments, use environment variables:

```bash
export GRAFANA_PASSWORD=$(openssl rand -base64 32)

kubectl create secret generic grafana-admin-secret \
  --namespace monitoring \
  --from-literal=password=$GRAFANA_PASSWORD
```

---

## Other Sensitive Data

- **AWS Credentials**: Use GitHub Secrets (✅ Already configured in `.github/workflows/ci-cd.yml`)
- **Database Passwords**: Use `terraform.tfvars` (✅ Already in `.gitignore`)
- **SSH Keys**: All `.pem` and `.key` files (✅ Already in `.gitignore`)
- **Kubernetes Secrets**: Never commit secret YAMLs (✅ Properly referenced as Kubernetes Secrets)

---

## Before Every Public Push

1. ✅ Run `gitleaks` to scan for secrets:
   ```bash
   gitleaks detect --verbose
   ```

2. ✅ Check `.gitignore` is protecting sensitive files

3. ✅ Verify no hardcoded passwords in YAML/JSON/Terraform files
