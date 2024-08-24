#!/bin/sh

set -eu

_term_trigger() {
  kill -TERM "$child" 2>/dev/null
}

trap _term_trigger SIGTERM

chown -R git:git /home/git /srv/git
ln -sf /srv/git /home/git/repos
ln -sf /srv/git /repos

for key_file in /home/git/.ssh/authorized_keys.d/*; do
  cat $key_file;
  echo
done >/home/git/.ssh/authorized_keys

"$@" &

child=$!
wait "$child"
