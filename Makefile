# kpm-selfhosted — operator docs + manifests (no Go build).

.DEFAULT_GOAL := help

.PHONY: help release-check

help:
	@echo "kpm-selfhosted — make targets"
	@echo ""
	@echo "  make release-check         VERSION, README badge, CHANGELOG section (pre-tag)."
	@echo ""
	@echo "  Application tests: clone https://github.com/hrodrig/kpm and run make release-check"
	@echo ""

release-check:
	@chmod +x testing/scripts/release-check.sh
	@testing/scripts/release-check.sh
