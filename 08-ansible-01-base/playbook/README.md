# Самоконтроль выполненения задания

1. Где расположен файл с `some_fact` из второго пункта задания?
```
./playbook/group_vars/all/examp.yml 
```
2. Какая команда нужна для запуска вашего `playbook` на окружении `test.yml`?
```
ansible-playbook -i inventory/test.yml site.yml 
```
3. Какой командой можно зашифровать файл?
```
ansible-vault encrypt
```
4. Какой командой можно расшифровать файл?
```
ansible-vault decrypt
```
5. Можно ли посмотреть содержимое зашифрованного файла без команды расшифровки файла? Если можно, то как?
```
ansible-vault view
```
6. Как выглядит команда запуска `playbook`, если переменные зашифрованы?
```
ansible-playbook -i inventory/prod.yml  site.yml  --vault-pass-file credentials
```
7. Как называется модуль подключения к host на windows?
```
ansible-doc ansible.windows.win_hostname  
```
8.  Приведите полный текст команды для поиска информации в документации ansible для модуля подключений ssh
```
ansible-doc -t connection ssh
```
9.  Какой параметр из модуля подключения `ssh` необходим для того, чтобы определить пользователя, под которым необходимо совершать подключение?
```
Могу предполодить что это ansible.builtin.ssh remote_user 
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/ssh_connection.html#parameter-remote_user
```
