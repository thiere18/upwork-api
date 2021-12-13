# step to configure nginx and let's Encrypt ssl configuration
### activate firewall
sudo ufw enable
sudo ufw status
sudo ufw allow ssh (Port 22)
sudo ufw allow http (Port 80)
sudo ufw allow https (Port 443)
sudo ufw allow 5432 (postgres communication)

### download nginx
sudo apt install nginx

sudo vi /etc/nginx/sites-available/default

### Add the following to the location part of the server block

   server_name yourdomain.com www.yourdomain.com;

    location / {
        proxy_pass http://localhost:5000; #whatever port your app runs on
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
# Check NGINX config
sudo nginx -t

# Restart NGINX
sudo service nginx restart

### add SSL with Let's Encrypt

sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install python-certbot-nginx
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# Only valid for 90 days, test the renewal process with
certbot renew --dry-run