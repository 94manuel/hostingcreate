#!/bin/bash

echo "Hola soy Manuel Fernando, amo y señor del systema."
echo "actualizare los repositorios."
echo "empezemos"
sudo apt update
echo "actualizare el sistema. un momento por favor."
sudo apt upgrade
echo "Gracias por esperar..."
echo "Instalaremos el servidor web"
sudo apt install nginx
echo "La instalacion fue un exito, iniciemos con la configuracion."

echo "Ajustaremos el firewall"

sudo ufw app list
echo "abriendo puerto 80 y puerto 443"
sudo ufw allow 'Nginx Full'
echo "Este es el estado de los puertos."
sudo ufw status
echo "Este es el estado de Nginx."
systemctl status nginx
echo "Entra a esta ip, ya esta avilitado el servidor."
curl -4 icanhazip.com

pwd > /etc/nginx/nginx.conf
sed 's/#server_names_hash_bucket_size/server_names_hash_bucket_size/w output' nginx.conf

echo "Verifiquemos que no tengamos errores."
sudo nginx -t

read -p "Quieres reiniciar Nginx? " res
case $res in
y) sudo systemctl restart nginx ;;
n) echo "ya terminamos." ;;
esac



read -p "Quieres continuar? " res
case $res in
y) echo "chao" ;;
n) echo "Perdon, ya terminamos." ;;
esac

exec 3>&-  #cierra la shell

echo "Nothing works" >&3