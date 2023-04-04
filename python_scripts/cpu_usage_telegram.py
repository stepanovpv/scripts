import psutil
import telebot
import time

# Укажите API-токен Telegram-бота
bot = telebot.TeleBot("<API token>")

# Получить загрузку CPU и RAM
def get_system_usage():
    usage = psutil.cpu_percent()
    mem = psutil.virtual_memory()
    total_mem = mem.total / 1024.0 / 1024.0
    used_mem = mem.used / 1024.0 / 1024.0
    usage_pct = mem.percent
    disk_usage = psutil.disk_usage('.') # текущая директория
    free_space = disk_usage.free / 1024 / 1024 / 1024  # свободное место в GB
    return "CPU: {}%\nMemory Usage: {:.2f} / {:.2f} GB ({:.2f}%)\nFree Space: {:.2f} GB".format(usage, used_mem, total_mem, usage_pct, free_space)

# Отправка сообщения в чат-бот Telegram
def send_message(message):
    bot.send_message(chat_id='<chat-id>', text=message)

# Бесконечный цикл для отправки данных в Telegram
#while True:
system_usage = get_system_usage()
send_message(system_usage)
#    time.sleep(60)
