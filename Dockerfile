FROM archlinux

RUN pacman --noconfirm -Syyu

# Install base-devel for `which`.
RUN pacman --noconfirm -S ansible base-devel git

RUN useradd -m user
RUN usermod -aG wheel user

RUN echo 'user ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers

ADD . /home/user/.dotfiles
RUN chown -R user:user /home/user

USER user

WORKDIR /home/user

# Don't run the whole playbook until it's ready to be run in docker.
RUN /home/user/.dotfiles/ansible/bootstrap pacman
