#!/bin/sh

set -ex

if [ "$PGUSER" = "postgres" ]; then
    echo "WARNING: pgbouncer will connect with superuser privileges!"
    echo "You need to fix this as soon as possible."
fi

if [ -z "${CONNECTION_POOLER_CLIENT_TLS_CRT}" ]; then
    openssl req -nodes -new -x509 -subj /CN=spilo.dummy.org \
        -keyout /etc/ssl/certs/pgbouncer.key \
        -out /etc/ssl/certs/pgbouncer.crt
else
    ln ${CONNECTION_POOLER_CLIENT_TLS_CRT} /etc/ssl/certs/pgbouncer.crt
    ln ${CONNECTION_POOLER_CLIENT_TLS_KEY} /etc/ssl/certs/pgbouncer.key
fi

export CONNECTION_POOLER_DEFAULT_POOL_SIZE=${CONNECTION_POOLER_DEFAULT_POOL_SIZE:-10}
export CONNECTION_POOLER_MIN_POOL_SIZE=${CONNECTION_POOLER_MIN_POOL_SIZE:-1}
export CONNECTION_POOLER_RESERVE_POOL_SIZE=${CONNECTION_POOLER_RESERVE_POOL_SIZE:-0}
export CONNECTION_POOLER_MAX_CLIENT_CONN=${CONNECTION_POOLER_MAX_CLIENT_CONN:-10000}
export CONNECTION_POOLER_MAX_DB_CONN=${CONNECTION_POOLER_MAX_DB_CONN:-0}
export CONNECTION_POOLER_MAX_USER_CONN=${CONNECTION_POOLER_MAX_USER_CONN:-20}
export CONNECTION_POOLER_QUERY_WAIT_TIMEOUT=${CONNECTION_POOLER_QUERY_WAIT_TIMEOUT:-30}

envsubst < /etc/pgbouncer/pgbouncer.ini.tmpl > /etc/pgbouncer/pgbouncer.ini
envsubst < /etc/pgbouncer/auth_file.txt.tmpl > /etc/pgbouncer/auth_file.txt

exec /bin/pgbouncer /etc/pgbouncer/pgbouncer.ini
