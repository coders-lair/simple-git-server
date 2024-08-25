#!/bin/sh

set -eu

_term_trigger() {
  kill -TERM "$child" 2>/dev/null
}

trap _term_trigger SIGTERM

ln -sf /srv/git /home/git/repos
ln -sf /srv/git /repos

find /home/git/.ssh/authorized_keys.d/ -type f -exec cat \{\} \; -exec echo \; >/home/git/.ssh/authorized_keys

"$@" &

child=$!
wait "$child"
