commands after to run after cloning the repo
cp .env.example to .env
# dev mode
docker compose -f docker-compose-dev.yml up

# production mode 
Setup the environment variable on 
docker-compose-prod.yml 
docker compose -f docker-compose-prod.yml 
