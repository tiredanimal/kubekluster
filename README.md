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

### Vagrant

* Check Vagrantfile ssh_public_key is correct for the key type you use.
* `vagrant up`
* `vagrant ssh control1 -c 'sudo -i -- kubeadm init --kubernetes-version v1.19.7 --apiserver-advertise-address 192.168.33.16 --pod-network-cidr 10.244.0.0/16'`
* `vagrant ssh control1 -c 'sudo cp /etc/kubernetes/admin.conf /vagrant'`
* `export KUBECONFIG=$(pwd)/admin.conf`
* `kubectl get no` should show the controller
* Run `kustomize build ./kubernetes/base/tigera-operator | kubectl apply -f -` twice (CRD needs loading for the config to take, this needs some work)
* Add workers following the output of `kubeadm init`

### Terraform

* `cd terraform-libvirt`. Create `terraform.tfvars` containing `ssh_public_key="<YourSSHPublicKey>"`
* `make`
* `cd ../ansible`
* `make`
* `ssh control1`
* `sudo -i -- kubeadm init --kubernetes-version v1.19.7 --apiserver-advertise-address 192.168.33.16 --pod-network-cidr 10.244.0.0/16'`.
* Copy /etc/kubernetes/admin.conf to your workstation from `control1`, then follow the steps from `export KUBECONFIG...` in the Vagrant section.

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
* CSI: NFS ✅, Longhorn
* LB: MetalLB ✅
* Ingress: Nginx, Contour
