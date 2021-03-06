# KubeKluster

Project aims to create a K8S cluster via kubeadm on Raspberry Pi

Runs debian.

Vagrantfile - setup up N node lab using libvirt or VirtualBox
terraform-libvirt - Terraform code stand up a lab for testing other parts
ansible - Ansible code to prep nodes for kubeadm to do its stuff

## Required software

For Vagrant: vagrant, vagrant-libvirt if using libvirt
For Terraform: terraform, terraform-provider-libvirt
For Ansible: Ansible, Python's netaddr library
For Kubernetes: kubectl, kustomize

## Bootstrap

* Clone repo

SSH config for easy access to created VMs. Only needs doing once.

* `cat ssh_config >>$HOME/.ssh/config`  

### Vagrant

* Check Vagrantfile ssh_public_key is correct for the key type you use.
* `vagrant up`

Cluster with worker nodes will be created, with Calico as the CNI

K8S admin config can be configured via env var on your host. 

```bash
export KUBECONFIG=$(pwd)/ansible/admin.conf
```

### Terraform

* `cd terraform-libvirt`. Create `terraform.tfvars` containing `ssh_public_key="<YourSSHPublicKey>"`
* `make`
* `cd ../ansible`
* `make`

TODO: Needs testing, not worked on in some time.

### Flux CD

```bash
flux bootstrap github --owner=tiredanimal --repository=kubekluster --branch=main --path=kubernetes/clusters/matts-lab
```

### MetalLB

See https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner/issues/25#issuecomment-742616668

* `kustomize build ./kubernetes/base/metallb | kubectl apply -f -`
* `kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"`

### NFS CSI

Basic storage CSI https://github.com/kubernetes-csi/csi-driver-nfs

* `kustomize build ./kubernetes/base/csi-driver-nfs/master-87e6ba8 | kubectl apply -f -`

## terraform-libvirt

Terraform code using [terraform-provider-libvirt](https://github.com/dmacvicar/terraform-provider-libvirt)
to create VMs in libvirt on Linux. These are based of the Debian OpenStack cloud image with set up
performed via cloud-init.

## ansible

Janky Ansible to set up nodes for kubeadm. User containerd.io, follows the requirements set out in the kubeadm docs.

## Repos of interest

* https://github.com/treilly94/packer-pi
* https://github.com/tiredanimal/ubuntu-k8s-cluster

## Plans

* CNI: Callico ✅
* CSI: NFS ✅, Longhorn ✅
* LB: MetalLB ✅
* Ingress: Nginx, Contour
