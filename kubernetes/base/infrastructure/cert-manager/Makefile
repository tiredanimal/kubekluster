VERSION ?= v1.6.1
NAMESPACE ?= cert-manager

define KUSTOMIZATION_BODY
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - namespace.yaml
  - components.yaml
endef
export KUSTOMIZATION_BODY

define NAMESPACE_BODY
---
kind: Namespace
apiVersion: v1
metadata:
  name: $(NAMESPACE)
endef
export NAMESPACE_BODY

MAKEDIR = @mkdir -p $(@D)

.PHONY: all clean versions

all: $(VERSION)/namespace.yaml $(VERSION)/components.yaml $(VERSION)/kustomization.yaml

clean:
	rm -r $(VERSION)

versions:
	helm search repo jetstack/cert-manager

$(VERSION)/kustomization.yaml:
	$(MAKEDIR)
	echo "$$KUSTOMIZATION_BODY" >$@

$(VERSION)/components.yaml:
	$(MAKEDIR)
	helm repo add jetstack https://charts.jetstack.io
	helm template cert-manager jetstack/cert-manager \
		--namespace $(NAMESPACE) \
		--version $(VERSION) \
		--set installCRDs=true >$@

$(VERSION)/namespace.yaml:
	$(MAKEDIR)
	echo "$$NAMESPACE_BODY" >$@
