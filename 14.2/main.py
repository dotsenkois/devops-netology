#!/bin/python3
import hvac
client = hvac.Client(
    url='http://10.233.78.7:8200',
    token='aiphohTaa0eeHei'
)
client.is_authenticated()

# Пишем секрет
client.secrets.kv.v2.create_or_update_secret(
    path='hvac',
    secret=dict(netology='Big secret!!!'),
)

# Читаем секрет
print(client.secrets.kv.v2.read_secret_version(
    path='hvac',
)['data']['data'])