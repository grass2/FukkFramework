for XML_FILE in "PlayIntegrityFix/Leaked Keyboxs"/*/*.xml; do
    # Lấy thông tin từ tệp XML
    NumberOfKeyboxes=$(xmlstarlet sel -t -v "//NumberOfKeyboxes" "$XML_FILE")
    DeviceID=$(xmlstarlet sel -t -v "//Keybox/@DeviceID" "$XML_FILE")
    PrivateKeyEcdsa=$(xmlstarlet sel -t -v "//Key[@algorithm='ecdsa']/PrivateKey" "$XML_FILE")
    PrivateKeyRsa=$(xmlstarlet sel -t -v "//Key[@algorithm='rsa']/PrivateKey" "$XML_FILE")
    NumberOfCertificatesEcdsa=$(xmlstarlet sel -t -v "//Key[@algorithm='ecdsa']/CertificateChain/NumberOfCertificates" "$XML_FILE")
    CertificateEcdsa1=$(xmlstarlet sel -t -v "//Key[@algorithm='ecdsa']/CertificateChain/Certificate[1]" "$XML_FILE")
    CertificateEcdsa2=$(xmlstarlet sel -t -v "//Key[@algorithm='ecdsa']/CertificateChain/Certificate[2]" "$XML_FILE")
    CertificateEcdsa3=$(xmlstarlet sel -t -v "//Key[@algorithm='ecdsa']/CertificateChain/Certificate[3]" "$XML_FILE")
    NumberOfCertificatesRsa=$(xmlstarlet sel -t -v "//Key[@algorithm='rsa']/CertificateChain/NumberOfCertificates" "$XML_FILE")
    CertificateRsa1=$(xmlstarlet sel -t -v "//Key[@algorithm='rsa']/CertificateChain/Certificate[1]" "$XML_FILE")
    CertificateRsa2=$(xmlstarlet sel -t -v "//Key[@algorithm='rsa']/CertificateChain/Certificate[2]" "$XML_FILE")
    CertificateRsa3=$(xmlstarlet sel -t -v "//Key[@algorithm='rsa']/CertificateChain/Certificate[3]" "$XML_FILE")

    # Lấy tên cơ sở của tệp XML
    base_name_xml=$(basename "$XML_FILE" .xml)
    echo "File: $base_name_xml"
    # echo "NumberOfKeyboxes: $NumberOfKeyboxes"
    # echo "DeviceID: $DeviceID"
    # echo "PrivateKey (ECDSA): $PrivateKeyEcdsa"
    # echo "PrivateKey (RSA): $PrivateKeyRsa"
    # Thay thế nội dung và xây dựng ứng dụng

    keybox=app/src/main/java/com/android/internal/util/framework/Keybox.java
    cp -f my_files/Keybox_template.java $keybox
    awk -v key="$PrivateKeyEcdsa" '{gsub(/^\s*PLACEHOLDER_EC_PRIVATE_KEY/, key); print}' "$keybox" >temp && mv temp "$keybox"
    awk -v key="$CertificateEcdsa1" '{gsub(/^\s*PLACEHOLDER_EC_CERTIFICATE_1/, key); print}' "$keybox" >temp && mv temp "$keybox"
    awk -v key="$CertificateEcdsa2" '{gsub(/^\s*PLACEHOLDER_EC_CERTIFICATE_2/, key); print}' "$keybox" >temp && mv temp "$keybox"
    awk -v key="$CertificateEcdsa3" '{gsub(/^\s*PLACEHOLDER_EC_CERTIFICATE_3/, key); print}' "$keybox" >temp && mv temp "$keybox"
    awk -v key="$PrivateKeyRsa" '{gsub(/^\s*PLACEHOLDER_RSA_PRIVATE_KEY/, key); print}' "$keybox" >temp && mv temp "$keybox"
    awk -v key="$CertificateRsa1" '{gsub(/^\s*PLACEHOLDER_RSA_CERTIFICATE_1/, key); print}' "$keybox" >temp && mv temp "$keybox"
    awk -v key="$CertificateRsa2" '{gsub(/^\s*PLACEHOLDER_RSA_CERTIFICATE_2/, key); print}' "$keybox" >temp && mv temp "$keybox"
    awk -v key="$CertificateRsa3" '{gsub(/^\s*PLACEHOLDER_RSA_CERTIFICATE_3/, key); print}' "$keybox" >temp && mv temp "$keybox"
    echo "Đã thay thế!!"
    exit
    continue
    # Chạy Gradle
    ./gradlew clean assembleRelease >/dev/null 2>&1

    # Kiểm tra và sao chép tệp dex
    DexFile=$(find app/build/intermediates/dex/release/ -name 'classes.dex')
    if [ -z "$DexFile" ]; then
        echo "Error: No dex file found."
        exit 1
    fi

    # Sao chép tệp dex vào thư mục out
    mkdir -p outdex
    sudo mv "$DexFile" outdex/"$base_name_xml".dex
done
