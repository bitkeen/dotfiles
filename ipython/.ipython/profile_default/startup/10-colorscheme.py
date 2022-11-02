# https://github.com/memeplex/base16-prompt-toolkit
#
# For `ModuleNotFoundError: No module named 'prompt_toolkit.terminal`
# see https://github.com/memeplex/base16-prompt-toolkit/issues/4.

import importlib
import os
import re

from utils import print_error

# Get the name of the theme currently used in Vim.
with open(f'{os.environ["HOME"]}/.vimrc_background') as fin:
    text = fin.read()
colorscheme = re.search('(?<=colorscheme )(.*)', text).group(0)

try:
    theme = importlib.import_module(f'base16_prompt_toolkit.{colorscheme}')
except ModuleNotFoundError as e:
    print_error(e)
else:
    import IPython
    import prompt_toolkit
    from prompt_toolkit.styles.pygments import pygments_token_to_classname
    from prompt_toolkit.styles.style import Style

    # See https://github.com/ipython/ipython/issues/11526.
    def my_style_from_pygments_dict(pygments_dict):
        """Monkey patch prompt toolkit style function to fix completion colors."""
        pygments_style = []
        for token, style in pygments_dict.items():
            if isinstance(token, str):
                pygments_style.append((token, style))
            else:
                pygments_style.append((pygments_token_to_classname(token), style))

        return Style(pygments_style)

    prompt_toolkit.styles.pygments.style_from_pygments_dict = my_style_from_pygments_dict
    IPython.terminal.interactiveshell.style_from_pygments_dict = my_style_from_pygments_dict
    theme.overrides.update({
        'completion-menu': f'bg:{theme.base01} {theme.base05}',
        'completion-menu.completion.current': f'bg:{theme.base05} {theme.base01}',
        'completion-menu.completion': f'bg:{theme.base01} {theme.base05}',
        'completion-menu.multi-column-meta': f'bg:{theme.base00} {theme.base05}',
    })

    ip = get_ipython()
    ip.highlighting_style = theme.Base16Style
    ip.highlighting_style_overrides = theme.overrides
