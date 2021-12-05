.PHONY: build test
build:
	docker-compose build
test:
	./wrapper-inso-service.sh -v -d run/oas -f kong-demo-api.yaml
	./wrapper-inso-service.sh -v -d run/oas -f kong-demo-api-errors.yaml
	

