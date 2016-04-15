//
// ModuleArticleParamTabController.j
//
// Created by Philippe Fuentes.
//
@import <Foundation/Foundation.j>
@import <Foundation/CPObject.j>
@import <GrowlCappuccino/GrowlCappuccino.j>
@import <LPKit/LPMultiLineTextField.j>

@import "../../../Backend/Managers/RequestManager.j"
@import "../../../Backend/Managers/DataManager.j"
@import "../../../Backend/Managers/ErrorManager.j"
@import "../../../Backend/Data/Specie.j"
@import "../../../Backend/Data/Breed.j"
@import "../../../UI/Common/EDSVGIcon.j"

@class AppController;

@global KObjectTypeSpecieAndBreed;


@implementation ModuleSpecieAndBreedDataListController : CPObject
{
    @outlet CPView          _container;
    @outlet CPTableView     _specieTable;
    @outlet CPTableView     _breedTable;
    @outlet CPView          _buttonBarSpecieContainer;
    @outlet CPView          _buttonBarBreedContainer;

    //Icons
    @outlet EDSVGIcon       _refreshSpecieIcon;

    //Data
    CPMutableArray          _species;
    CPMutableDictionary     _speciesMap;

    CPMutableArray          _breeds;
    CPMutableDictionary     _breedsMap;

    CPMutableDictionary     _breedsBySpeciesMap;


    //affichage de l'analyse
    @outlet LPMultiLineTextField     _analyseTF;
    @outlet CPTextField              _analyseStatusLabel;

    //affichage de l'analyse
    @outlet LPMultiLineTextField     _synchronizationTF;
    @outlet CPTextField              _synchronizationStatusLabel;

//  CPInteger                _selectedSpecieIndex;

    Specie                   _newSpecieBeingAdded;
    Breed                    _newBreedBeingAdded;
}


- (id)init
{
   // CPLog.info(@">>>> Entering ModuleColorDataListController::init");

   // CPLog.info(@"<<<< Leaving ModuleColorDataListController::init");

    return self;
}


- (void)awakeFromCib
{
    CPLog.debug(@">>>> Entering ModuleSpecieAndBreedDataListController.j::awakeFromCib");

    [_container setBackgroundColor:[CPColor whiteColor]];

//    _selectedSpecieIndex = -1;

    //Les data sont dispo ?
    var species = [[DataManager sharedManager] species];
    if (nil == species)
    {
        [self refreshDataFromServer];
    }
    else
    {
        self.species    = species;
        self.speciesMap = [[DataManager sharedManager] speciesMap];
    }

    [self _addButtonBar:_buttonBarSpecieContainer];
    [self _addButtonBar:_buttonBarBreedContainer];

    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_getReferenceSpeciesAndBreedsListNotification:)           name:WSGetSpeciesAndBreedsReferenceDataNotification         object:nil];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_updateReferenceSpecieListNotification:)                  name:WSUpdateSpecieReferenceDataNotification                object:nil];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_updateReferenceBreedListNotification:)                   name:WSUpdateBreedReferenceDataNotification                 object:nil];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_addReferenceSpecieListNotification:)                     name:WSAddSpecieReferenceDataNotification                   object:nil];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_addReferenceBreedListNotification:)                      name:WSAddBreedReferenceDataNotification                    object:nil];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_deleteReferenceSpecieListNotification:)                  name:WSDeleteSpecieReferenceDataNotification                object:nil];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_deleteReferenceBreedListNotification:)                   name:WSDeleteBreedReferenceDataNotification                 object:nil];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_analyseReferenceSpeciesAndBreedsListNotification:)       name:WSAnalyseSpeciesAndBreedsReferenceDataNotification     object:nil];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_synchronizeReferenceSpeciesAndBreedsListNotification:)   name:WSSynchronizeSpeciesAndBreedsReferenceDataNotification object:nil];



    //Delegate table species
    [_specieTable setDataSource:self];
    [_specieTable setDelegate:self];
    [_specieTable setAllowsEmptySelection:NO];

     var nameTableColumn = [_specieTable tableColumnWithIdentifier:@"name"];
    [nameTableColumn setEditable:YES];

    var nameSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [nameTableColumn setSortDescriptorPrototype:nameSortDescriptor];


    //Delegate table species
    [_breedTable setDataSource:self];
    [_breedTable setDelegate:self];
    [_breedTable setAllowsEmptySelection:NO];

     nameTableColumn = [_breedTable tableColumnWithIdentifier:@"name"];
    [nameTableColumn setEditable:YES];

    nameSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [nameTableColumn setSortDescriptorPrototype:nameSortDescriptor];

    [_refreshSpecieIcon setDelegate:self];

    //analyse Multiline textfield
    [_analyseTF setEditable:NO];
    [_analyseTF setEnabled:YES];
    [_analyseTF setScrollable:YES];

    [_analyseStatusLabel setStringValue:@""];

    //synchronize Multiline textfield
    [_synchronizationTF setEditable:NO];
    [_synchronizationTF setEnabled:YES];
    [_synchronizationTF setScrollable:YES];

    [_synchronizationStatusLabel setStringValue:@""];

    //rafraichir l'analyse en parallèle
    [self refreshAnalyseFromServer];


    CPLog.debug(@"<<<< Leaving ModuleSpecieAndBreedDataListController.j::awakeFromCib");
}


