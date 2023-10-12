Indietro [ticket.md](ticket.md)

# Installazione

### Creare directory che contiene il progetto

```bash
    mkdir /home/{user}/ticket
```

### Spostarsi nella directory
```bash
    cd /home/{user}/ticket
```

### Clonare i repository necessari

```bash
git clone git@github.com:appacifici/docker-lamp-nginx-node.git
cd docker-lamp-nginx-node

#Il repository
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
