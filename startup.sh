#!/bin/sh

# Special test harnass startup.

if [ -f /run/secrets/id_rsa_pub ]
then
    # A known authenticated user is being injected from a container secret
    mkdir -p ~actian/.ssh
    cat /run/secrets/id_rsa_pub >>~actian/.ssh/authorized_keys
    chown -R actian ~actian/.ssh
    chmod -R u=rw,go= ~actian/.ssh/authorized_keys
fi

/sbin/sshd
/usr/local/bin/dockerctl