- (void)refreshDataFromServer
{
//    [[AppController appDelegate] startProgressWithText:@"Chargement des espèces/races en cours..." isModal:true];
    [[AppController appDelegate] startProgressWithText:@"Chargement des espèces/races en cours..."];
    [[AppController appDelegate] startProgress];

    [[RequestManager sharedManager] performGetReferenceData:KObjectTypeSpecieAndBreed];
}

- (void)refreshAnalyseFromServer
{
    [_analyseStatusLabel setStringValue:@"Analyse en cours..."];
    [[RequestManager sharedManager] performAnalyseReferenceData:KObjectTypeSpecieAndBreed];
}




- (void)refreshSpecies
{
//    var indexPath = [CPIndexPath indexPathForRow:0 inSection:0];
//    [_specieTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:CPTableViewScrollPositionNone];

    var  rowIndex = 0,
         indexSet = [CPIndexSet indexSetWithIndex:rowIndex];

    [_specieTable scrollRowToVisible:rowIndex];
    [_specieTable selectRowIndexes:indexSet byExtendingSelection:NO];

    //[_specieTable deselectAll];
    //[_breedTable deselectAll];

    [_specieTable reloadData];
    [_breedTable reloadData];
}


- (void)refreshBreeds
{
    [_breedTable reloadData];
}


#pragma mark Delegate EDSVGIcon click

- (void)onClickIcon:(id)sender
{
    CPLog.debug(@" onClickIcon  TEST SENDER %@", sender);
    [self refreshDataFromServer];
}


//----o PUBLIC
#pragma mark -
#pragma mark Action


- (void)_addSpecieAction:(id)sender
{
    CPLog.debug(@"ModuleSpecieAndBreedDataListController::_addSpecieAction: %@", sender);

    if (_newSpecieBeingAdded == nil)
    {
        var specie   = [Specie new];

        [specie setUid:0];
        [specie setName:@""];

        [_species addObject:specie];

        var rowIndex = [_species count] - 1;

        [_specieTable reloadData];

        var indexSet = [CPIndexSet indexSetWithIndex:rowIndex];

        //PF: 10/12/2015 - si on ne scroll pas sur la cellule editColumn crash si la ligne n'est pas visible
        [_specieTable scrollRowToVisible:rowIndex];

        //sélection de la nouvelle espèce en fin de table
        [_specieTable selectRowIndexes:indexSet byExtendingSelection:NO];
        [_specieTable editColumn:0 row:rowIndex withEvent:nil select:NO];

        _newSpecieBeingAdded = specie;
    }
}

