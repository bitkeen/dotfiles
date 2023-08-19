# From https://gist.github.com/psacawa/cfdccc956c16f8d0194a118ed2efb4a4
# the following is significantly bugged, and is made available for demonstration purposes
import sys
from typing import Optional

from IPython import get_ipython
from prompt_toolkit.filters import vi_navigation_mode
from prompt_toolkit.key_binding.bindings.vi import (
    TextObject, create_operator_decorator, create_text_object_decorator)

ip = get_ipython()
bindings = ip.pt_app.key_bindings
operator = create_operator_decorator(bindings)
text_object = create_text_object_decorator(bindings)
MATCHES = "(){}[]<>''\"\"``__--"
ALIASES = {
    'b': '(',
    'B': '{',
    'r': '[',
    'q': '"',
}


@text_object('s', no_move_handler=True)
def _(event):
    """A custom text object that matches everything. Enables yss( etc."""
    # Note that a `TextObject` has coordinates, relative to the cursor position.
    buff = event.current_buffer
    return TextObject(
        -buff.document.cursor_position,  # The start.
        len(buff.text) - buff.document.cursor_position,
    )  # The end.


def find_idx(char):
    if char in ALIASES:
        idx = MATCHES.find(ALIASES[char])
    else:
        idx = MATCHES.find(char)
    return idx


@operator('y', 's', filter=vi_navigation_mode)
def you_surround(event, text_object):
    buff = event.current_buffer

    # Get relative start/end coordinates.
    start, end = text_object.operator_range(buff.document)
    start += buff.cursor_position
    end += buff.cursor_position

    char = sys.stdin.read(1)
    idx = find_idx(char)
    if idx == -1:
        return
    left_ch = MATCHES[idx - (idx % 2)]
    right_ch = MATCHES[idx + 1 - (idx % 2)]
    text = left_ch + buff.text[start:end] + right_ch
    event.app.current_buffer.text = buff.text[:start] + text + buff.text[end:]


def find_enclosing_bracket_right(
    doc, left_ch: str, right_ch: str, depth=1, end_pos: Optional[int] = None
) -> Optional[int]:
    """
    Find the right bracket enclosing current position. Return the relative
    position to the cursor position. Break out of depth level of nesting.

    When `end_pos` is given, don't look past the position.
    """
    if doc.current_char == right_ch:
        return 0
    if end_pos is None:
        end_pos = len(doc.text)
    else:
        end_pos = min(len(doc.text), end_pos)
    stack = depth

    # Look forward.
    for i in range(doc.cursor_position + 1, end_pos):
        c = doc.text[i]
        if c == left_ch:
            stack += 1
        elif c == right_ch:
            stack -= 1
        if stack == 0:
            return i - doc.cursor_position

    return None


def find_enclosing_bracket_left(
    doc, left_ch: str, right_ch: str, depth=1, start_pos: Optional[int] = None
) -> Optional[int]:
    """
    Find the left bracket enclosing current position. Return the relative
    position to the cursor position. Break out of depth level of nesting.

    When `start_pos` is given, don't look past the position.
    """
    if doc.current_char == left_ch:
        return 0
    if start_pos is None:
        start_pos = 0
    else:
        start_pos = max(0, start_pos)
    stack = depth

    # Look backward.
    for i in range(doc.cursor_position - 1, start_pos - 1, -1):
        c = doc.text[i]
        if c == right_ch:
            stack += 1
        elif c == left_ch:
            stack -= 1
        if stack == 0:
            return i - doc.cursor_position

    return None


@bindings.add_binding('d', 's', filter=vi_navigation_mode)
def delete_surround(event):
    """Delete surrounding [](){}<>'" supporting depth"""
    buff = event.current_buffer
    text = event.current_buffer.text
    pos = buff.document.cursor_position

    depth = 1
    char = sys.stdin.read(1)
    # e.g. cs2([
    if char.isnumeric():
        depth = int(char)
        char = sys.stdin.read(1)
    idx = find_idx(char)
    if idx == -1:
        return
    left_ch = MATCHES[idx - (idx % 2)]
    right_ch = MATCHES[idx + 1 - (idx % 2)]
    # quote case ('," ) isn't handled by the stack counting machanism
    if char in r'\'\"':
        start = text[0:pos].rfind(char)
        end = text[pos + 1 :].find(char)
        if start == -1:
            start = None
        else:
            start -= pos
        if end == -1:
            end = None
        else:
            end += 1
    else:
        start = find_enclosing_bracket_left(buff.document, left_ch, right_ch, depth)
        end = find_enclosing_bracket_right(buff.document, left_ch, right_ch, depth)
    if start is not None and end is not None:
        start += pos
        end += pos
        event.current_buffer.text = (
            text[:start] + text[start + 1 : end] + text[end + 1 :]
        )


@bindings.add_binding('c', 's', filter=vi_navigation_mode)
def change_surround(event):
    """Change surrounding [](){}<>'" supporting depth."""
    buff = event.current_buffer
    pos = buff.document.cursor_position
    text = buff.document.text

    depth = 1
    char = sys.stdin.read(1)
    # e.g. cs2([
    if char.isnumeric():
        depth = int(char)
        char = sys.stdin.read(1)
    idx = find_idx(char)
    if idx == -1:
        return
    left_ch = MATCHES[idx - (idx % 2)]
    right_ch = MATCHES[idx + 1 - (idx % 2)]
    # new surrounding character
    new_char = sys.stdin.read(1)
    idx = find_idx(new_char)
    if idx == -1:
        return
    new_left_ch = MATCHES[idx - (idx % 2)]
    new_right_ch = MATCHES[idx + 1 - (idx % 2)]
    # quote case ('," ) isn't handled by the stack counting machanism
    if char in r'\'\"':
        start = text[0:pos].rfind(char)
        end = pos + 1 + text[pos + 1 :].find(char)
        if start == -1:
            start = None
        if end == -1:
            end = None
    else:
        start = find_enclosing_bracket_left(buff.document, left_ch, right_ch, depth)
        end = find_enclosing_bracket_right(buff.document, left_ch, right_ch, depth)
    if start is not None and end is not None:
        start += pos
        end += end
        text = (
            text[:start]
            + new_left_ch
            + text[start + 1 : end]
            + new_right_ch
            + text[end + 1 :]
        )
        event.current_buffer.text = text
