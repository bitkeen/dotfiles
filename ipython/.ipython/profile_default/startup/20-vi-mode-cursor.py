# From https://github.com/prompt-toolkit/python-prompt-toolkit/issues/192,
# adapted for Tmux.

import os
import sys

from prompt_toolkit.application.current import get_app
from prompt_toolkit.key_binding.vi_state import InputMode, ViState

ip = get_ipython()
ip.prompt_includes_vi_mode = False


def get_input_mode(self):
    app = get_app()
    app.ttimeoutlen = ip.ttimeoutlen
    app.timeoutlen = ip.timeoutlen

    return self._input_mode

def set_input_mode(self, mode):
    shape = {
        InputMode.NAVIGATION: 2,
        InputMode.REPLACE_SINGLE: 3,
        InputMode.REPLACE: 3,
        InputMode.INSERT: 5,
    }.get(mode)
    cursor = '\x1b[{} q'.format(shape)

    sys.stdout.write(cursor)
    sys.stdout.flush()

    self._input_mode = mode

ViState._input_mode = InputMode.INSERT
ViState.input_mode = property(get_input_mode, set_input_mode)
