# Please refer to commands_full.py for all the default commands and a
# complete documentation.  Do NOT add them all here, or you may end up
# with defunct commands when upgrading ranger.

import os
import os.path
import subprocess
from functools import partial

from ranger.api.commands import Command
from ranger.core.loader import CommandLoader


class compress(Command):
    """:compress
    Compress marked files to current directory.
    """
    def execute(self):
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()

        if not marked_files:
            return

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        original_path = cwd.path
        parts = self.line.split()
        au_flags = parts[1:]

        descr = 'compressing files in: ' + os.path.basename(parts[1])
        obj = CommandLoader(args=['apack'] + au_flags + \
                [os.path.relpath(f.path, cwd.path) for f in marked_files], descr=descr)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)

    def tab(self):
        """Complete with current folder name."""
        extension = ['.zip', '.tar.gz', '.rar', '.7z']
        return ['compress ' + os.path.basename(self.fm.thisdir.path) + ext for ext in extension]


class empty_trash(Command):
    """:empty_trash
    Empty the trash directory with 'gio trash --empty'.
    """
    def execute(self):
        self.fm.ui.console.ask(
            'Clear trash? (y/N)',
            partial(self._question_callback),
            ('n', 'N', 'y', 'Y'),
        )

    def _question_callback(self, answer):
        if answer == 'y' or answer == 'Y':
            self.fm.run('gio trash --empty')


class extract_here(Command):
    """:extract_here
    Extract copied files to current directory.
    Archive extraction is done by copying (yy) one or more archive
    files and then executing :extract_here on the desired directory.
    """
    def execute(self):
        copied_files = tuple(self.fm.copy_buffer)

        if not copied_files:
            return

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        one_file = copied_files[0]
        cwd = self.fm.thisdir
        original_path = cwd.path
        au_flags = ['-X', cwd.path]
        au_flags += self.line.split()[1:]
        au_flags += ['-e']

        self.fm.copy_buffer.clear()
        self.fm.cut_buffer = False
        if len(copied_files) == 1:
            descr = 'extracting: ' + os.path.basename(one_file.path)
        else:
            descr = 'extracting files from: ' + os.path.basename(one_file.dirname)
        obj = CommandLoader(args=['aunpack'] + au_flags \
                + [f.path for f in copied_files], descr=descr)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)


class media_layout(Command):
    """:media_layout
    Open the tabs commonly used for listening to podcasts and
    watching videos. In the future, this can be generalized as
    a layout function that gets a list of directories as a parameter.
    """
    directories = ['~/audio/podcasts',
                   '~/videos',
                   '~/downloads/youtube-dl',]
    def execute(self):
        # This is required to make sure that tab #1 is always open.
        # Otherwise, the layout might be out of order if tab #1 is
        # closed while other tabs are open.
        self.fm.tab_open(1)
        # Select next tab (for not to close the first tab).
        self.fm.tab_move(-1)
        # Leave only the first tab open.
        for i in range(1, len(self.fm.tabs)):
            self.fm.tab_close()

        if self.directories:
            # Open first directory in the existing tab.
            self.fm.cd(self.directories[0])
            # Open other directories in the future tabs.
            for d in self.directories[1:]:
                self.fm.tab_new(d)
            # Go back to the first tab.
            self.fm.tab_open(1)


class fzf_select(Command):
    """
    :fzf_select

    Find a file using fzf.
    With a prefix argument select only directories.

    See:
    https://github.com/junegunn/fzf
    https://github.com/ranger/ranger/wiki/Custom-Commands#fzf-integration
    """
    def execute(self):
        if self.quantifier:
            # match only directories
            command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
            -o -type d -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
        else:
            # match files and directories
            command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
            -o -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
        fzf = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)
