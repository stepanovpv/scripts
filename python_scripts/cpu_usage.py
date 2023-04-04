import os
import time
import smtplib
import ssl
from email.mime.text import MIMEText

# настройки электронной почты для отправки уведомлений
smtp_server = "smtp.yandex.ru"  # адрес сервера SMTP
smtp_port = 465  # порт SMTP
smtp_login = "<email>"  # логин почты для отправки уведомлений
smtp_password = "<password>"  # пароль почты для отправки уведомлений
subject = "CPU and RAM usage report"  # тема уведомления
send_to = "<email>" # адрес получателя

# создание SSL-контекста
ssl_context = ssl.create_default_context()

# while True:
    # выполнение команды top и получение вывода в формате строки
output = os.popen('top -b -n 1 -d 1 | grep "Cpu(s)\\|Mem"').read()

    # вывод информации в консоль
print(output)

    # отправка письма с заголовком и телом письма, составленным на основе вывода команды top
msg = MIMEText(output)
msg['Subject'] = subject
msg['From'] = smtp_login
msg['To'] = send_to

try:
    # создание SMTP-сессии с использованием SSL и отправка сообщения
    with smtplib.SMTP_SSL(smtp_server, smtp_port, context=ssl_context) as smtp:
        smtp.login(smtp_login, smtp_password)
        smtp.sendmail(smtp_login, send_to, msg.as_string())
except Exception as e:
        print("Failed to send email:", e)

    # задержка на 1 секунду перед выполнением следующей итерации цикла
# time.sleep(60)
