Indietro [ticket.md](README.md)

# Entità Progetto
- Event
- Location
- Sector
- Place
- Ticket
- Transaction
- User

### Migration Creazione Contenuti ( viene lanciata da entrypoint docker )
```bash

docker compose run  phpticket  bash

cd project

symfony console doctrine:migrations:execute --down 'DoctrineMigrations\Version20231008214316'

symfony console doctrine:migrations:execute --up 'DoctrineMigrations\Version20231008214316'

```

OPPURE 
Dalla root del progetto nel repository docker
```bash
    docker compose run  phpticket  downInitDataDb

    docker compose run  phpticket  upInitDataDb
```