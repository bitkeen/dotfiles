FROM archlinux

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

# For now, only systemd role is omitted
RUN /home/user/.dotfiles/ansible/bootstrap \
    pacman \
    python \
    npm \
    ruby \
    aur \
    pkgbuilds \
    misc \
    stow \
    firefox \
    transmission \
    virtualbox

# Clear package cache.
RUN sudo rm /var/cache/pacman/pkg/*
RUN sudo rm -rf /home/user/.cache/ansible/aur
RUN sudo rm -rf /tmp/ansible*python
