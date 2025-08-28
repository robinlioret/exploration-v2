.:53 {
    forward . 8.8.8.8 8.8.4.4
    log
    errors
    health :8080
}

${DOMAIN}:${DNS_PORT} {
    log
    errors
    file /etc/coredns/db.${DOMAIN}
}