- (void)_addBreedAction:(id)sender
{
    CPLog.debug(@"ModuleSpecieAndBreedDataListController::_addBreedAction: %@", sender);

    var specieIndex = [_specieTable selectedRow];
    if (specieIndex >= 0)
    {
        if (_newBreedBeingAdded == nil)
        {
            var breed    = [Breed new],
                specie   = _species[specieIndex],
                specieId = [specie uid];

            [breed setUid:0];
            [breed setSpecieId:specieId];
            [breed setName:@""];



            [_breeds addObject:breed];

            var rowIndex = [_breeds count] - 1;

            [_breedTable reloadData];

            var indexSet = [CPIndexSet indexSetWithIndex:rowIndex];

            //PF: 10/12/2015 - si on ne scroll pas sur la cellule editColumn crash si la ligne n'est pas visible
            [_breedTable scrollRowToVisible:rowIndex];

            //sélection de la nouvelle espèce en fin de table
            [_breedTable selectRowIndexes:indexSet byExtendingSelection:NO];
            [_breedTable editColumn:0 row:rowIndex withEvent:nil select:NO];

            _newBreedBeingAdded = breed;
        }
    }
}


- (void)_removeSpecieAction:(id)sender
{
     CPLog.debug(@"ModuleSpecieAndBreedDataListController::_removeAction: %@", sender);

    var selectedIndex = [_specieTable selectedRow];

    CPLog.debug(@"_removeSpecieAction:: %@", selectedIndex);

    if (_newSpecieBeingAdded == nil && selectedIndex >= 0)
    {
        var specie = _species[selectedIndex];

        var alertMessage = @"Attention",
            alertInformative =  [CPString stringWithFormat:@"Etes vous sur de vouloir supprimer l'espèce %@ ?",[specie name]],
//            alertInformative =  @"êtes vous sur de vouloir supprimer la couleur ?",
            alert = [[CPAlert alloc] init];
    //                [alert setDelegate:self];
        [alert setDelegate:self];
        [alert setAlertStyle:CPCriticalAlertStyle];
        [alert addButtonWithTitle:@"Annuler"];
        [alert addButtonWithTitle:@"Ok"];
        [alert setMessageText:alertMessage];
        [alert setInformativeText:alertInformative];
        //[alert runModal];

        [alert runModalWithDidEndBlock:function(alert, buttonIndex)
            {
                if (1 == buttonIndex)
                {
                    [[AppController appDelegate] startProgress];
                    [[AppController appDelegate] startProgressWithText:@"Suppression en cours..."];
                    [[RequestManager sharedManager] performDeleteReferenceData:specie];
                }
            }];
    }
}

- (void)_removeBreedAction:(id)sender
{
     CPLog.debug(@"ModuleSpecieAndBreedDataListController::_removeAction: %@", sender);

    var selectedIndex = [_breedTable selectedRow];

    CPLog.debug(@"_removeBreedAction:: %@", selectedIndex);

    if (_newBreedBeingAdded == nil && selectedIndex >= 0)
    {
        var breed = _breeds[selectedIndex];

        var alertMessage = @"Attention",
            alertInformative =  [CPString stringWithFormat:@"Etes vous sur de vouloir supprimer la race %@ ?",[breed name]],
//            alertInformative =  @"êtes vous sur de vouloir supprimer la couleur ?",
            alert = [[CPAlert alloc] init];
    //                [alert setDelegate:self];
        [alert setDelegate:self];
        [alert setAlertStyle:CPCriticalAlertStyle];
        [alert addButtonWithTitle:@"Annuler"];
        [alert addButtonWithTitle:@"Ok"];
        [alert setMessageText:alertMessage];
        [alert setInformativeText:alertInformative];
        //[alert runModal];

        [alert runModalWithDidEndBlock:function(alert, buttonIndex)
            {
                if (1 == buttonIndex)
                {
                    [[AppController appDelegate] startProgress];
                    [[AppController appDelegate] startProgressWithText:@"Suppression en cours..."];
                    [[RequestManager sharedManager] performDeleteReferenceData:breed];
                }
            }];
    }
}

#pragma mark -
#pragma mark IB Action


- (IBAction)clearAnalyseTFAction:(id)aSender
{
    [_analyseTF setStringValue:@""];
}

