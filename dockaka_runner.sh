#!/bin/bash

# Script Runner - Phiên bản tối ưu
# Tự động kiểm tra các yêu cầu và xử lý lỗi

# Kiểm tra các gói cần thiết
check_requirements() {
    local missing_pkgs=()
    
    # Kiểm tra openssl
    if ! command -v openssl &> /dev/null; then
        missing_pkgs+=("openssl")
    fi
    
    # Kiểm tra curl
    if ! command -v curl &> /dev/null; then
        missing_pkgs+=("curl")
    fi
    
    # Kiểm tra jq
    if ! command -v jq &> /dev/null; then
        missing_pkgs+=("jq")
    fi
    
    # Nếu có gói bị thiếu, thông báo và thoát
    if [ ${#missing_pkgs[@]} -gt 0 ]; then
        echo "Lỗi: Các gói sau cần được cài đặt: ${missing_pkgs[*]}"
        echo "Vui lòng cài đặt bằng lệnh: sudo apt update && sudo apt install ${missing_pkgs[*]} -y"
        return 1
    fi
    
    return 0
}

# Kiểm tra file mã hóa
check_encrypted_file() {
    if [ ! -f "dockaka.sh.enc" ]; then
        echo "Lỗi: Không tìm thấy file mã hóa dockaka.sh.enc"
        echo "Vui lòng đảm bảo file này nằm trong cùng thư mục với script runner."
        
        # Thử tải file từ server
        echo "Đang thử tải file mã hóa từ server..."
        curl -s -o "dockaka.sh.enc" "http://YOUR_SERVER_IP/scripts/dockaka.sh.enc"
        
        if [ ! -f "dockaka.sh.enc" ]; then
            echo "Không thể tải file mã hóa. Vui lòng liên hệ admin."
            return 1
        else
            echo "Đã tải file mã hóa thành công."
        fi
    fi
    
    # Kiểm tra kích thước file
    local file_size=$(stat -c%s "dockaka.sh.enc")
    if [ $file_size -lt 1000 ]; then
        echo "Cảnh báo: File mã hóa có kích thước nhỏ ($file_size bytes)."
    fi
    
    return 0
}

# Hàm hiển thị banner
show_banner() {
    clear
    echo -e "\033[32m# ############################################################"
    echo -e "# #                                                          #"
    echo -e "# #                  LIÊN HỆ TELEGRAM                        #"
    echo -e "# #                                                          #"
    echo -e "# #                      @ipv6anhtuan                        #"
    echo -e "# #                                                          #"
    echo -e "# ################# +1  567 218 1919    ######################\033[0m"
    echo ""
    echo "############################################################"
    echo "#                                                          #"
    echo "#                  HỆ THỐNG PROXY IPv6                     #"
    echo "#                                                          #"
    echo "############################################################"
    echo ""
}

# Kiểm tra yêu cầu
if ! check_requirements; then
    exit 1
fi

# Kiểm tra file mã hóa
if ! check_encrypted_file; then
    exit 1
fi

# Hiển thị banner
show_banner

# Nhập key thủ công
echo "Vui lòng nhập key của bạn để tiếp tục:"
read -p "> " KEY

if [ -z "$KEY" ]; then
    echo "Key không được để trống. Vui lòng thử lại."
    exit 1
fi

TEMP_FILE=$(mktemp)

# Hàm lấy mật khẩu mã hóa (obfuscated)
get_password() {
    # Mật khẩu được mã hóa và nhúng vào script
    echo "QU5IVFVBTnByb3h5MjAyNWE=" | base64 -d
}

echo "Đang xác thực key..."

# Giải mã script
openssl enc -aes-256-cbc -pbkdf2 -iter 10000 -d -in "dockaka.sh.enc" -out $TEMP_FILE -k "$(get_password)" 2>/dev/null

if [ $? -ne 0 ]; then
    echo "Giải mã thất bại. Vui lòng liên hệ admin."
    echo "Mã lỗi: ENC-$(date +%s)"
    rm -f $TEMP_FILE
    exit 1
fi

# Thực thi script với key
chmod +x $TEMP_FILE
$TEMP_FILE $KEY
EXIT_CODE=$?

# Xóa file tạm
rm -f $TEMP_FILE
exit $EXIT_CODE
