#!/bin/bash
##Direcciones
Did="/volume1/docker/id"        ##Direccion carpeta id
Dname="/volume1/docker/name"    ##Direccion carpeta name
Dbackup="/volume1/Backup/backup-$(date +%d-%m-%Y)"  ##Crear carpeta con fecha.
Backup="/volume1/Backup"

##  Direccion
mkdir -p $Did           ##Crear carpeta
mkdir -p $Dname         ##Crear carpeta

##Creacion carpetas nuevas
mkdir -p $Dbackup       ##Crear carpeta

##     ID
docker ps -q > $Did/id.txt
ID=$(cat $Did/id.txt)

##    Name
docker ps -q --format "{{.Names}}" > $Dname/name.txt
NAME=$(cat $Dname/name.txt)

##Contador
CI=$(cat $Did/id.txt $1 | wc -l )

readarray -t identificadores < "${Did}/id.txt"
readarray -t names < "${Dname}/name.txt"

a=${#names[*]}
b=${#identificadores[*]}

##prueba bucle
let limite=${#names[*]}-1
if [ $a == $b ]
then
        for i in $(seq 0 $limite)
                do
                        docker export ${names[$i]} > "${Dbackup}/${names[$i]}.tar"
                done
else
        echo "error longitud archivos"
fi

##Borrar carpeta con fecha de tres semanas 
find $Backup/* -mtime +7 -type f -delete
##FIN
##AlejandroDanielVictor