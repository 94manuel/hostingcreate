#!/bin/bash

echo "Ingrese la direccion del dominio, ejemplo miempresa.com"
read x
echo "El dominio se creara con la direccion dns" $x ...

# Ruta inicial en el escritorio del usuario
INITIAL_PATH="$HOME/Desktop"

# Solicitar al usuario ingresar la carpeta desde el escritorio
read -p "Ingresa la carpeta de la app Node.js desde el escritorio ($INITIAL_PATH/): " SELECTED_FOLDER

# Combinar la ruta ingresada con la ruta inicial
APP_PATH="$INITIAL_PATH/$SELECTED_FOLDER"
if [ $? -ne 0 ]; then
    echo "No se seleccionó ninguna carpeta. Saliendo."
    exit 1
fi

# Verificar si la carpeta existe
if [ ! -d "$APP_PATH" ]; then
    echo "La carpeta no existe. Saliendo."
    exit 1
fi

# Mostrar el contenido de la carpeta seleccionada
ls "$APP_PATH"

echo "Creando Directorio" $x ...
sudo mkdir -p /var/www/$x/html

echo "Asignaremos su dominio a las variables de entorno del sistema las variables de entorno de la direccion" $x ...
sudo chown -R $USER:$USER /var/www/$x/html

echo "confirmando permisos de escritura, lectura, y ejecucion"
sudo chmod -R 755 /var/www/$x

echo "Creamos la web predeterminada"
sudo bash -c 'echo "<html><head><title>'$x'</title></head><body><h1>Listo!  El '$x' ya esta en funcionamiento!</h1></body></html>" > /var/www/'$x'/html/index.html'

echo "Avilitando el hosting"
sudo nano /etc/nginx/sites-available/$x
sudo bash -c 'echo "server {
        listen 80;
        listen [::]:80;

        root /var/www/'$x'/html;
        index index.html index.htm index.nginx-debian.html;

        server_name '$x' www.'$x';
        access_log /var/log/nginx/'$x'.access.log;
        error_log /var/log/nginx/'$x'.error.log debug;
        location / {
                try_files $uri $uri/ =404 /index.html;
        }
}" > /etc/nginx/sites-available/'$x''

# Construir la aplicación ReactJS
cd "$APP_PATH"
npm install
npm run build

# Obtenemos la dirección IP y la guardamos en el archivo hosts
IP=$(curl -4 icanhazip.com)
echo "$IP $x" | sudo tee -a /etc/hosts

sudo pwd >/etc/hosts
sudo sed -i "s/curl -4 icanhazip.com/$x/g" /etc/hosts

echo "A continuación, habilitaremos el archivo creando un enlace entre él y el directorio sites-enabled, en el cual Nginx obtiene lecturas durante el inicio"
sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Editamos el archivo de configuración para la app Node.js
sudo nano /etc/init/$x.conf << EOL
description "$x"
env APP_PATH="$APP_PATH"

start on startup
stop on shutdown

script
  cd \$APP_PATH
  exec forever start nuestra_app.js
end script
EOL

