## Dotfiles

My local machine setup and dotfiles are managed with Ansible.
Symlinks to the directories are created by running GNU Stow in it.

To learn which components are going to be installed and configured, see the playbook (`ansible/arch.yml`).

To set up the system from a blank slate with these configs, first install git, then clone the repository:
```
if ! [ -x "$(command -v git)" ]; then
    sudo pacman -S git
fi
git clone https://github.com/bitkeen/dotfiles ~/.dotfiles
```

After that, run the bootstrapping script:
```
~/.dotfiles/ansible/bootstrap
```
