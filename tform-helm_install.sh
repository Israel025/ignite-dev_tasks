#!/bin/bash

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

# =======Install & Helm Terraform (on Ubuntu Jammy 22.04 (LTS))=======
display_section_header "Packages Checking / Installations process initiated..."
space_pause

# Checks if Terraform is already installed and install if not
display_process_header "Checking if Terraform is installed and Install if NOT Installed..."
if terraform version &> /dev/null
then
  echo "Terraform already installed..."
else
  # Installing Terraform
  echo "Installing Terraform ..."
  #==================
  wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt update && sudo apt install terraform -y || handle_error "Failed to install Terraform, contact Admin..."
  
  # Task completion message
  display_process_header "Terraform Installation completed..."
fi
space_pause

# Checks if Helm is already installed and install if not
display_process_header "Checking if Helm is installed and Install if NOT Installed..."
if helm version &> /dev/null
then
  echo "Terraform already installed..."
else
  # Installing Helm
  echo "Installing Helm..."
  #==================
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
  chmod 700 get_helm.sh
  ./get_helm.sh && rm ./get_helm.sh || handle_error "Failed to install Helm, contact Admin..."
  
  # Task completion message
  display_process_header "Helm Installation completed..."
fi
space_pause

display_process_header "ALL OF THE TERRAFORM AND HELM SETUP PROCESSES COMPLETED SUCCESSFULLY :) ..."