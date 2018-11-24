echo "Enter domain: "
read DOMAIN

echo "Enter admin password: "
read ADMINPASS

apt install curl git mc -y

MYIP=$(curl -4 https://icanhazip.com/);

#docker
curl -fsSL https://get.docker.com/ | sh
systemctl start docker
systemctl enable docker
curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

#certbot
sudo apt-get update
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:certbot/certbot -y
sudo apt-get update
sudo apt-get install certbot -y

certbot register --email admin@$DOMAIN --agree-tos
certbot certonly --standalone -n -m admin@$DOMAIN --agree-tos -d $DOMAIN --rsa-key-size 4096 --server https://acme-v02.api.letsencrypt.org/directory

cd /opt
git clone https://github.com/it-toppp/xmpp.git

chown 999 -R /opt/xmpp/ejabberd

sudo docker rm -f ejabberd &> /dev/null
sudo docker run -u root \
    --name ejabberd \
    --privileged \
    --detach \
    --restart=always \
    -p 5221:5221 \
    -p 5269:5269 \
    -p 5280:5280 \
    -p 5277:5277 \
    -p 5444:5444 \
    -e "XMPP_DOMAIN=$DOMAIN" \
    -e "EJABBERD_ADMINS=admin@$DOMAIN" \
    -e "EJABBERD_USERS=admin@$DOMAIN:ADMINPASS" \
    -e "EJABBERD_REGISTER_ADMIN_ONLY=true" \
    -v /opt/xmpp/ejabberd/database/:/opt/ejabberd/database \
    -v /opt/xmpp/ejabberd/conf/:/opt/ejabberd/conf \
    -v /opt/xmpp/ejabberd/ssl/:/opt/ejabberd/ssl \
    -v /opt/xmpp/ejabberd/upload/:/opt/ejabberd/upload \
       rroemhild/ejabberd
       
 cat /etc/letsencrypt/live/$DOMAIN/{privkey,fullchain}.pem > /opt/xmpp/ejabberd/ssl/$DOMAIN.pem
 docker restart ejabberd
     
echo "open in web browser    :  https://$DOMAIN:5280/admin"
echo "user : admin    ;  password    :  $ADMINPAS"

