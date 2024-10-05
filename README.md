# simple-git-server

[![Docker Repository on Quay](https://quay.io/repository/coders-lair/simple-git-server/status?token=82d2c4bd-9c54-4b6e-9be4-f27435846edc "Docker Repository on Quay")](https://quay.io/repository/coders-lair/simple-git-server)

This image is intended to provide a minimal, easily deployable git server that serves repositories via SSH only.
Key features:

* Mount multiple authorized SSH keys in independent files (e.g. as kubernetes secrets)
* Allow creation of new repositories from SSH connections while the container is running
* Hardened `sshd` configuration:
    * Restrict login options to only `publickey`. No other SSH authorization methods are allowed.
    * `git` user has `git-shell` as default shell
* Easy to setup and run, especially in kubernetes contexts

All repositories are available via SSH, either as `ssh://git@${CONTAINER}/repos/${REPO}.git`, `ssh://git@${CONTAINER}/~/repos/${REPO}.git`, `git@${CONTAINER}:repos/${REPO}.git` or `git@${CONTAINER}:/repos/${REPO}.git`.
The first two options are recommended in case the SSH port gets remapped to a different one.

# Multiple SSH keys

Multiple authorized SSH keys can be mounted as individual files under `/home/git/.ssh/authorized_keys.d/`.
`sshd` is configured to concatenate all of these files upon login request and using the result in lieu of a common `authorized_keys` file.
This has been done in order to streamline kubernetes deployments.

However, it comes with the following caveats:
* `ssh-copy-id` will not work
* `/home/git/.ssh/authorized_keys` will be ignored. (Workaround: move/mount it under `/home/git/.ssh/authorized_keys.d`)
* Only files containing SSH public keys may be present in `/home/git/.ssh/authorized_keys.d/`

# Creation of new git repositories

Simply connect to the container via SSH and run `git-init NEWREPO`, which will create a new repository available under `ssh://user@container/repos/NEWREPO.git`.

# Inspirations

This image has been inspired by [jkarlosb/git-server-docker](https://github.com/jkarlosb/git-server-docker) and [rockstorm101/git-server-docker](https://github.com/rockstorm101/git-server-docker)