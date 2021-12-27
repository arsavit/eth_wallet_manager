.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: test
test: ## run tests
	go test ./app/...


.PHONY: run
run: ## run app
	go run ./app/src/main.go


.PHONY: lint
lint: ## run pre-commit
	pre-commit run -a


.PHONY: build
build: ## build app > ./build/app
	go build -o ./build/app ./app/src/main.go


.PHONY: test_in_docker
test_in_docker: ## run tests in docker
	docker-compose build dev
	docker-compose run --rm dev go test ./app/...


.PHONY: run_in_docker
run_in_docker: ## run app in docker
	docker-compose up --build --remove-orphans --abort-on-container-exit -t 0 app


.PHONY: lint_in_docker
lint_in_docker: ## run pre-commit in docker
	docker-compose build dev
	docker-compose run --rm dev pre-commit run -a


.PHONY: down
down: ## Stop development environment
	docker-compose down --remove-orphans -t 0
