
.PHONY: plan apply destroy

init:
	AWS_PROFILE=${AWS_PROFILE} cd v1/terraform && terraform init

plan: init
	AWS_PROFILE=${AWS_PROFILE} cd v1/terraform && terraform plan -var-file=config.tfvars

apply: init
	AWS_PROFILE=${AWS_PROFILE} cd v1/terraform && terraform apply -var-file=config.tfvars

destroy:
	AWS_PROFILE=${AWS_PROFILE} cd v1/terraform && terraform destroy -var-file=config.tfvars

clean:
	AWS_PROFILE=${AWS_PROFILE} cd v1/terraform && rm -rf .terraform/

init-v2:
	AWS_PROFILE=${AWS_PROFILE} cd v2/terraform && terraform init

plan-v2: init
	AWS_PROFILE=${AWS_PROFILE} cd v2/terraform && terraform plan -var-file=config.tfvars

apply-v2: init
	AWS_PROFILE=${AWS_PROFILE} cd v2/terraform && terraform apply -var-file=config.tfvars

destroy-v2:
	AWS_PROFILE=${AWS_PROFILE} cd v2/terraform && terraform destroy -var-file=config.tfvars

clean-v2:
	AWS_PROFILE=${AWS_PROFILE} cd v2/terraform && rm -rf .terraform/