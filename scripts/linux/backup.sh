#!/bin/bash

# Verifica se tá rodando como root
if [ "$EUID" -ne 0 ]; then
    echo "Você precisa rodar isso como root!"
    exit 1
fi

# Define o diretório de backup
backup_dir="/backup"
timestamp=$(date +"%Y%m%d_%H%M%S")
backup_file="$backup_dir/home_backup_$timestamp.tar.gz"

# Cria o diretório de backup se não existir
mkdir -p "$backup_dir"

# Faz o backup da pasta home com barra de progresso
echo "Fazendo backup da pasta /home..."
tar -czf - /home/ | pv -s $(du -sb /home | awk '{print $1}') > "$backup_file"

# Confirmação
if [ $? -eq 0 ]; then
    read -p "Backup da pasta /home feito com sucesso em: $backup_file 🎉"
else
    read -p "Erro ao fazer o backup! 😡"
fi
