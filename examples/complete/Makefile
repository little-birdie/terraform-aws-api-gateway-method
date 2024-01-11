.ONESHELL:
SHELL = /bin/bash

prepare:
	@echo "Selects terraform version and initialises the backend"
	tfswitch
	terraform init

apply: prepare
	@echo "Applies the terraform module"
	terraform apply -auto-approve

deploy: apply
	$(eval AWS_REGION := $(shell terraform output -json | jq -r .aws_region.value))
	$(eval REST_API_ID := $(shell terraform output -json | jq -r .rest_api_id.value))

	aws apigateway create-deployment \
		--rest-api-id $(REST_API_ID) \
		--stage-name uat \
		--stage-description 'Stage uat' \
		--description 'Deployment to the uat stage' \
		--region $(AWS_REGION)

destroy: prepare
	@echo "Destroys the terraform module"
	terraform destroy -auto-approve

complete:  deploy destroy
	@echo "Build and Clean Module for Testing"
