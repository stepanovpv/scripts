#!/bin/bash

# Сделать проверку, если пользователь захочет ввести YC креды вручную.
# Запрашивать у пользователя c клавиатуры креды Azure
# Создать комментарии по ходу выполнения скрипта

# Создание новых кредов для YC
# yc iam access-key create --service-account-id aje4tfpie7fkmaecpjea > yc_key.txt

KEY_ID=`cat yc_key.txt | grep key_id | cut -b 11-35`
KEY_SECRET=`cat yc_key.txt | grep secret | cut -b 9-48`

# Потом убрать
echo $KEY_ID
echo $KEY_SECRET

echo [Yandex] > rclone.conf
echo 'type = s3' >> rclone.conf
echo 'provider = Other' >> rclone.conf
echo 'env_auth = false' >> rclone.conf
echo 'access_key_id = '$KEY_ID >> rclone.conf
echo 'secret_access_key = '$KEY_SECRET >> rclone.conf
echo 'endpoint = https://storage.yandexcloud.net/' >> rclone.conf
echo 'acl = private' >> rclone.conf
echo ' ' >> rclone.conf
echo '[Azure]' >> rclone.conf
echo 'type = azureblob' >> rclone.conf
echo 'account = stepanovp' >> rclone.conf
echo 'key = QxgiTRqvMSr1EjcF6MLMskcLD51hLcHJj93clEAk6UOTexKGjo2CxNRKi97sQyzvnHMImVAO2itF+AStwQ18Aw==' >> rclone.conf

cp rclone.conf ~/.config/rclone/

# Удалить файл с кредами YC

