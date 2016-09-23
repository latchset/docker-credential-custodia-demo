#!/bin/sh

if [ -x /usr/libexec/sssd/sssd_secrets ]; then
    echo "Running sssd_secret responder in backgroud"
    /usr/libexec/sssd/sssd_secrets --uid 0 --gid 0 --debug-to-files &
fi

echo "Running docker daemon in background"
docker daemon &

echo "Waiting..."
sleep 4

echo "Starting Custodia in foreground"
exec /usr/bin/custodia /etc/custodia/custodia.conf
