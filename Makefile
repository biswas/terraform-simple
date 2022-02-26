destroy:|
	terraform destroy
init:|
	terraform init
validate:|
	terraform validate
plan:|
	terraform plan
apply:|
	terraform apply
	
build: destroy init validate plan apply