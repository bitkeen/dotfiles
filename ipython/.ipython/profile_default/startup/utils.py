FAIL = '\033[91m'
ENDC = '\033[0m'


def print_error(error):
    print(f'{FAIL}{error}{ENDC}')
