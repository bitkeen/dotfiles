# See https://ipython.readthedocs.io/en/latest/config/details.html#keyboard-shortcuts.
import sqlite3
from pathlib import Path

from IPython import get_ipython
from prompt_toolkit.enums import DEFAULT_BUFFER
from prompt_toolkit.filters import has_focus, has_selection, has_suggestion
from prompt_toolkit.key_binding.bindings.named_commands import get_by_name
from prompt_toolkit.keys import Keys

FAIL = '\033[91m'
ENDC = '\033[0m'

def try_import(module):
    try:
        globals()[module] = __import__(module)
    except ModuleNotFoundError as e:
        print(f'{FAIL}{e}{ENDC}')


try_import('plumbum')
try_import('pyfzf')
try_import('pyperclip')

FZF_OPTIONS = ('--read0'
               ' --preview "echo {} | bat --plain --color always -l python"'
               ' --preview-window="nohidden"')
HIST_DB_FILE = f'{(Path.home())}/.ipython/profile_default/history.sqlite'
HIST_SELECT_QUERY = """
SELECT DISTINCT
    source_raw
FROM
    history
ORDER BY
    session DESC,
    line DESC
"""


def fzf_history(event):
    """Get item from history with fzf.

    pyfzf is required.
    """
    conn = sqlite3.connect(HIST_DB_FILE)
    cur = conn.cursor()
    hist_rows = [r[0] for r in cur.execute(HIST_SELECT_QUERY)]

    fzf = pyfzf.FzfPrompt()
    try:
        selection = '\n'.join(
            fzf.prompt(choices=hist_rows,
                       fzf_options=FZF_OPTIONS,
                       delimiter='\0')
        )
        event.current_buffer.insert_text(selection)
    except (IndexError, plumbum.commands.processes.ProcessExecutionError):
        pass


def copyline(event):
    try:
        pyperclip.copy(event.current_buffer.text)
    except NameError:
        pass


if 'plumbum' in locals() and 'pyfzf' in locals():
    ip = get_ipython()

    # Register the shortcuts if IPython is using prompt_toolkit.
    if getattr(ip, 'pt_app', None):
        registry = ip.pt_app.key_bindings

        registry.add(
            Keys.ControlF,
            filter=(
                has_focus(DEFAULT_BUFFER)
                & ~has_selection
            )
        )(get_by_name('clear-screen'))

        # Add c-a and c-e to vi mode.
        registry.add(
            Keys.ControlA,
            filter=(
                has_focus(DEFAULT_BUFFER)
                & ~has_selection
            )
        )(get_by_name('beginning-of-line'))

        registry.add(
            Keys.ControlE,
            filter=(
                has_focus(DEFAULT_BUFFER)
                & ~has_selection
                & ~has_suggestion
            )
        )(get_by_name('end-of-line'))

        # Use fzf for history.
        registry.add(
            Keys.ControlR,
            filter=has_focus(DEFAULT_BUFFER)
        )(fzf_history)

        # Copy current buffer.
        registry.add(
            Keys.ControlSquareClose,
            filter=has_focus(DEFAULT_BUFFER)
        )(copyline)
