#!/bin/bash

# Função para listar interfaces de rede
list_network_interfaces() {
    interfaces=($(ip -o link show | awk -F': ' '{print $2}'))
    echo "Interfaces de Rede Disponíveis:"
    for i in "${!interfaces[@]}"; do
        echo "$((i + 1)): ${interfaces[$i]}"
    done
}

# Função para testar ping
test_ping() {
    local target=$1
    ping -c 4 "$target" &>/dev/null
    if [[ $? -eq 0 ]]; then
        echo -e "\e[32mPing em $target: OK\e[0m"
    else
        echo -e "\e[31mPing em $target: Falhou\e[0m"
    fi
}

# Função para testar velocidade de download e upload
test_speed() {
    speed_output=$(speedtest-cli --simple)
    echo "$speed_output"
}

# Função principal
main() {
    list_network_interfaces
    read -p "Digite o número da interface que você quer testar: " interface_number
    selected_interface=${interfaces[$((interface_number - 1))]}

    # Obtendo o IP do roteador
    router_ip=$(ip route | grep default | awk '{print $3}')
    echo "Roteador encontrado: $router_ip"

    # Mostrando loading
    echo -n "Testando conexão"
    for i in {1..3}; do
        echo -n "."
        sleep 1
    done
    echo ""

    # Testando ping
    test_ping "$router_ip" &
    test_ping "google.com" &
    wait

    # Testando velocidade
    echo "Testando velocidade de upload e download..."
    speed_output=$(test_speed)

    # Exibindo resultados
    clear
    echo -e "\e[36m=============================="
    echo -e "Resultados do Teste de Conexão"
    echo -e "=============================="
    echo -e "Roteador: $router_ip"
    echo -e "$speed_output"
    echo -e "=============================="
    echo -e "Pressione [0] para voltar."
    
    # Esperando entrada do usuário sem precisar dar enter
    while true; do
        read -n 1 input
        if [[ "$input" == "0" ]]; then
            break
        fi
    done
}

main
