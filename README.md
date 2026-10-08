# k8s-restart-deployments

Restarts Kubernetes deployments across multiple namespaces, one at a time.
Each rollout must complete before the next one starts.

## Usage
1. Edit `TARGETS` in `restart-deployments.sh` (format: `namespace/deployment`)
2. `./restart-deployments.sh`

## Testing locally with kind
1. `./test-setup.sh`
2. Set `TARGETS` to `team-a/web-a` and `team-b/web-b`
3. `./restart-deployments.sh`
4. `./test-cleanup.sh`
