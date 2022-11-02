# From https://github.com/prompt-toolkit/python-prompt-toolkit/issues/192,
# adapted for Tmux.

import os
import sys

from prompt_toolkit.key_binding.vi_state import InputMode, ViState


def get_input_mode(self):
    return self._input_mode


def set_input_mode(self, mode):
    # For REPLACE_SINGLE prompt-toolkit >= 3.0.6 is required.
    shape = {
        InputMode.NAVIGATION: 2,
        InputMode.REPLACE_SINGLE: 3,
        InputMode.REPLACE: 3,
        InputMode.INSERT: 5,
    }.get(mode)
    if 'TMUX' in os.environ:
        raw = u'\x1bPtmux;\x1b\x1b[{} q\x1b\\'.format(shape)
    else:
        raw = u'\x1b[{} q'.format(shape)

    out = sys.stdout.write
    out(raw)
    sys.stdout.flush()
    self._input_mode = mode


ViState._input_mode = InputMode.INSERT
ViState.input_mode = property(get_input_mode, set_input_mode)
ip = get_ipython()
ip.prompt_includes_vi_mode = False
