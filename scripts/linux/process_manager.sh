#!/bin/bash

# Função para listar processos e armazenar em um array
list_processes() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        processes=($(ps aux --sort=-%mem | awk 'NR>1 {print $2","$11","$4","$8}' | head -n 100))
    else
        processes=($(tasklist | awk 'NR>3 {print $2","$1","$8","$7}' | head -n 100))
    fi
}

# Função para mostrar processos em páginas
show_processes() {
    local start=$1
    local end=$2
    clear  # Limpa a tela
    echo -e "\e[36m=============================="
    echo -e "Lista de Processos (Páginas)"
    echo -e "=============================="
    echo -e "ID    | Nome do Processo                              | RAM (%) | Disco (%)"
    echo -e "=============================="
    for (( i=start; i<end; i++ )); do
        [[ -z "${processes[i]}" ]] && break
        IFS=',' read -r pid name ram disk <<< "${processes[i]}"
        
        # Ajustando o nome do processo para caber na largura
        printf "%-6s | %-48s | %-7s | %-7s\n" "$pid" "$name" "$ram%" "${disk:-0%}"
    done
    echo -e "=============================="
}

# Função para finalizar um processo
kill_process() {
    while true; do
        read -p "Digite o ID do processo para finalizar (ou 0 para voltar): " pid
        if [[ "$pid" == "0" ]]; then
            return
        fi
        
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            kill -9 "$pid" 2>/dev/null
            if [[ $? -eq 0 ]]; then
                echo "Processo $pid finalizado com sucesso."
            else
                echo -e "\e[31mFalha ao finalizar o processo $pid. Verifique se o ID está correto.\e[0m"
            fi
        else
            taskkill /PID "$pid" /F 2>nul
            if [[ $? -eq 0 ]]; then
                echo "Processo $pid finalizado com sucesso."
            else
                echo -e "\e[31mFalha ao finalizar o processo $pid. Verifique se o ID está correto.\e[0m"
            fi
        fi
        break
    done
}

# Função principal
main() {
    list_processes
    local total_processes=${#processes[@]}
    local page_size=15
    local current_page=0

    while true; do
        show_processes $((current_page * page_size)) $((current_page * page_size + page_size))

        echo -e "\nPressione [N] para próxima página, [P] para página anterior, [K] para finalizar um processo, [0] para sair."
        read -n 1 input
        echo ""

        case $input in
            n|N)
                if (( (current_page + 1) * page_size < total_processes )); then
                    ((current_page++))
                fi
                ;;
            p|P)
                if (( current_page > 0 )); then
                    ((current_page--))
                fi
                ;;
            k|K)
                kill_process
                ;;
            0)
                break
                ;;
            *)
                echo -e "\e[31mOpção inválida! Pressione [N], [P], [K] ou [0].\e[0m"
                ;;
        esac
    done
}

main
