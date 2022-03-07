# terraform-simple
[![terraform plan](https://github.com/biswas/terraform-simple/actions/workflows/terraform_ci.yml/badge.svg)](https://github.com/biswas/terraform-simple/actions/workflows/terraform_ci.yml)

Simple IaC with `terraform` to create AWS `Lambda` function that logs current time on `CloudWatch` when triggered from `Lambda` console.
Current version of CI/CD workflow with `GitHub Actions` builds all required resources and immediately destroys them before the `Lambda` can be triggered. Refer to `Makefile` and use commands other than `terraform destroy` for persistence of resources.

## References
 - List of all resources and data sources supported by provider `hashicorp/aws`: <https://registry.terraform.io/providers/hashicorp/aws/latest/docs>
