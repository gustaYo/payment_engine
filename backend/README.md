# payment_engine
backend

## Install Dependencies

`npm i -dd`

## Run project in production

1. `npm run prod`
2. `npm start`

## Run project in development

1. `npm run dev`
2. Open a new terminal window and run `npm start` to execute the app


## Configuring work environment

# Install and upgrade nodejs

        apt-get install nodejs-legacy npm

        https://github.com/creationix/nvm#install-script

        export http_proxy="http://user:password@proxy:port"
        export https_proxy="http://user:password@proxy:port"

        curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash

        gedit ~/.profile
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

        nvm run node --version

        gedit ~/.npmrc

        proxy=http://user:password@proxy:port
        registry=http://registry.npmjs.org/

        #registry = http://nexus.prod.uci.cu/repository/npm-all
        #strict-ssl = false


# ElasticSearch integration

        apt-get install elasticsearch
        gedit /etc/default/elasticsearch
        Uncomment START_DAEMON=true
        systemctl restart

# Redis integration

        https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-redis-on-ubuntu-16-04

# Mongodb integration

        apt-get install mongodb

# Rabbitmq integration

        https://www.rabbitmq.com/install-debian.html

        sudo su
        echo "deb http://www.rabbitmq.com/debian/ testing main" >> /etc/apt/sources.list
        wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
        sudo apt-key add rabbitmq-signing-key-public.asc

        sudo apt-get update
        sudo apt-get install rabbitmq-server

        or install .deb

        https://www.rabbitmq.com/releases/rabbitmq-server/v3.6.9/rabbitmq-server_3.6.9-1_all.deb

        sudo dpkg -i rabbitmq-server_3.6.9-1_all.deb

        sudo rabbitmq-plugins enable rabbitmq_management
        sudo service rabbitmq-server start
        rabbitmqctl status

        http://localhost:15672/

        guest
        guest