- (IBAction)clearSynchronizationTFAction:(id)aSender
{
    [_synchronizationTF setStringValue:@""];
}

- (IBAction)analyseAction:(id)aSender
{
    [self refreshAnalyseFromServer];
}


- (IBAction)synchronizeAction:(id)aSender
{
    [_synchronizationStatusLabel setStringValue:@"Synchronisation en cours..."];
    [[RequestManager sharedManager] performSynchronizeReferenceData:KObjectTypeSpecieAndBreed];
}


#pragma mark -
#pragma mark Private


- (Boolean)_isSpecieExist:(CPString)name
{
    var result          = false,
        uppercaseName   = [name uppercaseString];

    for (var i = 0; i < [_species count]; i++)
    {
        var  specie                  = _species[i],
             specieNameUppercase     = [[specie name] uppercaseString];

        if ([uppercaseName isEqualToString:specieNameUppercase])
        {
            result = true;
            break;
        }
    }

    return result;
}


- (Boolean)_isBreedExist:(CPString)name
{
    var result          = false,
        uppercaseName   = [name uppercaseString],
        allBreeds       = [[DataManager sharedManager] breeds];

    for (var i = 0; i < [allBreeds count]; i++)
    {
        var breed                  = allBreeds[i],
            breedNameUppercase     = [[breed name] uppercaseString];

        if ([uppercaseName isEqualToString:breedNameUppercase])
        {
            result = true;
            break;
        }
    }

    return result;
}


- (void)_addButtonBar:(CPView)buttonBarContainer
{
// Button Bar
    var plusButton = [CPButtonBar plusButton],
        minusButton = [CPButtonBar minusButton],

        buttonBar = [[CPButtonBar alloc] initWithFrame:CGRectMake(1.0, 0.0, 100, 26)];

    [plusButton setTarget:self];
    [minusButton setTarget:self];

    if (_buttonBarSpecieContainer == buttonBarContainer)
    {
        [plusButton setAction:@selector(_addSpecieAction:)];
        [minusButton setAction:@selector(_removeSpecieAction:)];
    }
    else if (_buttonBarBreedContainer == buttonBarContainer)
    {
        [plusButton setAction:@selector(_addBreedAction:)];
        [minusButton setAction:@selector(_removeBreedAction:)];
    }

    [buttonBar setHasResizeControl:NO];
    //[buttonBar setAutoresizingMask:CPViewWidthSizable | CPViewMinYMargin];

    [buttonBar setButtons:[CPArray arrayWithObjects:plusButton, minusButton]];

    [buttonBarContainer addSubview:buttonBar];
}

- (void)_specieSelectionChanged
{
    var row             = [_specieTable selectedRow],
        selectedSpecie  = [_species objectAtIndex:row],
        specieId        = [selectedSpecie uid];

    _breeds = [_breedsBySpeciesMap objectForKey:specieId];

    //Si pas de race , on créé un tableau vide pour préparer l'ajout
    if (nil == _breeds)
    {
        _breeds = [CPMutableArray new];
        [_breedsBySpeciesMap setObject:_breeds forKey:specieId];
    }

    [self refreshBreeds];
}


#pragma mark Alert View - suppression de la couleur

- (void)alertView:(CPAlert)alertView clickedButtonAtIndex:(int)buttonIndex
{

     CPLog.debug(@"TEST: %@", buttonIndex);

}


#pragma mark -
#pragma mark Delegate table specieTable


- (int)numberOfRowsInTableView:(CPTableView)tableView
{
    var result = 0;

    if (_specieTable == tableView)
    {
        result = [_species count];
    }
    else if (_breedTable == tableView)
    {
        result = [_breeds count];
        /*
        if (_selectedSpecieIndex >= 0)
        {
            var selectedSpecie  = [_species objectAtIndex:_selectedSpecieIndex],
                specieId        = [selectedSpecie uid];

            result = [[_breedsBySpeciesMap objectForKey:specieId] count];
        }*/
    }

    return result;
}


