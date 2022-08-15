


#==============================================================================================================================
#Mithun Technologies Marathahalli, Banglore.  Ph: +91-8296242028 / +91-9980923226 
#==============================================================================================================================

#Agenda: Kubernetes Setup Using Kubeadm In AWS EC2 Ubuntu Servers
#=======

#Prerequisite:
#=============

#3 - Ubuntu Serves

#1 - Manager  (4GB RAM , 2 Core) t2.medium

#2 - Workers  (1 GB, 1 Core)     t2.micro


#Note: Open Required Ports In AWS Security Groups. For now we will open All trafic.

#==========COMMON FOR MASTER & SLAVES START ====

# First, login as ‘root’ user because the following set of commands need to be executed with ‘sudo’ permissions.

sudo su -

#Turn Off Swap Space

swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Install Required packages and apt keys.

apt-get update -y
apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update -y

#Install kubeadm, Kubelet And Kubectl 

apt-get install -y kubelet kubeadm containerd kubectl

#apt-mark hold will prevent the package from being automatically upgraded or removed.
apt-mark hold kubelet kubeadm kubectl containerd

# Configure Containerd.Load the necessary modules for Containerd:
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

#5) Setup the required kernel parameters

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sysctl --system

#6) Configure containerd:
mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
systemctl restart containerd

7) Start and enable kubelet service
systemctl daemon-reload
systemctl start kubelet
systemctl enable kubelet.service
systemctl status kubelet
 



# Install And Enable Docker

#apt install docker.io -y
#usermod -aG docker ubuntu
#systemctl restart docker
#systemctl enable docker.service

==========COMMON FOR MASTER & SLAVES END=====



===========In Master Node Start====================
# Steps Only For Kubernetes Master

# Switch to the root user.

#sudo su -

# Initialize Kubernates master by executing below commond.

#kubeadm init

#exit root user & exeucte as normal user

#exit

#mkdir -p $HOME/.kube
#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#sudo chown $(id -u):$(id -g) $HOME/.kube/config


# To verify, if kubectl is working or not, run the following command.

#kubectl get pods -o wide --all-namespaces

#You will notice from the previous command, that all the pods are running except one: ‘kube-dns’. For resolving this we will install a # pod network. To install the weave pod network, run the following command:

#kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

#kubectl get nodes

#kubectl get pods --all-namespaces


# Get token

#kubeadm token create --print-join-command

#=========In Master Node End====================


#Add Worker Machines to Kubernates Master
=========================================

#Copy kubeadm join token from and execute in Worker Nodes to join to cluster



#kubectl commonds has to be executed in master machine.

#Check Nodes 
#=============

#kubectl get nodes


#Deploy Sample Application
#==========================

#kubectl run nginx-demo --image=nginx --port=80 

#kubectl expose deployment nginx-demo --port=80 --type=NodePort


#Get Node Port details 
#=====================
#kubectl get services


#================
#Set up Dashboard
================
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml


# Service Account & Cluster Role Binding
#apiVersion: v1
#kind: ServiceAccount
#metadata:
#  name: k8s-admin
#  namespace: kube-system
#---
#apiVersion: rbac.authorization.k8s.io/v1beta1
#kind: ClusterRoleBinding
#metadata:
#  name: eks-admin
#roleRef:
#  apiGroup: rbac.authorization.k8s.io
#  kind: ClusterRole
#  name: cluster-admin
#subjects:
#- kind: ServiceAccount
#  name: k8s-admin
#  namespace: kube-system
  

 
#Enable dashboard access from out side network
#===============================================
#nohup kubectl proxy --address 0.0.0.0 --accept-hosts ".*" & 
 
#kubectl -n kube-system get service kubernetes-dashboard 
 
#Edit Service Update type from clusterIp to NodePort
#==================================================== 
#kubectl -n kube-system edit service kubernetes-dashboard 
 
#Get Bearer token
#===================  
#kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep k8s-admin | awk '{print $1}')  

# Label node 
#kubectl label node <nodeName>   node-role.kubernetes.io/worker=worker


#<---------- Pods --------->
#POD --> Pod is the smallest building block or basic unit of scheduling in k8s.
#POD contains one or more containers.
#POD represents running process in k8s.

###### There are Two ways to create POD ######

#1. Imperative Way (Commands)
# kubectl run javawebapp --image=dockerhandson/java-web-app:1 --port=8080 

#2. Declartive Way ( 








