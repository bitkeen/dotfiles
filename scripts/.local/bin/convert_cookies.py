#!/usr/bin/env python3
"""Convert cookies from Base64 encoded (optional) Python SimpleCookie
JSON to Firefox cookie format. Take file name or cookie text as input,
print the result.

Two output formats are supported: JSON and header string.
"""
import argparse
import base64
import json


def get_args():
    """Set up argument parser."""
    p = argparse.ArgumentParser(description='Convert cookies')
    p.add_argument('input', type=str, help='input text or file name')
    p.add_argument('-n', '--no-base64', action='store_const',
                   const=True, default=False,
                   help='input is not Base64-encoded')
    p.add_argument('-j', '--json', action='store_const',
                   const=True, default=False,
                   help='format output as JSON')
    return p.parse_args()


def convert(cookie_in, no_base64):
    """Process cookie string, return list of dicts."""
    if not no_base64:
        cookie_in = base64.b64decode(cookie_in)

    json_in = json.loads(cookie_in)
    morsels = []
    for key in json_in:
        m = {}
        m['name'] = json_in[key]['_key']
        m['value'] = json_in[key]['_value']
        for item_key in json_in[key]['_items']:
            m[item_key] = json_in[key]['_items'][item_key]
        morsels.append(m)

    return morsels


def header_format(morsels):
    """Convert list of morsels to a header string."""
    return '; '.join('{}={}'.format(m['name'], m['value']) for m in morsels)


def main():
    args = get_args()

    try:
        # Treat args.input as file.
        with open(args.input) as fin:
            cookie_in = ''.join(fin.readlines())
    except (OSError, FileNotFoundError):
        # Treat args.input as text.
        cookie_in = args.input

    morsels = convert(cookie_in, args.no_base64)
    if args.json:
        res = json.dumps(morsels)
    else:
        res = header_format(morsels)

    print(res)


if __name__ == '__main__':
    main()