/*! TableView delegate
*/
- (void)tableViewSelectionDidChange:(CPNotification)aNotification
{
//    CPLog.debug("TABLEVIEW: : tableViewSelectionDidChange aNotification: %@", );

    var tableView = [aNotification object];
    if (_specieTable == tableView)
    {
        [self _specieSelectionChanged];
    }
}




- (id)tableView:(id)tableView objectValueForTableColumn:(CPTableColumn)aColumn row:(CPInteger)aRow
{
   // CPLog.debug("TABLEVIEW: : objectValueForTableColumn aRow: %@", aRow);
    var name    = @"";


    if (_specieTable == tableView)
    {
        var specie  = _species[aRow];
        name        = [specie name];
    }
    else if (_breedTable == tableView)
    {
        /*
        var selectedSpecie      = [_species objectAtIndex:_selectedSpecieIndex],
            specieId            = [selectedSpecie uid],
            breedsForSpecies    = [_breedsBySpeciesMap objectForKey:specieId],
            breed               = breedsForSpecies[aRow];
            */
        var breed   = _breeds[aRow];
        name        = [breed name];
    }

   return name;
}


#pragma mark -
#pragma mark Edition des cellules de la table specieTable


- (void)tableView:(CPTableView)tableView setObjectValue:(id)aValue forTableColumn:(CPTableColumn)tableColumn row:(CPInteger)aRow
{
 //   CPLog.debug(@"ModuleArticleCategoryTabController::setObjectValue: row: %d   value: %@", aRow, aValue);

    var value = [aValue stringByTrimmingWhitespace];

    if (_specieTable == tableView)
    {
        if (_newSpecieBeingAdded != nil)
        {
            if ([value isEqualToString:@""])
            {
                [_species removeObject:_newSpecieBeingAdded];
            }
            else
            {
                //TODO: checker si une couleur du même nom existe déjà, pour éviter les doublons
                if (![self _isSpecieExist:value])
                {
                    [_newSpecieBeingAdded setUid:0];
                    [_newSpecieBeingAdded setName:value];

                    [[AppController appDelegate] startProgressWithText:@"Ajout en cours..."];
                    [[AppController appDelegate] startProgress];

                    [[RequestManager sharedManager] performAddReferenceData:_newSpecieBeingAdded];
                }
                else
                {
                    [_species removeObject:_newSpecieBeingAdded];
                    var errorMsg = @"Une espèce avec le même nom existe déjà";
                    [[ErrorManager sharedManager] displayErrorMessage:errorMsg];
                }

            }
            _newSpecieBeingAdded = nil;
        }
        else
        {
            var specie       = _species[aRow];
            if (![value isEqualToString:@""] && ![[specie name] isEqual:value])
            {
                var  specieUpdate = [[SpecieUpdate alloc] initWithSpecie:specie];

                [specie setName:value];
                [specieUpdate setName:value];

                [[AppController appDelegate] startProgressWithText:@"Modification en cours..."];
                [[AppController appDelegate] startProgress];

                [[RequestManager sharedManager] performUpdateReferenceData:specieUpdate];
            }
        }

    }
    else if (_breedTable == tableView)
    {
        if (_newBreedBeingAdded != nil)
        {
            if ([value isEqualToString:@""])
            {
                [_breeds removeObject:_newBreedBeingAdded];
            }
            else
            {
                if (![self _isBreedExist:value])
                {
                    [_newBreedBeingAdded setUid:0];
                    [_newBreedBeingAdded setName:value];

                    [[AppController appDelegate] startProgressWithText:@"Ajout en cours..."];
                    [[AppController appDelegate] startProgress];

                    [[RequestManager sharedManager] performAddReferenceData:_newBreedBeingAdded];
                }
                else
                {
                    [_breeds removeObject:_newBreedBeingAdded];
                    var errorMsg = @"Une race avec le même nom existe déjà";
                    [[ErrorManager sharedManager] displayErrorMessage:errorMsg];
                }

            }
            _newBreedBeingAdded = nil;
        }
        else
        {
            var breed       = _breeds[aRow];
            if (![value isEqualToString:@""] && ![[breed name] isEqual:value])
            {
                var  breedUpdate = [[BreedUpdate alloc] initWithBreed:breed];

                [breed setName:value];
                [breedUpdate setName:value];

                [[AppController appDelegate] startProgressWithText:@"Modification en cours..."];
                [[AppController appDelegate] startProgress];

                [[RequestManager sharedManager] performUpdateReferenceData:breedUpdate];
            }
        }
    }
}

