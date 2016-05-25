# Build images

#####
# Collect files from the host. Move them into build directories.
# Notice that I am using Let's Encrypt. You'll need to change the names
# of the PEM files to match
sudo cp /etc/letsencrypt/live/affy.com/fullchain.pem .
sudo cp /etc/letsencrypt/live/affy.com/privkey.pem .
sudo cp /etc/ssl/certs/dhparam.pem .
sudo chown $USER:$USER fullchain.pem privkey.pem dhparam.pem
chmod 444 fullchain.pem privkey.pem dhparam.pem .htpasswd

pushd docker-registry-proxy
docker build -t d13/docker-registry-proxy .
popd
