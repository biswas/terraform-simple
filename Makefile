init:|
	terraform init
validate:|
	terraform validate
plan:|
	terraform plan
apply:|
	terraform apply
	
build: init validate plan apply
