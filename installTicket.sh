#!/bin/bash
cd www/html
git clone git@github.com:appacifici/ticket-backend-symfony.git
ln -s ticket-backend-symfony project
mkdir  ticket-backend-symfony/var
chmod -R 777 ticket-backend-symfony/var
cd ../../
docker compose pull
docker compose build
docker compose up
