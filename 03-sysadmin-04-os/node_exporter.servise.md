```
root@vagrant:~# cat /etc/default/node_exporter
ARGS=""
root@vagrant:~# cat /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter Service
After=network.target

[Service]
User=nodeusr
Group=nodeusr
Type=simple
EnvironmentFile=/etc/default/node_exporter
ExecStart=/usr/local/bin/node_exporter $ARGS
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target