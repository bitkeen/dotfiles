#!/usr/bin/env bash
# From https://github.com/maximbaz/dotfiles/commit/925a5b88a8263805a5a24c6198dad23bfa62f44d.

sessions=$(tmux ls | grep '^[0-9]\+:' | cut -f1 -d':' | sort)

new=0
for old in $sessions
do
  tmux rename -t $old $new
  ((new++))
done
