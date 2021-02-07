.PHONY: apply
apply: debian10.qcow2
	test -d .terraform || terraform init
	terraform apply

debian10.qcow2:
	curl -o $@ \
		http://cloud.debian.org/images/cloud/buster/20210129-530/debian-10-genericcloud-amd64-20210129-530.qcow2

.PHONY: destroy
destroy:
	terraform destroy

.PHONY: clean
clean: destroy
	rm debian10.qcow2

.PHONY: cleanterraform
cleanterraform:
	rm  *.tfstate*
	rm -r .terraform

.PHONY: distclean
distclean: clean cleanterraform
