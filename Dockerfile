FROM registry.opensource.zalan.do/acid/pgbouncer:master-9

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
