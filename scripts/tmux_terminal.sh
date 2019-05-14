#!/usr/bin/env bash
# Attach to a tmux session with number as its name if it exists,
# create a new session if it doesn't.

# \ before `grep` - bypass aliases.
# -P - use for Perl-style regexps.
# -v - invert the match.
# -o - print only matched parts.
# -m NUM - stop after NUM matching lines.
session_name="$(tmux ls | \
                \grep -v -P '\(attached\)$' | \
                \grep -o -P -m 1 '^(\d+)(?=: )')"

if [ -n "$session_name" ]; then
    i3 "exec --no-startup-id urxvt -e bash -i -c 'tmux attach -t $session_name'"
else
    i3 "exec --no-startup-id urxvt -e bash -i -c 'tmux'"
fi
