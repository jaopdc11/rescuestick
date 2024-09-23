#!/bin/bash

# Função para listar aplicativos de inicialização e armazenar em um array
list_startup_apps() {
    startup_apps=()
    app_id=1

    # Obtendo aplicativos de inicialização
    for app in /etc/xdg/autostart/*; do
        app_name=$(basename "$app" .desktop)
        startup_apps+=("$app_id,$app_name")
        ((app_id++))
    done
}

# Função para mostrar aplicativos em páginas
show_startup_apps() {
    local start=$1
    local end=$2
    clear  # Limpa a tela
    echo -e "\e[36m=============================="
    echo -e "Aplicativos de Inicialização (Páginas)"
    echo -e "=============================="
    echo -e "ID    | Nome do Aplicativo                             "
    echo -e "=============================="
    for (( i=start; i<end; i++ )); do
        [[ -z "${startup_apps[i]}" ]] && break
        IFS=',' read -r id name <<< "${startup_apps[i]}"
        
        # Ajustando o nome do aplicativo para caber na largura
        printf "%-6s | %-48s\n" "$id" "$name"
    done
    echo -e "=============================="
}

# Função para desmarcar um aplicativo
disable_startup_app() {
    while true; do
        read -p "Digite o ID do aplicativo para desmarcar (ou 0 para voltar): " app_id
        if [[ "$app_id" == "0" ]]; then
            return
        fi

        app_file="/etc/xdg/autostart/${startup_apps[$app_id]}.desktop"
        if [[ -f "$app_file" ]]; then
            mv "$app_file" "$app_file.bak"
            echo "Aplicativo '${startup_apps[$app_id]}' desmarcado para inicialização."
        else
            echo -e "\e[31mAplicativo não encontrado! Verifique o ID.\e[0m"
        fi
        break
    done
}

# Função principal
main() {
    list_startup_apps
    local total_apps=${#startup_apps[@]}
    local page_size=15
    local current_page=0

    while true; do
        show_startup_apps $((current_page * page_size)) $((current_page * page_size + page_size))

        echo -e "\nPressione [N] para próxima página, [P] para página anterior, [D] para desmarcar um aplicativo, [0] para sair."
        read -n 1 input
        echo ""

        case $input in
            n|N)
                if (( (current_page + 1) * page_size < total_apps )); then
                    ((current_page++))
                fi
                ;;
            p|P)
                if (( current_page > 0 )); then
                    ((current_page--))
                fi
                ;;
            d|D)
                disable_startup_app
                ;;
            0)
                break
                ;;
            *)
                echo -e "\e[31mOpção inválida! Pressione [N], [P], [D] ou [0].\e[0m"
                ;;
        esac
    done
}

main