#pragma mark -
#pragma mark WS Notification


- (void)_getReferenceSpeciesAndBreedsListNotification:(CPNotification)notification;
{
    CPLog.debug(@"_getReferenceSpeciesAndBreedsListNotification");

    [[AppController appDelegate] stopProgress];

    var userInfo = [notification userInfo],
        error    = [userInfo objectForKey:ServicesErrorKey];

    if (nil == error)
    {
        [[AppController appDelegate] stopProgressWithText:@"Espèces et races chargés"];

        _species      = [[DataManager sharedManager] species],
        _speciesMap   = [[DataManager sharedManager] speciesMap];

        //_breeds = nil; //pas de sélection d'espèce pour le moment
        _breedsMap          = [[DataManager sharedManager] breedsMap];
        _breedsBySpeciesMap = [[DataManager sharedManager] breedsBySpeciesMap];

        [self refreshSpecies];
       // [self refreshBreeds];
    }
    else
    {
        [[AppController appDelegate] stopProgressWithText:@"Le chargement des espèces et des races a échoué"];
        var errorMsg = @"Le chargement des espèces et races a échoué";
        [[ErrorManager sharedManager] displayErrorMessage:errorMsg];
    }
}


- (void)_updateReferenceSpecieListNotification:(CPNotification)notification;
{
    [[AppController appDelegate] stopProgress];

    var userInfo        = [notification userInfo],
        error           = [userInfo objectForKey:ServicesErrorKey],
        job             = [userInfo objectForKey:ServicesJobKey],
        request         = [job request],
        specieUpdate    = [request object];

    CPLog.debug(@"---- UPDATE SPECIE: name: %@   id request: %@", [specieUpdate name], request.id);

    var specie = [_speciesMap objectForKey:[specieUpdate uid]];

    if (nil == error)
    {
        var msg = [CPString stringWithFormat:@"Espèce %@ modifiée avec succès", [specie name]];
        [[AppController appDelegate] stopProgressWithText:msg];

        [self refreshAnalyseFromServer];
    }
    else
    {
        //On remet l'ancienne espèce
        //var specie = [_speciesMap objectForKey:[specieUpdate uid]];
        [specie setName:[specieUpdate saveName]];
        var errorMsg = [CPString stringWithFormat:@"L'enregistrement de l'espèce %@ a échoué", [specieUpdate name]];
        [[TNGrowlCenter defaultCenter] pushNotificationWithTitle:@"Espèce de référence" message:errorMsg];
        [[AppController appDelegate] stopProgressWithText:@""];
        [self refreshSpecies];
    }
}

- (void)_updateReferenceBreedListNotification:(CPNotification)notification;
{
    [[AppController appDelegate] stopProgress];

    var userInfo        = [notification userInfo],
        error           = [userInfo objectForKey:ServicesErrorKey],
        job             = [userInfo objectForKey:ServicesJobKey],
        request         = [job request],
        breedUpdate     = [request object];

    CPLog.debug(@"---- UPDATE BREED: name: %@   id request: %@", [breedUpdate name], request.id);

    var breed = [_breedsMap objectForKey:[breedUpdate uid]];

    if (nil == error)
    {
        var msg = [CPString stringWithFormat:@"Race %@ modifiée avec succès", [breed name]];
        [[AppController appDelegate] stopProgressWithText:msg];

        [self refreshAnalyseFromServer];
    }
    else
    {
        //On remet l'ancienne espèce
        //var specie = [_speciesMap objectForKey:[specieUpdate uid]];
        [breed setName:[breedUpdate saveName]];
        var errorMsg = [CPString stringWithFormat:@"L'enregistrement de la race %@ a échoué", [breedUpdate name]];
        [[TNGrowlCenter defaultCenter] pushNotificationWithTitle:@"Race de référence" message:errorMsg];
        [[AppController appDelegate] stopProgressWithText:@""];
        [self refreshBreeds];
    }
}

