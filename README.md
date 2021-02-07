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
* `cat ssh_config >>$HOME/.ssh/config` 

Terraform:
* `cd terraform-libvirt`. Create `terraform.tfvars` containing `ssh_public_key="<YourSSHPublicKey>"`
* `make`
* `cd ../ansible`
* `make`

OR Vagrant:
* Check ssh_public_key is correct for the key type you use.
* `vagrant up`

Then:
* `ssh control1`
* `sudo -i`
* `kubeadm init --apiserver-advertise-address 192.168.33.16 --pod-network-cidr 10.244.0.0/16`. Follow the displayed instructions to add the workers.
* Copy /etc/kubernetes/admin.conf to your workstation from `control1`

* `export KUBECONFIG=$(pwd)/admin.conf`
* `kubectl get no`  should show you all your nodes
* Install Calico operator `kustomize build ./kubernetes/base/tigera-operator | kubectl apply -f -`
* Run `kustomize build ./kubernetes/base/tigera-operator | kubectl apply -f -` again.
* Check progress with `watch kubectl get po -A`


# terraform-libvirt

Terraform code using [terraform-provider-libvirt](https://github.com/dmacvicar/terraform-provider-libvirt)
to create VMs in libvirt on Linux. These are based of the Debian OpenStack cloud image with set up
performed via cloud-init.

# ansible

Janky Ansible to set up nodes for kubeadm. User containerd.io, follows the requirements set out in the kubeadm docs.

# Repos of interest

* https://github.com/treilly94/packer-pi
* https://github.com/tiredanimal/ubuntu-k8s-cluster

# Plans

CNI: Callico
CSI: NFS, Longhorn
LB: MetalLB
Ingress: Nginx, Contour
