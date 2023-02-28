stdlib_imports = [
    'import dis',
    'import json',
    'import html',
    'import math',
    'import os',
    'import random',
    'import re',
    'import sys',
    'import time',
    'import urllib.parse as up',
    'from datetime import date, datetime, timedelta',
    'from pprint import pprint; pp = pprint',
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
