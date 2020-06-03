# See https://ipython.readthedocs.io/en/latest/config/details.html#keyboard-shortcuts.

from IPython import get_ipython
from prompt_toolkit.enums import DEFAULT_BUFFER
from prompt_toolkit.keys import Keys
from prompt_toolkit.key_binding.bindings.named_commands import get_by_name
from prompt_toolkit.filters import HasFocus, HasSelection

ip = get_ipython()

# Register the shortcut if IPython is using prompt_toolkit.
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
