
.PHONY: plan apply destroy

init:
	AWS_PROFILE=${AWS_PROFILE} cd v1/terraform && terraform init

plan: init
	AWS_PROFILE=${AWS_PROFILE} cd v1/terraform && terraform plan -var-file=config.tfvars

apply: init
	AWS_PROFILE=${AWS_PROFILE} cd v1/terraform && terraform apply -var-file=config.tfvars

destroy:
	AWS_PROFILE=${AWS_PROFILE} cd v1/terraform && terraform destroy -var-file=config.tfvars