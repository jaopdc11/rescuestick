#!/bin/bash

# Limpa arquivos temporários do sistema
echo "Limpando arquivos temporários do sistema..."
sudo rm -rf /tmp/*

# Limpa cache do usuário
echo "Limpando cache do usuário..."
rm -rf ~/.cache/*

echo "Limpeza concluída!"

# Pergunta se o usuário quer reiniciar
read -p "Deseja reiniciar agora? (s/N): " choice
if [ "$choice" == "s" ]then; 
    sudo reboot
fi
