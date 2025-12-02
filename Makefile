.PHONY: oci-build oci-up oci-shell oci-down

oci-build:
	@echo "Building OCI Docker image..."
	docker compose -f oci/docker-compose.dev.yaml build
	@echo "OCI Docker image built."

oci-up:
	@echo "Bringing up OCI resources..."
	docker compose -f oci/docker-compose.dev.yaml up -d
	@echo "OCI resources are up."

oci-down:
	@echo "Tearing down OCI resources..."
	docker compose -f oci/docker-compose.dev.yaml down
	@echo "OCI resources are down."

oci-shell:
	@echo "Opening shell in OCI container..."
	docker compose -f oci/docker-compose.dev.yaml exec mydas bash

.PHONY: mydas-up mydas-makemigrations mydas-migrate

mydas-makemigrations:
	$(call oci_command,bash -c 'python manage.py makemigrations')

mydas-migrate:
	$(call oci_command,bash -c 'python manage.py migrate')

mydas-up:
	@echo "MyDAS Django dev environment is up and running."
	docker compose -f oci/docker-compose.dev.yaml exec mydas bash -c 'python manage.py runserver 0.0.0.0:8080'

define oci_command
	@echo "Running command in OCI container..."
	docker compose -f oci/docker-compose.dev.yaml exec mydas $(1)
endef