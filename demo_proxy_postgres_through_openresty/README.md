# Proxy Set Up For Development
1. Edit your postgres configs
- in `postgresql.conf` you need to `listen_addresses='*'` or some specific IP
- in `pg_hba.conf` you need to listen on `0.0.0.0/0` or some specific IP and use md5 method e.g.

```
# IPv4 local connections:
# host    all             all             127.0.0.1/32            md5
host    all             all             0.0.0.0/0            md5
```
2. Configure the openresty reverse proxy. The IP can be obtained by running `lxc ls`.
This needs to be in a stream block, not http. e.g.

```
server {
        listen 5000;
        proxy_connect_timeout 60s;
        proxy_socket_keepalive on;
        proxy_pass 10.101.102.123:5432;
}
```
