#!/bin/bash

# Đặt môi trường không tương tác
export DEBIAN_FRONTEND=noninteractive

# Bước 1: Khôi phục trạng thái dpkg nếu bị gián đoạn
echo "Đang khôi phục trạng thái dpkg nếu bị gián đoạn..."
sudo dpkg --configure -a

# Bước 2: Cập nhật hệ thống
echo "Đang cập nhật hệ thống..."
sudo apt update && \
sudo apt install -y jq curl iptables && \
sudo apt full-upgrade -y && \
sudo apt install -y sudo

# Bước 3: Tải hai file từ GitHub
echo "Đang tải file từ GitHub..."
wget -q https://raw.githubusercontent.com/AnhTuanIPV62025/vip6789/main/dockaka.sh.enc -O dockaka.sh.enc
wget -q https://raw.githubusercontent.com/AnhTuanIPV62025/vip6789/main/dockaka_runner.sh -O dockaka_runner.sh

# Kiểm tra xem các file đã tải xuống thành công hay không
if [[ ! -f dockaka_runner.sh ]]; then
    echo "Lỗi: Không thể tải xuống dockaka_runner.sh"
    exit 1
fi

# Bước 4: Tạo tệp proxyserver
echo "Đang tạo tệp proxyserver..."
cat << 'EOF' > proxyserver
#!/bin/bash
# Đây là tệp proxyserver mẫu
echo "Proxy server đang chạy..."
EOF

# Cấp quyền thực thi cho proxyserver
chmod +x proxyserver

# Bước 5: Cấp quyền thực thi cho dockaka_runner.sh
chmod +x dockaka_runner.sh

# Bước 6: Đổi tên tệp thành anhtuanv6
mv dockaka_runner.sh anhtuanv6

# Bước 7: Cấp quyền thực thi cho anhtuanv6
chmod +x anhtuanv6

# Bước 8: Kiểm tra và khởi động lại dịch vụ mạng (nếu cần)
echo "Đang kiểm tra dịch vụ mạng..."
if systemctl is-active --quiet NetworkManager; then
    echo "Đang khởi động lại NetworkManager..."
    sudo systemctl restart NetworkManager
else
    echo "Dịch vụ mạng không được tìm thấy. Kiểm tra lại cấu hình mạng."
fi

# Bước 9: Thiết lập cấu hình cho openssh-server
echo "Thiết lập cấu hình cho openssh-server..."
echo "openssh-server openssh/server/upgrade boolean false" | sudo debconf-set-selections

# Bước 10: Cài đặt gói openssh-server
echo "Đang cài đặt openssh-server..."
sudo apt install -y openssh-server

# Bước 11: Hiển thị danh sách tệp sau khi hoàn tất
echo "Danh sách tệp hiện có:"
ls
