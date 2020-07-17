# See https://ipython.readthedocs.io/en/latest/config/details.html#keyboard-shortcuts.
import sqlite3
from pathlib import Path

import plumbum
import pyfzf
from IPython import get_ipython
from prompt_toolkit.enums import DEFAULT_BUFFER
from prompt_toolkit.keys import Keys
from prompt_toolkit.key_binding.bindings.named_commands import get_by_name
from prompt_toolkit.filters import HasFocus, HasSelection

ip = get_ipython()

hist_db_file = f'{str(Path.home())}/.ipython/profile_default/history.sqlite'
hist_select_query = """
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

    pyfzf from https://github.com/bitkeen/pyfzf is required.
    """
    conn = sqlite3.connect(hist_db_file)
    cur = conn.cursor()
    hist_rows = [r[0] for r in cur.execute(hist_select_query)]

    fzf = pyfzf.FzfPrompt()
    try:
        selection = '\n'.join(
            fzf.prompt(choices=hist_rows,
                       fzf_options='--read0',
                       delimiter='\0')
        )
        event.current_buffer.insert_text(selection)
    except (IndexError, plumbum.commands.processes.ProcessExecutionError):
        pass

# Register the shortcuts if IPython is using prompt_toolkit.
if getattr(ip, 'pt_app', None):
    registry = ip.pt_app.key_bindings

    registry.add(
        Keys.ControlF,
        filter=(
            HasFocus(DEFAULT_BUFFER)
            & ~HasSelection()
        )
    )(get_by_name("clear-screen"))

    # Add c-a and c-e to vi mode.
    registry.add(
        Keys.ControlA,
        filter=(
            HasFocus(DEFAULT_BUFFER)
            & ~HasSelection()
        )
    )(get_by_name("beginning-of-line"))

    registry.add(
        Keys.ControlE,
        filter=(
            HasFocus(DEFAULT_BUFFER)
            & ~HasSelection()
        )
    )(get_by_name("end-of-line"))

    # Use fzf for history.
    registry.add(
        Keys.ControlR,
        filter=HasFocus(DEFAULT_BUFFER)
    )(fzf_history)
