Indietro [ticket.md](ticket.md)
# Informazioni utili

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