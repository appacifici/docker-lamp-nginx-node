Indietro [ticket.md](ticket.md)
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
```php
/* Ho messo i limiti come costanti in quanto pensando ad uno sviluppo successivo del sistema la maniera più corretta sarebbe creare un altra entita
che gestisca questo tipo di filtro, pensando magari che in base all'utente se base o premium possano avere diverse opzioni di scelta dove magari
l'utente premium puo acquistare fino a 5 biglietti, oppure quello base non può acquistare più di un evento, quindi per mancanza di tempo faccio
una cosa base lavorando con semplici costanti, che però inserisco nel servizio che si occupera dei controlli necessari per procedere all'acquisto
*/
const MAX_TICKET_TRANSACTION = 4;
const MAX_EVENT_TRANSACTION  = 2;
```

### purchaseTicket
oE' il servizio finale che viene invocato dall'endPoint per l'acquisti dei biglietti. In un progetto completo il frontend dovrebbe invocare prima altri endPoint per richiedere i posti e i biglietti disponibili, farli selezionare all'utente, e poi invocare un il servizio che li metta in lock fiche l'utente finisce la selezione di altri biglietti, oppure fino alla scadenza del tempo massimo di lock. Un volta arrivati alla fine questo servizio dovre essere apliato implementando ai controlli già esistenti di disponibilità anche quelli dei biglietti in lock per il tempo prestabilito.

Questo servizio cosi come pensato potra assere invocato sia per acquistare che per fare il lock dei ticket.

Con un command in cron ogni minuti possiamo recuperare i ticket in lock e se superato il temop massimo renderli nuovamente disponibili.

Andrebbe creata entita LockUserTicket, in modo che il frontend anche se l'utente ricarica la pagina ha la visione di quanto tempo rimane alla scadenza e di quali biglietti