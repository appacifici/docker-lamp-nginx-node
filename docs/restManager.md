Indietro [ticket.md](README.md)

# Rest Manager Utilizzo
Questo servizio creato custom serve a genstire le operazione CRUD semplici sulle entità


## Utilizzo
- Creare entità
- Copiare {nome}Service.php in App\Service\ManagerService\
    - Modifica nome da classe copiata con quello da gestire
    - Modifica array $checkFiels, inserire i campi obbligatori della richiesta http
    - Modifica campi insert e update con quelli dell'entità

### Registrare classe come servizio su service.yaml
```yaml
    app.eventService:
    class:     App\Service\ManagerService\{nome}Service      
    public: true
```
### creare rotta in Controller\WebServicesController.php
```php
    // {nome} per convenzione nome == corrispondende a quello dell'entita da gestire
    #[Route('/ws/{nome}/{id}', methods: ['GET', 'POST', 'PUT', 'DELETE'], name: 'ws{Nome}' )]
    public function ws{Nome}( RestManager $restManager, Request $request, int $id = null ) {        
    $response = $restManager->processRequest( $request, 'ws{Nome}', $id );        
    return new JsonResponse( $response );                        
    }
```
### Aggiungere case gestione nel RestManager.php
```php
    public function generateClass(string $endPoint): void
    {
        switch ($endPoint) {
            case 'ws{nome}':
                $this->serviceClass = $this->container->get( 'app.{nome}Service' );
            break;        
        }
    }
```

### Modificche file service {nome}Service.php generato da copia esistente

- Array dei campi necessari nella request
```php
    //Lista dei campi obbligatori richiesti nella chiamata    
    public $checkFields = [ "line", "number", "price", "free", "eventId", "sectorId" ];
```

- Fare replace su tutto il file usando il proprio editor del nome della entita da cui si è copiato il file a quella nuova
    - ES
        - User => Place
        - user => place

- Creare il formato di array di risposta per le get
```php
    /**
     * Genera il formato di risposta utilizzato sia per il recupero di una singola row che di tutte    
     */
    private function getDataPlace( Place $place ) :array {
        $aPlace                     = [];
        $aPlace['id']               = $place->getId();                   
        $aPlace['line']             = $place->getLine();                   
        $aPlace['number']           = $place->getNumber();                                              
        $aPlace['price']            = $place->getPrice();                                              
        $aPlace['free']             = $place->getFree();                                              
        $aPlace['event']['id']      = $place->getEvent()->getId();                           
        $aPlace['event']['name']    = $place->getEvent()->getName();                           
        $aPlace['sector']['id']     = $place->getSector()->getId();                           
        $aPlace['sector']['name']   = $place->getSector()->getName();                           
        return $aPlace;
    }
```

- Modificare **metodo create** mettendo i set corretti per l'entita da gestire
```php

    //Se uno dei campi è una relazione invocare questo metodo per recuperare la relazione a partire dal suo id univoco
    $sector = $this->getRelEntity( 'Sector', $this->input->sectorId );
    if( $sector === false ) {
        return $this->response;
    }

    //Genero nuovo utente
    $place   = new Place();
    $place->setLine( $this->input->line );
    $place->setNumber( $this->input->number );        
    $place->setPrice( $this->input->price );        
    $place->setFree( $this->input->free );             
    $place->setEvent( $event );    
    $place->setSector( $sector ); 
```

- Modificare **metodo update** mettendo i set corretti per l'entita da gestire
```php

    //Se uno dei campi è una relazione invocare questo metodo per recuperare la relazione a partire dal suo id univoco
    if( !empty( $this->input->sectorId ) ) {
        $sector = $this->getRelEntity( 'Sector', $this->input->sectorId );
        if( $sector === false ) {
            return $this->response;
        }         
        $place->setSector( $sector );   
    }

    if( !empty( $this->input->line )){      $place->setLine( $this->input->line ); }
    if( !empty( $this->input->number )){    $place->setNumber( $this->input->number ); }
    if( !empty( $this->input->price )){     $place->setPrice( $this->input->price ); }     
    if( !empty( $this->input->free )){      $place->setFree( $this->input->free ); } 
```

