Indietro [ticket.md](ticket.md)

# Installazione

### Clonare i repository necessari

```bash

#Evitare questo passaggio se gia clonato questo repository dell'infrastruttura docker necessaria
git clone git@github.com:appacifici/docker-lamp-nginx-node.git
cd docker-lamp-nginx-node

#Clonare il repository del progetto ticket
cd www/html
git clone git@github.com:appacifici/ticket-backend-symfony.git
ln -s ticket-backend-symfony project
```

### Creazione e permessi scrittura cartelle var Symfony
```bash
mkdir  ticket-backend-symfony/var
chmod -R 777 ticket-backend-symfony/var
```

### Avvio container docker
```bash
cd ../../
docker compose pull
docker compose build
docker compose up  #Option (-d) se si vuole demonizzare
```

- Sara il file entrypoint.sh del container php ad occuparsi di:
    - Installazione dipendenze Symfony
    - Creazione del database vuoto 
    - Lanciare le migration per
        - Create le tabelle
        - Popolarle di dati iniziali per testare l'app
