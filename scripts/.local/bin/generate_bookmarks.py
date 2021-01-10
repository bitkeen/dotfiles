#!/usr/bin/env python3
"""Generate bookmarks for Firefox from a CSV file. The first column
should contain names of the bookmarks, the second should contain URLs.
Output an HTML file that can be imported in Firefox. After importing
the bookmarks will be localted in Bookmarks Menu.
"""
import argparse
import time


def get_args():
    """Set up argument parser. The only required argument is
    input file name.
    """
    p = argparse.ArgumentParser(description='Generate bookmarks for Firefox.')
    p.add_argument('csv', type=str,
                   help='input file name')
    p.add_argument('-o', '--file-out', type=str, default='bookmarks',
                   help='output file name')
    p.add_argument('-f', '--folder', type=str, default='Generated bookmarks',
                   help='generated bookmarks folder name')
    p.add_argument('-n', '--no-time', action='store_const',
                   const=True, default=False,
                   help='do not include current time in file and folder name')
    return p.parse_args()


if __name__ == '__main__':
    args = get_args()

    filename_in = args.csv
    filename_out = args.file_out
    folder_name = args.folder
    no_time = args.no_time

    # Set up output filename and bookmarks folder format.
    if no_time:
        filename_out += '.html'
    else:
        time_str = time.strftime('-%Y-%m-%d-%H-%M-%S', time.localtime())
        folder_name += time_str
        filename_out = filename_out + time_str + '.html'

    # Read data from the input file.
    with open(filename_in) as fin:
        bookmark_data = [line.split(',') for line in fin]

    # Format everything.
    folder = f'    <DT><H3>{folder_name}</H3>'

    bm_fstr = '        <DT><A HREF="{url}" SHORTCUTURL="{name}">{name}</A>'
    bm_list = [bm_fstr.format(name=bm[0].strip(), url=bm[1].strip())
               for bm in bookmark_data]
    bookmarks = '\n'.join(bm_list)

    res = f'<!DOCTYPE NETSCAPE-Bookmark-file-1>\n'\
          f'<TITLE>Bookmarks</TITLE>\n'\
          f'<H1>Bookmarks Menu</H1>\n'\
          f'<DL>\n'\
          f'{folder}\n'\
          f'    <DL>\n'\
          f'{bookmarks}\n'\
          f'    </DL>\n'\
          f'</DL>\n'\

    # Write the bookmarks to the output file.
    with open(filename_out, 'w') as fout:
        fout.write(res)
