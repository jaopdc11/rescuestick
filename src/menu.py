import os
import stat
import platform
import subprocess
from colorama import Fore, Style

# Função para verificar e conceder permissão de execução (silenciosa)
def ensure_executable(file_path):
    if os.path.isfile(file_path):
        st = os.stat(file_path)
        if not (st.st_mode & stat.S_IXUSR):  # Verifica se o arquivo tem permissão de execução
            os.chmod(file_path, st.st_mode | stat.S_IXUSR)  # Concede permissão de execução

def check_and_prepare_scripts(tool_path):
    if tool_path:
        ensure_executable(tool_path)  # Verifica e ajusta as permissões se necessário

def display_menu():
    menu = [
        '1. Resetar Senha',
        '2. Otimizar',
        '3. Backup',
        '4. Atualizar Sistema',
        '5. Análise de Espaço em Disco',
        '6. Gerenciamento de Processos',
        '7. Reparo de Pacotes',
        '8. Limpeza de Inicialização',
        '9. Testar Conexão de Rede',
        '0. Sair'
    ]
    print(f'{Fore.CYAN}Escolha uma opção:{Style.RESET_ALL}')
    for item in menu:
        print(f'{Fore.YELLOW}{item}{Style.RESET_ALL}')

def execute_tool(option):
    os_name = platform.system().lower()
    tool_paths = {
        'windows': {
            '1': 'scripts/windows/passwd_reset.bat',
            '2': 'scripts/windows/otimizar.bat',
            '3': 'scripts/windows/backup.bat',
            '4': 'scripts/windows/update.bat',
            '5': 'scripts/windows/disk_analysis.bat',
            '6': 'scripts/windows/process_manager.bat',
            '7': 'scripts/windows/package_repair.bat',
            '8': 'scripts/windows/startup_cleanup.bat',
            '9': 'scripts/windows/network_test.bat'
        },
        'linux': {
            '1': 'scripts/linux/passwd_reset.sh',
            '2': 'scripts/linux/cleaner.sh',
            '3': 'scripts/linux/backup.sh',
            '4': 'scripts/linux/update.sh',
            '5': 'scripts/linux/disk_analysis.sh',
            '6': 'scripts/linux/process_manager.sh',
            '7': 'scripts/linux/package_repair.sh',
            '8': 'scripts/linux/startup_cleanup.sh',
            '9': 'scripts/linux/network_test.sh'
        }
    }
    tool_path = tool_paths.get(os_name, {}).get(option, '')
    if tool_path:
        check_and_prepare_scripts(tool_path)  # Verifica permissões antes de executar
        print(f'{Fore.GREEN}Executando ferramenta em {tool_path}{Style.RESET_ALL}')
        try:
            subprocess.run(tool_path, check=True, shell=True)
        except subprocess.CalledProcessError as e:
            print(f'{Fore.RED}Erro ao executar a ferramenta: {e}{Style.RESET_ALL}')
    else:
        print(f'{Fore.RED}Opção inválida!{Style.RESET_ALL}')
