# kpm-selfhosted — operator docs + manifests (no Go build).

.DEFAULT_GOAL := help

.PHONY: help release-check helm-lint

help:
	@echo "kpm-selfhosted — make targets"
	@echo ""
	@echo "  make release-check         VERSION, README badge, CHANGELOG section (pre-tag)."
	@echo "  make helm-lint             helm lint + template for daemon and cronjob shapes."
	@echo ""
	@echo "  Application tests: clone https://github.com/hrodrig/kpm and run make release-check"
	@echo ""

helm-lint:
	helm lint run/kubernetes/helm/kpm --set secrets.existingSecret=kpm-secrets
	helm template kpm run/kubernetes/helm/kpm --namespace kpm --set secrets.existingSecret=kpm-secrets >/dev/null
	helm lint run/kubernetes/helm/kpm --set sampler=cronjob --set server.enabled=false
	helm template kpm run/kubernetes/helm/kpm --namespace kpm --set sampler=cronjob --set server.enabled=false >/dev/null

release-check:
	@chmod +x testing/scripts/release-check.sh
	@testing/scripts/release-check.sh
