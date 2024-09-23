#!/bin/bash

# Verifica se tá rodando como root
if [ "$EUID" -ne 0 ]; then
    echo "Você precisa rodar isso como root! 😡"
    exit 1
fi

# Atualiza a lista de pacotes
echo "Atualizando a lista de pacotes..."
apt update -y

# Atualiza os pacotes instalados
echo "Atualizando os pacotes instalados..."
apt upgrade -y

# Remove pacotes desnecessários
echo "Removendo pacotes desnecessários..."
apt autoremove -y

echo "Atualização do sistema concluída! 🎉"

# Pergunta se o usuário quer reiniciar
read -p "Deseja reiniciar agora? (s/N): " choice
if [ "$choice" == "s" ]then; 
    sudo reboot
fi
