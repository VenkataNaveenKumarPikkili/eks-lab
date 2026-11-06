#!/usr/bin/env bash
set -e

echo "=== Cleaning up old installs ==="
sudo rm -rf /usr/local/aws-cli
sudo rm -f /usr/local/bin/aws /usr/local/bin/aws_completer
rm -rf ~/awscliv2.zip ~/aws
sudo apt-get remove -y terraform 2>/dev/null || true
sudo rm -f /etc/apt/sources.list.d/hashicorp.list
sudo rm -f /usr/share/keyrings/hashicorp-archive-keyring.gpg
sudo apt-get update

echo "=== Installing prerequisites ==="
sudo apt-get install -y unzip curl wget gnupg lsb-release ca-certificates

echo "=== Installing AWS CLI v2 ==="
cd ~
curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o awscliv2.zip
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws

echo "=== Installing Terraform ==="
wget -qO- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update
sudo apt-get install -y terraform

echo "=== Versions ==="
/usr/local/bin/aws --version
terraform --version
