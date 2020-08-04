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

# Don't run the whole playbook until it's ready to be run in docker.
# Install various packages.
RUN /home/user/.dotfiles/ansible/bootstrap pacman
RUN /home/user/.dotfiles/ansible/bootstrap python
RUN /home/user/.dotfiles/ansible/bootstrap npm
RUN /home/user/.dotfiles/ansible/bootstrap ruby
RUN /home/user/.dotfiles/ansible/bootstrap aur
RUN /home/user/.dotfiles/ansible/bootstrap pkgbuilds

# Other roles.
RUN /home/user/.dotfiles/ansible/bootstrap misc
RUN /home/user/.dotfiles/ansible/bootstrap virtualbox

# Clear package cache.
RUN sudo rm /var/cache/pacman/pkg/*
RUN sudo rm -rf /home/user/.cache/ansible_aur
RUN sudo rm -rf /tmp/ansible*python
