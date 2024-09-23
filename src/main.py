from os_info import print_colored_os_info
from menu import display_menu, execute_tool
from utils import print_ascii_title, cls
from colorama import init, Fore, Style

def main():
    init()
    while True:
        cls()
        print_ascii_title()
        print_colored_os_info()
        display_menu()
        try:
            choice = input('Digite sua escolha: ')
        except KeyboardInterrupt:
            cls()
            print(f'\n\n{Fore.RED}Saindo...{Style.RESET_ALL}')
            break
        except ValueError:
            print('Opção inválida. Por favor, tente novamente.')
            continue
        if choice == '0':
            cls()
            print(f'{Fore.RED}Saindo...{Style.RESET_ALL}')
            exit()
        try:
            execute_tool(choice)
        except KeyboardInterrupt:
            cls()
            print(f'{Fore.RED}Saindo...{Style.RESET_ALL}')
            exit()
        continue

if __name__ == '__main__':
    main()
