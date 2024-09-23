from colorama import Fore, Style
import os

def cls():
    os.system('cls' if os.name == 'nt' else 'clear')

# Função para gerar gradiente de roxo para vermelho
def gradient(start, end, steps):
    return [f'\033[38;2;{int(start[0] + (end[0] - start[0]) * (i / (steps - 1)))};{int(start[1] + (end[1] - start[1]) * (i / (steps - 1)))};{int(start[2] + (end[2] - start[2]) * (i / (steps - 1)))}m' for i in range(steps)]

# Definindo as cores de início e fim do gradiente
start_color = (128, 0, 128)  # Roxo
end_color = (255, 0, 0)      # Vermelho

# Número de passos no gradiente (número de linhas)
steps = 6

# Gerar as cores do gradiente
gradients = gradient(start_color, end_color, steps)

# ASCII Art com gradiente
ascii_art = [
    "██████╗ ███████╗███████╗ ██████╗██╗   ██╗███████╗███████╗████████╗██╗ ██████╗██╗  ██╗",
    "██╔══██╗██╔════╝██╔════╝██╔════╝██║   ██║██╔════╝██╔════╝╚══██╔══╝██║██╔════╝██║ ██╔╝",
    "██████╔╝█████╗  ███████╗██║     ██║   ██║█████╗  ███████╗   ██║   ██║██║     █████╔╝ ",
    "██╔══██╗██╔══╝  ╚════██║██║     ██║   ██║██╔══╝  ╚════██║   ██║   ██║██║     ██╔═██╗ ",
    "██║  ██║███████╗███████║╚██████╗╚██████╔╝███████╗███████║   ██║   ██║╚██████╗██║  ██╗",
    "╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚══════╝╚══════╝   ╚═╝   ╚═╝ ╚═════╝╚═╝  ╚═╝"
]

def print_ascii_title():
    # Imprimir o ASCII Art com o gradiente
    for i, line in enumerate(ascii_art):
        print(f'{gradients[i % steps]}{line}')
    print(Style.RESET_ALL)
