LABEL org.opencontainers.image.source="https://github.com/coders-lair/simple-git-server"
LABEL org.opencontainers.image.vendor="coders-lair.dev"

FROM alpine:3.20.1

WORKDIR /srv/git    

RUN set -ex; \
    apk add --no-cache \
        git=2.45.2-r0 \
        openssh=9.7_p1-r4 \
    ;

# setup sshd
RUN ssh-keygen -A
COPY files/etc/ssh/sshd_config /etc/ssh/sshd_config

# setup git user
RUN set -eux; \
    addgroup git; \
    adduser --gecos "Git user" --ingroup git --disabled-password --shell "$(which git-shell)" git && \
    echo git:12345 | chpasswd; \
    mkdir -p /home/git/.ssh/authorized_keys.d; \
    mkdir -p /home/git/git-shell-commands;

COPY files/home/git/git-shell-commands/* /home/git/git-shell-commands/
COPY files/entrypoint.sh /entrypoint.sh
COPY files/gather_keys.sh /gather_keys.sh

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D", "-E", "/var/log/sshd.log"]