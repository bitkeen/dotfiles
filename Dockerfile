FROM archlinux

# WORKAROUND for glibc 2.33 and old Docker
# https://github.com/qutebrowser/qutebrowser/commit/478e4de7bd1f26bebdcdc166d5369b2b5142c3e2
RUN patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst && \
    curl --silent -LO "https://repo.archlinuxcn.org/x86_64/$patched_glibc" && \
    bsdtar -C / -xf "$patched_glibc"

RUN pacman --noconfirm -Syyu

# Install base-devel for `sudo`.
RUN pacman --noconfirm -S base-devel git

RUN useradd -m user
RUN usermod -aG wheel user

RUN echo 'user ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers

ADD . /home/user/.dotfiles
RUN chown -R user:user /home/user

USER user

WORKDIR /home/user

# For now, only systemd role is omitted.
# Clear package cache in the end to reduce image size
# (same layer where installation happens).
RUN /home/user/.dotfiles/ansible/bootstrap \
    pacman \
    python \
    npm \
    ruby \
    aur \
    pkgbuilds \
    misc \
    networkmanager \
    stow \
    firefox \
    virtualbox \
    after && \
    sudo rm /var/cache/pacman/pkg/* && \
    sudo rm -rf /home/user/.cache/ansible/aur && \
    sudo rm -rf /tmp/ansible*python && \
    go clean -cache && \
    rm -r /home/user/.cache/yarn && \
    rm -r /home/user/.cargo/registry
