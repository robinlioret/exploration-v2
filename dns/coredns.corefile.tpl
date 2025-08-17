.:53 {
    forward . 8.8.8.8 8.8.4.4
    log
    errors
    health :8080
}

${DOMAIN}:53 {
    log
    errors
    file /etc/coredns/db.${DOMAIN}
}