Indietro [ticket.md](ticket.md)

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
symfony console doctrine:migrations:execute --up 'DoctrineMigrations\Version20231008214316'

symfony console doctrine:migrations:execute --down 'DoctrineMigrations\Version20231008214316'
```