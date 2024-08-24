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
The `/entrypoint.sh` script concatenates all of these files upon container start and overwrites `/home/git/.ssh/authorized_keys` with the result.
This has been done in order to streamline kubernetes deployments, but has the downsides of not persisting keys added after container start (e.g. via `ssh-copy-id`) and not updating for keys mounted or unmounted after container start.

# Creation of new git repositories

Simply connect to the container via SSH and run `git-init NEWREPO`, which will create a new repository available under `ssh://user@container/repos/NEWREPO.git`.

# Inspirations

This image has been inspired by [jkarlosb/git-server-docker](https://github.com/jkarlosb/git-server-docker) and [rockstorm101/git-server-docker](https://github.com/rockstorm101/git-server-docker)