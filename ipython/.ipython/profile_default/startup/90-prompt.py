import os
from pathlib import Path

from IPython.terminal.prompts import Prompts, Token


def get_venv() -> str:
    venv = os.environ.get('VIRTUAL_ENV', None)
    return f' ({Path(venv).stem})' if venv else ''


class MyPrompt(Prompts):

    def in_prompt_tokens(self, cli=None):
        return [
            (Token.Prompt, 'In ['),
            (Token.PromptNum, str(self.shell.execution_count)),
            (Token.Prompt, ']'),
            (Token.Name.Class, get_venv()),
            (Token.Prompt, ': '),
        ]


ip = get_ipython()
ip.prompts = MyPrompt(ip)
