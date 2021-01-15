imports = [
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

for i in imports:
    exec(i)
    print(f'>>> {i}')
