Балансировщик 	192.168.1.10<br>
bakend(node 01)	192.168.1.100<br>
bakend(node 02)	192.168.1.101<br>

```
root@vagrant:~# curl 192.168.1.10 |grep h1
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   628  100   628    0     0  25120      0 --:--:-- --:--:-- --:--:-- 25120
<h1>Welcome to nginx!(NODE 02)</h1>
root@vagrant:~# curl 192.168.1.10 |grep h1
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   630  100   630    0     0  42000      0 --:--:-- --:--:-- --:--:-- 42000
<h1>Welcome to nginx!(NODE 01)</h1>
```

/etc/nginx/sites-available/dotsenkois.loc<br>

```
  GNU nano 4.8             /etc/nginx/sites-available/dotsenkois.loc                        
  upstream backend {
    server 192.168.1.100:8080;
    server 192.168.1.101:8080;
}

server {
    listen    80;
    server_name  dotsenkois.loc;
    location ~* \.()$ {
    root   /var/www/dotsenkois.loc;  }
    location / {
    client_max_body_size    10m;
    client_body_buffer_size 128k;
    proxy_send_timeout   90;
    proxy_read_timeout   90;
    proxy_buffer_size    4k;
    proxy_buffers     16 32k;
    proxy_busy_buffers_size 64k;
    proxy_temp_file_write_size 64k;
    proxy_connect_timeout 30s;
    proxy_pass   http://backend;
    proxy_set_header   Host   $host;
    proxy_set_header   X-Real-IP  $remote_addr;
    proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
       }
location ~* /.(jpg|jpeg|gif|png|css|mp3|avi|mpg|txt|js|jar|rar|zip|tar|wav|wmv)$ {
root    /var/www/dotsenkois.loc;}
 }
```