- (void)_addReferenceSpecieListNotification:(CPNotification)notification;
{
   // [[CPNotificationCenter defaultCenter] removeObserver:self name:WSUpdateReferenceDataNotification object:nil];

    [[AppController appDelegate] stopProgress];
    [[AppController appDelegate] stopProgressWithText:@""];

    var userInfo    = [notification userInfo],
        error       = [userInfo objectForKey:ServicesErrorKey],
        job         = [userInfo objectForKey:ServicesJobKey],
        request     = [job request],
        specie      = [request object];

    CPLog.debug(@"---- ADD SPECIE: name: %@   id request: %@", [specie name], request.id);

    if (nil == error)
    {
        var msg = [CPString stringWithFormat:@"Espèce %@ ajoutée avec succès", [specie name]];
        [[AppController appDelegate] stopProgressWithText:msg];

        //On se positonne dans le tableau des espèces sur la nouvelle ajoutée
        [self _specieSelectionChanged];

        [self refreshAnalyseFromServer];
    }
    else
    {
        var errorMsg = [CPString stringWithFormat:@"L'enregistrement de l'espèce %@ a échoué", [specie name]];
        [[TNGrowlCenter defaultCenter] pushNotificationWithTitle:@"Espèces de référence" message:errorMsg];

        [_species removeObject:specie];

        [self refreshSpecies];
    }
}

- (void)_addReferenceBreedListNotification:(CPNotification)notification;
{
    [[AppController appDelegate] stopProgress];
    [[AppController appDelegate] stopProgressWithText:@""];

    var userInfo    = [notification userInfo],
        error       = [userInfo objectForKey:ServicesErrorKey],
        job         = [userInfo objectForKey:ServicesJobKey],
        request     = [job request],
        breed       = [request object];

    CPLog.debug(@"---- ADD BREED: name: %@   id request: %@", [breed name], request.id);

    if (nil == error)
    {
        var msg = [CPString stringWithFormat:@"Race %@ ajoutée avec succès", [breed name]];
        [[AppController appDelegate] stopProgressWithText:msg];

        //Ajouter l'objet à la totalité des breed aussi
        var allBreeds       = [[DataManager sharedManager] breeds];
        [allBreeds addObject:breed];


        [self refreshAnalyseFromServer];
    }
    else
    {
        var errorMsg = [CPString stringWithFormat:@"L'enregistrement de la race %@ a échoué", [breed name]];
        [[TNGrowlCenter defaultCenter] pushNotificationWithTitle:@"Races de référence" message:errorMsg];

        [_breeds removeObject:breed];
        //Enlever l'objet à la totalité des breed aussi
        var allBreeds       = [[DataManager sharedManager] breeds];
        [allBreeds removeObject:breed];


        [self refreshBreeds];
    }
}

- (void)_deleteReferenceSpecieListNotification:(CPNotification)notification;
{
    [[AppController appDelegate] stopProgress];
    [[AppController appDelegate] stopProgressWithText:@""];

    var userInfo    = [notification userInfo],
        error       = [userInfo objectForKey:ServicesErrorKey],
        job         = [userInfo objectForKey:ServicesJobKey],
        request     = [job request],
        specie      = [request object];

    CPLog.debug(@"---- DELETE SPECIE: name: %@   id request: %@", [specie name], request.id);

    if (nil == error)
    {
        var msg = [CPString stringWithFormat:@"Espèce supprimée avec succès", [specie name]];
        [[AppController appDelegate] stopProgressWithText:msg];

        [_species removeObject:specie];
        [self refreshSpecies];

        [self refreshAnalyseFromServer];
    }
    else
    {
        var errorMsg = [CPString stringWithFormat:@"La suppression de l'espèce %@ a échouée", [specie name]];
        [[TNGrowlCenter defaultCenter] pushNotificationWithTitle:@"Espèces de référence" message:errorMsg];
    }
}

