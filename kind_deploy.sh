#!/bin/bash

# Define the KinD cluster name
CLUSTER_NAME="samp-kind-cluster"

# Function for displaying section headers
display_section_header() {
    echo "##########################################"
    echo "$1"
    echo "##########################################"
    echo
}

display_process_header() {
    echo "===== $1 ====="
    echo
}

# Function for handling errors
handle_error() {
    echo "Error: $1"
    exit 1
}

space_pause() {
  echo
  sleep 1s
}

# =======Install Docker Engine (on Ubuntu Jammy 22.04 (LTS))=======
display_section_header "Setting up Docker Engine"

# Remove all conflicting packages
display_process_header "Uninstalling old and conflicting docker packages..."
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc
do 
  sudo apt-get remove $pkg -y
done
space_pause

# Docker engine confirmation and installation proccess
display_process_header "Checking if Latest Docker installed and Install if NOT Installed..."
if docker version &> /dev/null
then
  echo "Latest Docker Engine already installed..."
else
  # Installing latest Docker Engine
  echo "Installing Latest Docker Engine..."

  # Add Docker's official GPG key:
  sudo apt-get update
  sudo apt-get install ca-certificates curl gnupg || handle_error "package installation failure, contact your Admin..."
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  # Add the repository to Apt sources:
  echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update

  # Install latest version of docker engine
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

  # Create the docker group.
  $ sudo groupadd docker

  # Add your user to the docker group.
  $ sudo usermod -aG docker $USER

  # Activate the changes to groups:
  $ newgrp docker
  display_process_header "Docker Engine Installation completed..."
fi
space_pause

# =======Install Kubectl (on Ubuntu Jammy 22.04 (LTS))=======
display_section_header "Initiating KUBECTL installation/confirmation process..."

display_process_header "Confirming if KUBECTL is installed and Install if NOT Installed..."

if kubectl version &>/dev/null
then
  echo "Kubectl already installed..."
  echo
else
  echo "Kubectl is currently not installed. Initiating Kubectl installation..."
  echo
  sudo apt-get update
  sudo apt-get install -y apt-transport-https ca-certificates curl
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update
  sudo apt-get install -y kubectl
  display_process_header "Kubectl Installation completed..."
fi
space_pause

# =======Install KinD (on Ubuntu Jammy 22.04 (LTS))=======
# For AMD64 / x86_64
display_section_header "Initiating KinD installation/confirmation process..."

display_process_header "Confirming if KinD is installed and Install if NOT Installed..."
# Check if KinD is already installed
if type kind &> /dev/null 
then
  echo "KinD is already installed..."
else
  echo "KinD is currently not installed. Initiating KinD installation..."
  
  # Download and install KinD
  [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
  chmod +x ./kind
  sudo mv ./kind /usr/local/bin/kind
  
  display_process_header "KinD installed successfully..."
fi
space_pause

# Setting up a KinD Cluster
display_section_header "Launching a KinD K8s cluster"

# Check if the cluster does not already exist & Create the KinD cluster
display_process_header "Checking if a cluster named $CLUSTER_NAME already exists and Launch one if NOT..."
if kind get clusters | grep -q "$CLUSTER_NAME"
then
  echo "Cluster '$CLUSTER_NAME' already exists."
  echo
else
  kind create cluster --name "$CLUSTER_NAME"
  display_process_header "$CLUSTER_NAME cluster created successfully..."
fi
space_pause

# Set KUBECTL to point to the new cluster
kubectl config use-context "kind-$CLUSTER_NAME"
display_process_header "KUBECTL set to point to the $CLUSTER_NAME cluster successfully..."
space_pause

# Verify the cluster status
if kind get clusters | grep $CLUSTER_NAME
then
  echo "KinD Cluster '$CLUSTER_NAME' deployed and accessible."
  echo
  display_process_header "Cluster $CLUSTER_NAME status cluster successfully verified..."
else
  handle_error "Error with Cluster Setup, Contact your Administrator."
fi
space_pause

# Get and save the KUBECONFIG file for the KinD Cluster to a specified location
display_section_header "Saving $CLUSTER_NAME kubeconfig file to terraform_nodeApp/kube_config/samp_kubeconfig.yaml..."

kind get kubeconfig --name $CLUSTER_NAME > terraform_nodeApp/kube_config/clust_kubeconfig.yaml || handle_error "issues getting/saving file, contact your Admin..."
display_process_header "config file saved successfully..."
space_pause

# All processes successful completion message
display_process_header "ALL OF THE KIND CLUSTER SETUP PROCESSES COMPLETED SUCCESSFULLY :) ..."
