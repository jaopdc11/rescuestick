#!/bin/bash

# Função para reparar pacotes
function repair_packages() {
    # Verifica se o script está rodando como root
    if [ "$EUID" -ne 0 ]; then
        echo "Você precisa rodar o script como root. Use sudo."
        exit 1
    fi

    echo "Iniciando o reparo de pacotes..."

    # Atualiza a lista de pacotes
    echo "Atualizando a lista de pacotes..."
    apt update

    # Tenta reparar pacotes quebrados
    echo "Tentando reparar pacotes quebrados..."
    apt --fix-broken install -y

    # Remove pacotes desnecessários
    echo "Removendo pacotes desnecessários..."
    apt autoremove -y

    # Limpa o cache de pacotes
    echo "Limpando o cache de pacotes..."
    apt clean

    echo "Reparo de pacotes concluído!"
    echo "Digite 0 para voltar ao menu."
    read -p "Pressione [Enter] para continuar ou digite 0 para voltar: " choice

    if [[ "$choice" == "0" ]]; then
        echo "Voltando..."
        return
    fi
}

# Chama a função
repair_packages
