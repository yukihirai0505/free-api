NAME = "free-api"

.DEFAULT_GOAL := help

# http://postd.cc/auto-documented-makefile/
.PHONY: help
help:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: cross-build
cross-build: ## Go build
	@GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ./docker/main main.go

.PHONY: docker-build
docker-build: cross-build ## Docker build
	@docker build -f docker/Dockerfile -t yukihirai0505/free-api:latest ./docker

.PHONY: docker-run
docker-run: docker-build ## Docker run
	@docker run -p 80:80 -t yukihirai0505/free-api &

.PHONY: docker-stop
docker-stop: ## Docker stop
	@docker ps -q  --filter ancestor=yukihirai0505/free-api | xargs docker stop
