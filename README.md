# KubeKluster

Project aims to create a K8S cluster via kubeadm on Raspberry Pi

Runs debian.

lab - Terraform code stand up a lab for testing other parts
bootstrap - Ansible code to prep nodes for kubeadm to do its stuff

# Lab

Terraform code using [terraform-provider-libvirt](https://github.com/dmacvicar/terraform-provider-libvirt)
to create VMs in libvirt on Linux. These are based of the Debian OpenStack cloud image with set up
performed via cloud-init.


# Bootstrap

Janky Ansible to set up nodes for kubeadm. User containerd.io, follows the requirements set out in the kubeadm docs.

# Repos of interest

* https://github.com/treilly94/packer-pi
* https://github.com/tiredanimal/ubuntu-k8s-cluster

# Plans

CNI: Callico
CSI: NFS, Longhorn
LB: MetalLB
Ingress: Nginx, Contour