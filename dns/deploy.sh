title "DEPLOY DNS"
if [ "$(docker inspect -f '{{.State.Running}}' "dns" 2>/dev/null || true)" != 'true' ]; then
  true
else
  action_done "DNS is already running"
  return 0
fi

action "Create DNS dir"
test -d "$DIR/dns" || mkdir "$DIR/dns"
action_done

action "Create coredns.corefile"
render_file "dns/coredns.corefile.tpl" > "$DIR/dns/coredns.corefile"
action_done

action "Create coredns.zonefile"
render_file "dns/coredns.zonefile.tpl" > "$DIR/dns/coredns.zonefile"
action_done

action "Pull CoreDNS image"
docker pull coredns/coredns
action_done

action "Start Coredns on port $DNS_PORT. Should resolve to ${IP}"
docker run -d --name dns --restart=unless-stopped\
  -p $DNS_PORT:$DNS_PORT/tcp -p $DNS_PORT:$DNS_PORT/udp \
  -v "$DIR/dns/coredns.corefile":/etc/coredns/Corefile \
  -v "$DIR/dns/coredns.zonefile":/etc/coredns/db.sandbox.local \
  coredns/coredns:latest -conf /etc/coredns/Corefile -dns.port $DNS_PORT
sleep 1
action_done

action "Test DNS resolution from localhost"
if dig dummy.${DOMAIN} | grep dummy.${DOMAIN} | grep -q ${IP}; then
  action_done "DNS resolution is working from localhost"
else
  action_failed "DNS resolution is failing from localhost"
  dig dummy.${DOMAIN}
  return 1
fi

action "Test DNS resolution from inside the cluster"
if kubectl run --rm -ti --image massenz/dnsutils:2.4.0 testdns --command --restart Never -- dig dummy.${DOMAIN} 2> /dev/null | grep dummy.${DOMAIN} | grep -q ${IP}; then
  action_done "DNS resolution is working from inside the cluster"
else
  action_failed "DNS resolution is failing from inside the cluster"
  kubectl run --rm -ti --image massenz/dnsutils:2.4.0 testdns --command --restart Never -- dig dummy.${DOMAIN}
  return 1
fi