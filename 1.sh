echo "Enter domain: "
read DOMAIN

apt install git mc -y

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
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot -y

certbot register --email admin@$DOMAIN --agree-tos
certbot certonly --standalone -m admin@$DOMAIN --agree-tos -d $DOMAIN --rsa-key-size 4096 --server https://acme-v02.api.letsencrypt.org/directory

cd /opt
git clone https://github.com/it-toppp/xmpp.git

chown 999 -R /opt/xmpp/ejabberd

sudo docker rm -f ejabberd &> /dev/null
sudo docker run -u root \
    --name ejabberd \
    --privileged \
    --detach \
    --restart=always \
#    --net=host \
    -p 5222:5222 \
    -p 5269:5269 \
    -p 5280:5280 \
    -p 5277:5277 \
    -p 5443:5443 \
    -e "XMPP_DOMAIN=$DOMAIN" \
    -e "EJABBERD_ADMINS=admin@$DOMAIN" \
    -e "EJABBERD_USERS=admin@e$DOMAIN:123456" \
    -e "EJABBERD_REGISTER_ADMIN_ONLY=true" \
  #  -e "TZ=Europe/Berlin" \
    -v /var/lib/openvpn/mongodb:/var/lib/mongodb \
    -v /opt/xmpp/ejabberd/database/:/opt/ejabberd/database \
    -v /opt/xmpp/ejabberd/conf/:/opt/ejabberd/conf \
    -v /opt/xmpp/ejabberd/ssl/:/opt/ejabberd/ssl \
    -v /opt/xmpp/ejabberd/upload/:/opt/ejabberd/upload \
       rroemhild/ejabberd
       
     cat /etc/letsencrypt/live/$DOMAIN/{privkey,fullchain}.pem > /opt/xmpp/ejabberd/ssl/$DOMAIN.pem
     docker restart ejabberd
     
echo "open in web browser    :  https://$DOMAIN:5280/admin"
