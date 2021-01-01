FROM registry.opensource.zalan.do/acid/pgbouncer:master-9

COPY resources/pgbouncer.ini /etc/pgbouncer/pgbouncer.ini.tmpl
COPY resources/entrypoint.sh /entrypoint.sh
