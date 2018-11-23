apt install git mc  -y

MYIP=$(curl -4 https://icanhazip.com/);

#docker
curl -fsSL https://get.docker.com/ | sh
sudo systemctl start docker
sudo systemctl enable docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

apt install git mc  -y

#certbot
sudo apt-get update
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot -y

cat /etc/letsencrypt/live/$DOMAIN/{privkey,fullchain}.pem > /etc/ejabberd/$DOMAIN.pem

cd /opt
git clone https://github.com/it-toppp/xmpp.git
chown 999 -R /opt/xmpp/ejabberd

echo "open in web browser    :  https://$MYIP:5280/admin"
