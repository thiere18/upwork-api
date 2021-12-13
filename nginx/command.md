# Deployment process
# 1. postgres setup and configuration
### install pip 
```
sudo apt install python3-pip
```
### download virtualenv
```
sudo pip3 install virtualenv
```
### install postgres and postgresql-conrtib
```
sudo apt install postgresql postgresql-contrib -y
```
### connect with postgres user
```
su -postgres
```
### connect the psql CLI and edit a password
```
psql -U postgres

\password postgres

```
### edit postgres conf and enable remote connection to the database
```
cd /etc/postgresql/12/main
sudo vi postgresql.conf
```
### add this line
```
listen_adresses="*"
```
### pg_hba configuration
```
sudo vi pg_hba.conf
```
### database configuration like this
<img width="620" alt="Capture d’écran 2021-12-13 à 07 31 52" src="https://user-images.githubusercontent.com/53997377/145770511-79b74fe8-b32c-4323-ba4c-95d0713dc45a.png">
### restart postgres service
```
sudo systemctl restart postgresql
```
### try to connect to psql and see if it works
```
psql -U postgres 
```
### optional but  recomended ( Add a new user )
```adduser new_user_username
```
### give it sudo privilegies
``` usemod -aG sudo new_user```

### now connect with ssh to the new user session
``` ssh new_user@IP_ADRESS```
### cd to your home directory and create .env file for your environment variable
``` cd ~
mkdir app 
cd app 
virtualenv venv
mkdir src 
cd src/
```
### clone the projects repos
```
git clone https://github.com/thiere18/upwork-api.git .
```
### activate the virtual environment and install dependancies
```
cd ~/app
source venv/bin/activate
cd src/
pip install -r requirements.txt

```
```
sudo vi .env
```
### add your environment variable like
```
DATABASE_HOSTNAME=localhost
DATABASE_PORT=5432
DATABASE_NAME=upwork
DATABASE_PASSWORD=postgres
DATABASE_USERNAME=postgres
SECRET_KEY=bd2137308229dffafc57887fe6df1a3f06b5d1d87aa35cec7422b8fb4c54cc64
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=60
API_PREFIX=/api/v1
```
### export and persist your environment variable
```
cd ~
vi .proflie
```
#add this line to the bottom of the file
```
set -o allexport; source path-to-home-directory/.env; set +o allexport
```
### gunicorn setup
## installation
``` pip install gunicorn ```
## create the api service 
```
cd /etc/systemd/system
sudo vi api.service
```
## add this script by modifying the username(upwork)
```
[Unit]
Description=Gunicor automation
After=network.target

[Service]
User=upwork
Group=upwork
WorkingDirectory=/home/upwork/app/src
Environment="PATH=/home/upwork/app/venv/bin"
EnvironmentFile=/home/upwork/.env
ExecStart=/home/upwork/app/venv/bin/gunicorn -w 4 -k uvicorn.workers.UvicornWorker app.main:app --bind 0.0.0.0:8000

[Install]
WantedBy=multi-user.target
```
## run the api service
``` systemctl start api ```
## enable the api service so it's run everytime the machine starts
``` sudo systemctl enable api```
``` systemctl restart api```
# 2. step to configure nginx and let's Encrypt ssl configuration
### activate firewall
```
   sudo ufw enable
   sudo ufw status
   sudo ufw allow ssh (Port 22)
   sudo ufw allow http (Port 80)
   sudo ufw allow https (Port 443)
   sudo ufw allow 5432 (postgres communication)
```
### download nginx
```
   sudo apt install nginx
   sudo vi /etc/nginx/sites-available/default
```
### Add the following to the location part of the server block
```
   server_name yourdomain.com www.yourdomain.com;

    location / {
        proxy_pass http://localhost:8000; #whatever port your app runs on
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
  ```
### Check NGINX config
```
   sudo nginx -t
```
### Restart NGINX
```
   sudo service nginx restart
```
### add SSL with Let's Encrypt
```
   sudo add-apt-repository ppa:certbot/certbot
   sudo apt-get update
   sudo apt-get install python-certbot-nginx
   sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
```
### Only valid for 90 days, test the renewal process with
```
   certbot renew --dry-run
   ```
## run migrations 
```cd ~/app
source venv/bin/activate
cd src/
alembic upgrade head 
```
