FROM archlinux

# WORKAROUND for glibc 2.33 and old Docker
# https://github.com/qutebrowser/qutebrowser/commit/478e4de7bd1f26bebdcdc166d5369b2b5142c3e2
RUN patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst && \
    curl --silent -LO "https://repo.archlinuxcn.org/x86_64/$patched_glibc" && \
    bsdtar -C / -xf "$patched_glibc"

# Install base-devel for `sudo`.
RUN pacman --noconfirm -Syyu base-devel git

# Set up the user.
RUN useradd -m user \
    && usermod -aG wheel user \
    && echo 'user ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers

COPY . /home/user/.dotfiles
RUN chown -R user:user /home/user

USER user
WORKDIR /home/user
# Clear package cache at the end to reduce image size
# (same layer where installation happens).
RUN .dotfiles/ansible/bootstrap \
    && sudo rm /var/cache/pacman/pkg/* \
    && sudo rm -rf .cache/ansible/aur \
    && sudo rm -rf /tmp/ansible*python \
    && go clean -cache \
    && rm -r .cargo/registry \
    && rm -r .stack

# Add docker indicator to prompt.
RUN echo -e '\nPROMPT="%F{blue}docker:%f ${PROMPT}"' >> .zshrc

CMD ["/usr/bin/zsh", "-l"]
