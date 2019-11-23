#!/usr/bin/env perl
# Copyright (C) 2014 Tony Crisci <tony@dubstepdish.com>
# Copyright (C) 2015 Thiago Perrotta <perrotta dot thiago at poli dot ufrj dot br>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Requires playerctl binary to be in your path (except cmus)
# See: https://github.com/acrisci/playerctl

# Set instance=NAME in the i3blocks configuration to specify a music player
# (playerctl will attempt to connect to org.mpris.MediaPlayer2.[NAME] on your
# DBus session).

# This is a modified version of the default mediaplayer block.
# Unnecessary parts were removed.
# Playing/paused indicators were added.

use Env qw(BLOCK_INSTANCE);

my $player_arg = "";

if ($BLOCK_INSTANCE) {
    $player_arg = "--player='$BLOCK_INSTANCE'";
}

sub buttons {
    my $method = shift;

    if($method eq 'mpd') {
        if ($ENV{'BLOCK_BUTTON'} == 1) {
            system("mpc toggle");
        } elsif ($ENV{'BLOCK_BUTTON'} == 2) {
            system("mpc_prev_wrapper");
        } elsif ($ENV{'BLOCK_BUTTON'} == 3) {
            system("mpc next");
        }
    } elsif ($method eq 'playerctl') {
        if ($ENV{'BLOCK_BUTTON'} == 1) {
            system("playerctl $player_arg play-pause");
        } elsif ($ENV{'BLOCK_BUTTON'} == 2) {
            system("playerctl $player_arg previous");
        } elsif ($ENV{'BLOCK_BUTTON'} == 3) {
            system("playerctl $player_arg next");
        } elsif ($ENV{'BLOCK_BUTTON'} == 4) {
            system("playerctl $player_arg volume 0.01+");
        } elsif ($ENV{'BLOCK_BUTTON'} == 5) {
            system("playerctl $player_arg volume 0.01-");
        }
    }
}

sub mpd {
    my $data = qx(mpc current);

    my $status = qx(mpc);
    if (index($status, "playing") != -1) {
        $status = "";
    } elsif (index($status, "paused") != -1) {
        $status = "";
    } else {
        exit(0);
    }

    if (not $data eq '') {
        buttons("mpd");
        print "$status  $data";
        exit 0;
    }
}

sub playerctl {
    # remove newline symbol from the end
    my $status = substr qx(playerctl status), 0, -1;
    # exit status will be nonzero when playerctl cannot find your player
    exit(0) if $?;

    if ($status eq "Playing") {
        $status = "";
    } elsif ($status eq "Paused") {
        $status = "";
    } else {
        exit(0);
    }

    my $artist = qx(playerctl $player_arg metadata artist);
    my $title = qx(playerctl $player_arg metadata title);

    print "$status  $artist - $title";
}

if ($player_arg eq '' or $player_arg =~ /mpd/) {
    mpd;
}
else {
    playerctl;
}
