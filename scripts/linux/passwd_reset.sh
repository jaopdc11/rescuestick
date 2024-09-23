#!/bin/bash

# Verifica se o script está rodando como root
if [ "$EUID" -ne 0 ]; then
    echo "Você precisa rodar o script como root. Use sudo."
    exit 1
fi

# Monta o sistema de arquivos com permissão de escrita
mount -o remount,rw /

# Exibe os usuários do sistema
echo "Usuários disponíveis no sistema:"
cat /etc/passwd | grep '/home' | cut -d: -f1

# Solicita o nome do usuário
read -p "Digite o nome do usuário que você quer resetar a senha: " username

# Verifica se o usuário existe
if id "$username" &>/dev/null; then
    # Define a nova senha como '1234'
    echo "Mudando a senha do usuário $username para '1234'..."
    echo "$username:1234" | chpasswd

    # Mensagem de sucesso
    echo "Senha do usuário $username foi alterada para '1234'. Vai lá e loga!"

else
    echo "Usuário $username não encontrado!"
    exit 1
fi

# Reinicia o sistema
echo "Reiniciando o sistema..."
reboot
