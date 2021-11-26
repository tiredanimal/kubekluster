VERSION ?= v0.5.1

define KUSTOMIZATION_BODY
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - components.yaml
endef
export KUSTOMIZATION_BODY

MAKEDIR = @mkdir -p $(@D)

.PHONY: all clean versions

all: $(VERSION)/components.yaml $(VERSION)/kustomization.yaml

clean:
	rm -r $(VERSION)

versions:
	helm search repo jetstack/cert-manager

$(VERSION)/kustomization.yaml:
	$(MAKEDIR)
	echo "$$KUSTOMIZATION_BODY" >$@

$(VERSION)/components.yaml:
	$(MAKEDIR)
	curl -L -o $@ https://github.com/kubernetes-sigs/metrics-server/releases/download/$(VERSION)/components.yaml
