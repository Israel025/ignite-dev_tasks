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

# =======Script to initiate the setup of the whole project task (on Ubuntu Jammy 22.04 (LTS))=======
display_section_header "All Project task setup process initiated..."
space_pause

# Run the complete process of creating a KinD cluster and all of its requirements
display_process_header "Commenced KinD cluster setup and requirments installation script..."
./kind_deploy.sh || handle_error 'KinD Cluster Setup failed!; contact admin...'
space_pause

# Run the complete process of installing terraform and helm
display_process_header "Commenced the running of terraform and helm installation script..."
./tform-helm_install.sh || handle_error 'Terraform and Helm installation failed...'
space_pause

# Run the terraform scripts to make all deployments to the created cluster
display_process_header "Commenced the running the terraform scripts..."
cd ./terraform_nodeApp
terraform init || handle_error 'Could NOT initialize Terraform scripts, error occured...'
terraform apply -auto-approve || handle_error 'Could NOT apply Terraform scripts, error occured...'
space_pause

# Project setup completed confirmation
display_process_header "The project setup has been fully COMPLETED :)..."