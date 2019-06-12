# See https://ipython.readthedocs.io/en/latest/config/details.html#keyboard-shortcuts.

from IPython import get_ipython
from prompt_toolkit.enums import DEFAULT_BUFFER
from prompt_toolkit.keys import Keys
from prompt_toolkit.filters import HasFocus, HasSelection

ip = get_ipython()

def clear_screen(event):
    event.cli.renderer.clear()

# Register the shortcut if IPython is using prompt_toolkit.
if getattr(ip, 'pt_app', None):
    registry = ip.pt_app.key_bindings
    registry.add_binding(
        Keys.ControlF,
        filter=(
            HasFocus(DEFAULT_BUFFER)
            & ~HasSelection()
        )
    )(clear_screen)
