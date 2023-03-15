
.PHONY: plan apply destroy

init:
	AWS_PROFILE=${AWS_PROFILE} cd v1/terraform && terraform init

plan: init
	AWS_PROFILE=${AWS_PROFILE} cd v1/terraform && terraform plan -var-file=config.tfvars -var="external_vpc_id=$(external_vpc_id)" -var="external_public_subnet_id=$(external_public_subnet_id)"

apply: init
	AWS_PROFILE=${AWS_PROFILE} cd v1/terraform && terraform apply -var-file=config.tfvars -var="external_vpc_id=$(external_vpc_id)" -var="external_public_subnet_id=$(external_public_subnet_id)"

destroy:
	AWS_PROFILE=${AWS_PROFILE} cd v1/terraform && terraform destroy -var-file=config.tfvars

clean:
	AWS_PROFILE=${AWS_PROFILE} cd v1/terraform && rm -rf .terraform/