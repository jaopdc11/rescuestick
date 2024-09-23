#!/bin/bash

# Função para exibir espaço em disco
function disk_space_analysis() {
    echo "=============================="
    echo " Análise de Espaço em Disco "
    echo "=============================="
    printf "%-30s %-15s %-15s %-10s\n" "Partição" "Tamanho" "Usado" "Disponível"
    echo "==========================================================="
    
    # Utiliza df para obter informações sobre o espaço em disco
    df -h --output=source,size,used,avail | tail -n +2 | while read line; do
        # Formatação para manter alinhamento
        printf "%-30s %-15s %-15s %-10s\n" $line
    done

    echo "=============================="
    echo " Pressione [0] para voltar. "
}

# Chama a função
disk_space_analysis

# Espera o usuário pressionar [0] para voltar
read -p "Digite sua escolha: " choice
if [[ "$choice" == "0" ]]; then
    exit 0
fi
