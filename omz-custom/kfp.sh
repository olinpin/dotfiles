#!/bin/bash
function pause(){
  echo "$*"
  read
}
echo "Script started at $(date)" >> /tmp/script_debug.log

kubectl port-forward --namespace production svc/mysql-shared 3307:3306 &
kubectl port-forward --namespace acceptance svc/mysql-shared 3308:3306 &
kubectl port-forward --namespace dev svc/mysql-shared 3309:3306 &
sleep 2
pause 'Press [Enter] key to stop the port forwards...'
pkill -9 kubectl
