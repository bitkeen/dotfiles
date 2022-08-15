FROM archlinux:latest

# Install base-devel for `sudo`.
RUN pacman --noconfirm -Syyu base-devel

# Set up the user.
RUN useradd -m user \
    && usermod -aG wheel user \
    && echo 'user ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers

COPY --chown=user . /home/user/.dotfiles

USER user
WORKDIR /home/user
# Clear package cache at the end to reduce image size
# (same layer where installation happens).
# rm -f flag is important to ignore nonexistent directories.
# hadolint ignore=DL3004
RUN .dotfiles/ansible/bootstrap \
    && sudo rm /var/cache/pacman/pkg/* \
    && sudo rm -rf .cache/ansible/aur \
    && sudo rm -rf /tmp/ansible*python \
    && go clean -cache \
    && rm -rf .cargo/registry \
    && rm -rf .stack

# Add docker indicator to prompt.
RUN echo -e '\nPROMPT="%F{blue}docker:%f ${PROMPT}"' >> .zshrc

CMD ["/usr/bin/zsh", "-l"]
