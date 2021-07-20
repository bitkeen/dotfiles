stdlib_imports = [
    'import json',
    'import math',
    'import os',
    'import pprint',
    'import random',
    'import re',
    'import sys',
    'import time',
    'import urllib.parse as up',
    'from datetime import date, datetime, timedelta',
]

external_imports = [
    'import requests',
]

for i in stdlib_imports:
    exec(i)
    print(f'>>> {i}')

print()  # Newline for visual separation.
for i in external_imports:
    try:
        exec(i)
    except Exception:
        print(f'>>> {i!r} failed')
    else:
        print(f'>>> {i}')
