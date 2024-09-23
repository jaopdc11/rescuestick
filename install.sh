#!/bin/bash

# Faz o script parar se algum comando falhar
set -e

# Verifica se o arquivo está sendo executado em sudo
if [ "$(id -u)" != "0" ]; then
    echo "Este script deve ser executado com privilégios de superusuário."
    exit 1
fi

# Atualiza o repositório e instala o Python e os pacotes necessários, se não estiverem instalados
apt-get update

# Instala pacotes se não estiverem presentes
apt-get install -y python3 pv speedtest-cli

# Instala os pacotes necessários pelo "requirements.txt"
pip3 install -r requirements.txt

# Concede permissão de execução ao arquivo "run.sh"
chmod +x run.sh

echo "Instalado com sucesso! Execute com './run.sh'."
