Indietro [ticket.md](README.md)
# Informazioni utili

##
Per il progetto ho utilizzato Symfony 6. All'interno del progetto ci sono dei file scritti da me circa 10 anni fa perche integrano una funzionalità per costruire in maniera dinamica il frontend tramite l'utilizzo di un intefaccia che genera la struttura della pagina in formato .xml con l'inclusione in drag e drop dei template generati, che ho utilizzato per mostrare lato frontend un piccolo tools che uso per segnalare gli errori gravi che generano le chiamate del sistema o per segnalare i processi molto lenti ed identificarne il collo di bottiglia, e ho messo questo esempio che è inserito all'interno del REST Manager. ( Poi vi spiego tutto nel dettagio se volete ). 

 E altri file che sono classi utilità, come la classe per la gestione della cache con Redis. Ve li elenco cosi che possiate fare un distinguo tra ciò che ho scritto per la vostra richiesta e quello che c'era di pre esistente:

### Nuovi file per sistema Ticket
- config/*
- migrations/*
- src/Domain/* ( Qui ci sono tutti i file per il Domain Ticket richiesto )
- src/Entity
- src/Repository

### Vecchi file
- Tutti i file nelle cartelle src/Service
    - Tranne i file per il sistema REST Manager CRUD da me scritto un anno fa che utilizzo per fare operazioni CRUD semplici sulle entità
        - src/Service/ManagerService/*
        - src/Service/RestService/* 

### TicketPurchaseService
Per i principi SOLID questo servizio dovrebbe occuparti solo dell acquisto, la parte invece dei vincoli di acquisto andrebbe gestita in un servizio separato. Ma sia per mancanza di tempo essendo un test per un colloquio, sia perchè conosci i principi, ma cerco sempre di applicarli in maniera flessibile, per non cadere nell'errore fare Over-engineering, nella fase iniziale, ho messo queste due logiche nello stesso servizio, perchè strettamente correlate. ( Se volete possiamo discute del motivo della scelta ). 

```php
/* Ho messo i limiti come costanti in quanto pensando ad uno sviluppo successivo del sistema la maniera più corretta sarebbe creare un altra entita
che gestisca questo tipo di filtro, pensando magari che in base all'utente se base o premium possano avere diverse opzioni di scelta dove magari
l'utente premium puo acquistare fino a 5 biglietti, oppure quello base non può acquistare più di un evento, quindi per mancanza di tempo faccio
una cosa base lavorando con semplici costanti, che però inserisco nel servizio che si occupera dei controlli necessari per procedere all'acquisto
*/
const MAX_TICKET_TRANSACTION = 4;
const MAX_EVENT_TRANSACTION  = 2;
```

## Logging
Andrebbero implementati i log di debug con il LoggerInterface di Symfony

## DTO
Utilizzati in maniera non totalmente tradizionale, ma secondo me molto più funzionale e concreta (se volete possiamo discuterne)

## Exception
A parte la classica gestione delle eccezioni di errore.
Ho unato le exception custom, per gestire le "eccezioni" logiche del processo di acquisti dei ticket, lo scopo era quello di rendere più leggibile il progesso e meno sovrastutturato possibile, per risolve problematiche di debug e gestione del codice. In particolar modo per evitare di avere try catch annidati che tornano poi un risultato al chiamante e dover portare tutti questi risultati fino al controller. Questo è stato un esperimento e mi piacerebbe parlarne con voi.

## Interfacce
Se il progetto dovesse avere più tipologie di acquisto es utenti gold, vip, ecc ecc.. o diversi modalita di vincoli, o di pagamento, non bisognera modificare le classe concrete reali, ma implementarte di nuove sulla base delle interfaccie definite. 

## Test
Andrebbero sviluppati test unitari che validino i vincoli di dominio richiesti
Test funzionali:
    - Al momento ho inserito solo un test funzionale

## PurchaseTicket
E' il servizio finale che viene invocato dall'endPoint per l'acquisti dei biglietti. In un progetto completo il frontend dovrebbe invocare prima altri endPoint, per richiedere i posti e i biglietti disponibili, farli selezionare all'utente, e poi invocare il servizio che li metta in lock fiche l'utente finisce la selezione di altri biglietti. 

Oppure riservarli fino alla scadenza del tempo massimo di lock. 

Un volta arrivati alla fine, questo servizio dovre essere ampliato implementando, ai controlli già esistenti di disponibilità, anche quelli dei biglietti in lock per il tempo prestabilito.

Questo servizio cosi come pensato potra essere invocato sia per acquistare, sia per fare il lock dei ticket, che per fare controllare le disponibilità, aggiungendo alla struttura di chiamata un parametro "action" per determinare quali delle 3 casistiche sorpa descritte è richiesta.

Con un command in cron ogni minuto possiamo recuperare i ticket in lock e se superato il tempo massimo renderli nuovamente disponibili.

Andrebbe creata entita LockUserTicket, in modo che il frontend anche se l'utente ricarica la pagina ha la visione di quanto tempo rimane alla scadenza e di quali biglietti