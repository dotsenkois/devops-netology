#!/bin/bash
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
rm index.html
echo "<html><h1>My cool web-server $(hostname)</h1><body><img src=\"http://15.2-dotsenkois-2.website.yandexcloud.net/wallpaper.jpeg\" alt=\"Обои Ubuntu\"></body></html>" > index.html
