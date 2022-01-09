# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательные задания

1. Есть скрипт:
    ```python
    #!/usr/bin/env python3
    a = 1
    b = '2'
    c = a + b
    ```
    * Какое значение будет присвоено переменной c?<br>
    Никакого. Ошибка при сложении переменных разных типов
    * Как получить для переменной c значение 12?<br>
	c = str(a)+b
    * Как получить для переменной c значение 3?<br>
    c = a + int(b)
2. Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

    ```python
    #!/usr/bin/env python3

    import os

    bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
    result_os = os.popen(' && '.join(bash_command)).read()
    is_change = False
    for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result = result.replace('\tmodified:   ', '')
            print(prepare_result)
            break

    ```
<be>ответ:
```python3
#!/usr/bin/env python3
import os
bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
prepare_result = []
abspath=os.path.abspath(bash_command[0].replace("cd ", ""))
print(f'Путь к репозиторию: {abspath.replace("/~","")}')
is_change = False
for result in result_os.split('\n'):
        if result.find('modified') != -1:
                is_change = True
                prepare_result.append(result.replace('\tmodified:   ', ''))
no_duplicate=sorted(list(set(prepare_result)))

if is_change:
        print('Список измененных файлов:')
        for i in no_duplicate:
                print(i)
        print()
else:
        print('Измененных файлов нет.')
```
3. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.
```python3
#!/usr/bin/env python3
import os, sys

bash_command = [f"cd {sys.argv[1]}", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
prepare_result = []

abspath=os.path.abspath(bash_command[0].replace("cd ", ""))
tmp=abspath.replace("/~","")
is_change = False
for result in result_os.split('\n'):
        if result.find('modified') != -1:
                is_change = True
                prepare_result.append(result.replace('\tmodified:   ', ''))
no_duplicate=sorted(list(set(prepare_result)))

if is_change:
        print('Список измененных файлов:')
        for i in no_duplicate:
                print(f'{tmp}/{i}')
print()
else:
        print('Измененных файлов нет.')
 
```
4. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: drive.google.com, mail.google.com, google.com.
```python3
#!/usr/bin/env python3
import socket

host_names = ["drive.google.com", "mail.google.com", "google.com"]
hosts = {}
while True:
    for host in host_names:
        ip_address = socket.gethostbyname(host)
        if host in hosts.keys():
            if hosts[host] == ip_address:
                print(f'{host} - {ip_address}')
            else:
                print(f'[ERROR] {host}IP mismatch: old IP - {hosts[host]} new IP- {ip_address}')
        else:
            hosts[host] = ip_address
            print(f'{host} - {ip_address}') 
```

