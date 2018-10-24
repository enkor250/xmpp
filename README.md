version: "3"
services:

  ejabberd-data:
    build:
      context: ./ej-data/
      dockerfile: dockerfile
  ejabberd:
    image: rroemhild/ejabberd
    hostname: labor.bugabinga.net
    volumes:
      - ejabberd-data
    volumes:
      - ./ssl:/opt/ejabberd/ssl:ro
    ports:
      - 5222:5222
      - 5269:5269
      - 5280:5280
      - 4560:4560
      - 5443:5443
    environment:
      - ERLANG_NODE=ejabberd
      - XMPP_DOMAIN=labor.bugabinga.net
      - EJABBERD_ADMINS=admin@it-top.pp.ua
      - EJABBERD_USERS=admin@it-top.pp.ua user@it-top.pp.ua
      - EJABBERD_SSLCERT_HOST=/opt/ejabberd/ssl/host.pem
      - EJABBERD_SSLCERT_LABOR_BUGABINGA_NET=/opt/ejabberd/ssl/labor.bugabinga.net.pem
      - TZ=Europe/Berlin
