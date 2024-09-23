import platform
import psutil
import subprocess
import os
from colorama import Fore, Style

def is_root():
    return os.geteuid() == 0

def get_cpu_info():
    try:
        if platform.system() == 'Windows':
            result = subprocess.check_output("wmic cpu get caption", shell=True).decode().strip()
            return result.split('\n')[1] if '\n' in result else 'Unknown CPU'
        else:
            result = subprocess.check_output("lscpu | grep 'Model name'", shell=True).decode().strip()
            return result.split(':', 1)[1].strip() if ':' in result else 'Unknown CPU'
    except Exception as e:
        return f'Error: {e}'

def get_gpu_info():
    try:
        if platform.system() == 'Windows':
            result = subprocess.check_output("wmic path win32_VideoController get caption", shell=True).decode().strip()
            return result.split('\n')[1] if '\n' in result else 'Unknown GPU'
        else:
            result = subprocess.check_output(['lspci'], encoding='utf-8')
            for line in result.splitlines():
                if 'VGA compatible controller' in line:
                    return line.split(':', 1)[1].strip()
            return 'Unknown GPU'
    except Exception as e:
        return f'Error: {e}'

def get_memory_info():
    try:
        ram_info = psutil.virtual_memory()
        ram_total_mb = ram_info.total // (1024 ** 2)  # Convertendo bytes para MB
        
        if platform.system() == 'Windows':
            ram_type = 'Unknown DDR'
            rom_total_mb = psutil.disk_usage('/').total // (1024 ** 2)
        else:
            ram_type = 'Unknown DDR'
            try:
                ddr_info = subprocess.check_output(['dmidecode', '-t', 'memory'], encoding='utf-8')
                for line in ddr_info.splitlines():
                    if 'Type:' in line:
                        ram_type = line.split(':', 1)[1].strip()
                        break
            except FileNotFoundError:
                ram_type = 'Não disponível'
            rom_total_mb = psutil.disk_usage('/').total // (1024 ** 2)
        
        ram = f'{ram_total_mb} MB ({ram_type})'
        return ram, rom_total_mb
    except Exception as e:
        return 'Não disponível', 'Unknown'

def get_os_info():
    try:
        os_name = platform.system()
        if os_name == 'Windows':
            import winreg
            version = platform.version()
            if '10' in version:
                os_name = 'Windows 10'
            elif '11' in version:
                os_name = 'Windows 11'
            else:
                os_name = 'Unknown Windows Version'
            try:
                with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Microsoft\Windows NT\CurrentVersion") as key:
                    product_name = winreg.QueryValueEx(key, 'ProductName')[0]
                    edition_id = winreg.QueryValueEx(key, 'EditionID')[0]
                    return f'{os_name} ({product_name}, {edition_id})'
            except Exception as e:
                return f'{os_name} (Error: {e})'
        elif os_name == 'Linux':
            try:
                with open('/etc/os-release') as f:
                    lines = f.readlines()
                    distro_info = {line.split('=')[0]: line.split('=')[1].strip().strip('"') for line in lines if '=' in line}
                    return f'{distro_info.get("NAME", "Unknown Linux Distribution")} {distro_info.get("VERSION", "")}'
            except FileNotFoundError:
                return 'Unknown Linux Distribution'
        else:
            return 'Unknown OS'
    except Exception as e:
        return f'Error: {e}'

def print_colored_os_info():
    os_info = get_os_info()
    cpu_info = get_cpu_info()
    gpu_info = get_gpu_info()
    ram_info, rom_info = get_memory_info()

    print(f'{Fore.CYAN}Sistema Operacional: {os_info}{Style.RESET_ALL}')
    print(f'{Fore.BLUE}CPU: {cpu_info}{Style.RESET_ALL}')
    print(f'{Fore.GREEN}GPU: {gpu_info}{Style.RESET_ALL}')
    print(f'{Fore.YELLOW}Memória RAM: {ram_info}{Style.RESET_ALL}')
    print(f'{Fore.MAGENTA}Memória ROM: {rom_info} MB{Style.RESET_ALL}')
    print()

    if not is_root():
        print(f'{Fore.RED}Aviso: Para obter informações completas sobre a memória RAM e a placa-mãe, execute este script como root/superusuário.{Style.RESET_ALL}')
