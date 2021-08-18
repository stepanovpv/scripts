#!/bin/bash
# 
# Данный скрипт запускает первый контейнер из списка установленных в списке, путем выделения его ID
#
# Задаем переменную, выделяющую ID первого контейнера
doc1=`docker ps -a | awk '(NR == 2)' | cut -b 1-12`
echo "Запускаем контейнер"
docker start $doc1
echo "Стартуем apache2"
docker exec -it apache2 service apache2 start
echo "Проверяeм статус"
docker exec -it apache2 service apache2 status