- (void)_deleteReferenceBreedListNotification:(CPNotification)notification;
{
    [[AppController appDelegate] stopProgress];
    [[AppController appDelegate] stopProgressWithText:@""];

    var userInfo    = [notification userInfo],
        error       = [userInfo objectForKey:ServicesErrorKey],
        job         = [userInfo objectForKey:ServicesJobKey],
        request     = [job request],
        breed       = [request object];

    CPLog.debug(@"---- DELETE BREED: name: %@   id request: %@", [breed name], request.id);

    if (nil == error)
    {
        var msg = [CPString stringWithFormat:@"Race supprimée avec succès", [breed name]];
        [[AppController appDelegate] stopProgressWithText:msg];

        [_breeds removeObject:breed];

        var allBreeds = [[DataManager sharedManager] breeds];
        [allBreeds removeObject:breed];

        [self refreshBreeds];

        [self refreshAnalyseFromServer];
    }
    else
    {
        var errorMsg = [CPString stringWithFormat:@"La suppression de la race %@ a échouée", [breed name]];
        [[TNGrowlCenter defaultCenter] pushNotificationWithTitle:@"Races de référence" message:errorMsg];
    }
}


- (void)_analyseReferenceSpeciesAndBreedsListNotification:(CPNotification)notification;
{
    var userInfo    = [notification userInfo],
        error       = [userInfo objectForKey:ServicesErrorKey],
        job         = [userInfo objectForKey:ServicesJobKey],
        request     = [job request];

   // var job = [userInfo objectForKey:ServicesJobKey];
   // var request = [job request];

   [_analyseStatusLabel setStringValue:@""];

    if (nil == error)
    {
        var analyseResult = [request getAnalyseResult];
        CPLog.debug(@"---- _analyseReferenceSpeciesAndBreedsListNotification: %@", analyseResult);

        var previousText = [_analyseTF stringValue],
            newText      = [CPString stringWithFormat:@"%@\n%@", previousText, analyseResult];

        [_analyseTF setStringValue:newText];

/*
var textarea = _analyseTF._DOMTextareaElement;
textarea.focus();
textarea.scrollTop = textarea.scrollHeight;
//[_analyseTF setNeedsLayout];
*/


        //var msg = @"La modification a été réalisée avec succès";
        //[[TNGrowlCenter defaultCenter] pushNotificationWithTitle:@"Config Module Article" message:msg];
//      [[AppController appDelegate] stopProgressWithText:@"Couleurs chargées"];
    }
    else
    {
        //Erreur
        CPLog.debug(@"---- _analyseReferenceColorListNotification: ERROR:  id: %@", [request id]);
        [[TNGrowlCenter defaultCenter] pushNotificationWithTitle:@"Analyse vers CRV" message:@"L'analyse a échouée"];
    }
}


- (void)_synchronizeReferenceSpeciesAndBreedsListNotification:(CPNotification)notification;
{
//    [[CPNotificationCenter defaultCenter] removeObserver:self name:WSGetReferenceDataNotification object:nil];

    var userInfo    = [notification userInfo],
        error       = [userInfo objectForKey:ServicesErrorKey],
        job         = [userInfo objectForKey:ServicesJobKey],
        request     = [job request];

    [_synchronizationStatusLabel setStringValue:@""];

    if (nil == error)
    {
        CPLog.debug(@"---- _synchronizeReferenceSpeciesAndBreedsListNotification");

        var synchronizationResult = [request getSynchronizationResult];

        var previousText = [_synchronizationTF stringValue],
            newText      = [CPString stringWithFormat:@"%@\n%@", previousText, synchronizationResult];

        [_synchronizationTF setStringValue:newText];

        [self refreshAnalyseFromServer];
    }
    else
    {
        //Erreur
        CPLog.debug(@"---- _synchronizeReferenceSpeciesAndBreedsListNotification: ERROR:  id: %@", [request id]);
        [[TNGrowlCenter defaultCenter] pushNotificationWithTitle:@"Synchronisation vers CRV" message:@"La synchronisation a échouée"];

    }
}



@end



