.PHONY: help
.DEFAULT_GOAL := help

help:
	@echo "---------------------------------------------------------------------------------------"
	@echo ""
	@echo "				CLI"
	@echo ""
	@echo "---------------------------------------------------------------------------------------"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Development

build: ## Build the project
	@scripts/common.sh no_ci_build

full-build: ## Full build the project
	@scripts/common.sh full_build

##@ Releasing

version: ## Get the current version
	@scripts/before_ci.sh

release: ## Release the Project
	@read -p "Sonatype Password: " passwd; \
	@scripts/common.sh deploy

##@ GPG Key

gpg-generate: ## Generate new GPG key
	gpg --full-generate-key
gpg-export: ## Export GPG Key
	cd ${HOME}/.gnupg && \
	gpg --export-secret-keys -o secring.gpg
gpg-publish: ## Publish GPG to keyserver
	gpg -K
	@read -p "Gpg Key Id: " keyId; \
	gpg --send-keys --keyserver keyserver.ubuntu.com $${keyId}