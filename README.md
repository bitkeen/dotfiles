# dotfiles

[![Build Status](https://travis-ci.com/bitkeen/dotfiles.svg?branch=arch)](https://travis-ci.com/bitkeen/dotfiles)

The local machine setup and dotfiles are managed with Ansible.
Symlinks to the directories are created with GNU Stow from an Ansible role.

To learn which components are going to be installed and configured, see the playbook (`ansible/playbook.yml`).

To set up the system from a blank slate with these configs, first install the initial dependencies, then clone the repository:
```sh
pacman -S base-devel git
git clone https://github.com/bitkeen/dotfiles ~/.dotfiles
```

After that, run the bootstrapping script:
```sh
~/.dotfiles/ansible/bootstrap
```

You can also run specific roles by passing tags to `bootstrap`:
```sh
~/.dotfiles/ansible/bootstrap python firefox
```

##### Branches
- `arch` - currently the main branch, specific to Arch Linux
- `master` - a point at which all the other branches start differing, it is not updated now as I mostly use Arch Linux
- `mac` - changes specific to macOS
- `termux` - changes specific to Termux on Android
