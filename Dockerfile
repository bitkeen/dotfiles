FROM archlinux

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
