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


@class AppController;

@global KObjectTypeUser;

var C_COLUMN_UID                = "uid",
    C_COLUMN_USER_TYPE_ID       = "userType",
    C_COLUMN_CLINIC_ID          = "clinicId",
    C_COLUMN_EMAIL_ID           = "email",
    C_COLUMN_FIRSTNAME_ID       = "firstname",
    C_COLUMN_LASTNAME_ID        = "lastname",
    C_COLUMN_PASSWORD_ID        = "password",
    C_COLUMN_LAST_UPDATE_ID     = "lastUpdate",
    C_COLUMN_VETUPGUID_ID       = "vetupGuid",
    C_COLUMN_REGISTRATION_REFERRER_ID = "registrationReferrer";

/*
    CPString    registrationReferrer    @accessors(property=registrationReferrer);
    CPString    vetupGuid               @accessors(property=vetupGuid);
    CPString    lastUpdate              @accessors(property=lastUpdate);
*/

/*
    CPNumber    uid                     @accessors(property=uid);
    CPNumber    userTypeId              @accessors(property=userTypeId);
    CPNumber    clinicId                @accessors(property=clinicId);
    CPString    email                   @accessors(property=email);
    CPString    firstname               @accessors(property=firstname);
    CPString    lastname                @accessors(property=lastname);
*/

//SELECT * FROM vetup_user where vetup_user.clinicId NOT IN (SELECT id from vetup_clinic)


@implementation ModuleAnalyseUserController : CPObject
{
    @outlet CPView              _container;
    @outlet CPTableView         _userTable;
    @outlet CPPredicateEditor   _predicateEditor;

    @outlet CPTextField _progressLoadingTF;
    @outlet CPTextField _totalUsersTF;
    @outlet CPTextField _criterasLabelTF;
    @outlet CPTextField _tableCountTF;

    //Data
    CPMutableArray          _users;

    //Pagination
    CPNumber  _pageSize;
    CPNumber  _currentPage;
    CPNumber  _totalUsers;
    CPNumber  _totalPages;

    CPNumber _nbLoadedUser;

    //var de binding (effectuée dans IB) pour tracker les changements du CPPredicateEditor
    CPPredicate bindedPredicateEditorValue;
}


- (id)init
{
    return self;
}


- (void)awakeFromCib
{
    CPLog.debug(@">>>> Entering ModuleAnalyseUserController::awakeFromCib");
    [_container setBackgroundColor:[CPColor whiteColor]];

//    CPLog.debug(@"CONTAINER ModuleAnalyseUserController: %@", _container);

    //Delegate / data source pour le drag & drop
    [_userTable setDataSource:self];
    [_userTable setDelegate:self];
    [_userTable setAllowsEmptySelection:YES];
    [_userTable setAllowsMultipleSelection:YES];

    var idTableColumn = [_userTable tableColumnWithIdentifier:C_COLUMN_UID];
    [idTableColumn setEditable:YES]; //permettre la sélection

    var userTypeIdTableColumn = [_userTable tableColumnWithIdentifier:C_COLUMN_USER_TYPE_ID];
    [userTypeIdTableColumn setEditable:YES]; //permettre la sélection

    var clinicIdTableColumn = [_userTable tableColumnWithIdentifier:C_COLUMN_CLINIC_ID];
    [clinicIdTableColumn setEditable:YES]; //permettre la sélection

    var emailTableColumn = [_userTable tableColumnWithIdentifier:C_COLUMN_EMAIL_ID];
    [emailTableColumn setEditable:YES]; //permettre la sélection

    var firstnameTableColumn = [_userTable tableColumnWithIdentifier:C_COLUMN_FIRSTNAME_ID];
    [firstnameTableColumn setEditable:YES]; //permettre la sélection

    var lastnameTableColumn = [_userTable tableColumnWithIdentifier:C_COLUMN_LASTNAME_ID];
    [lastnameTableColumn setEditable:YES]; //permettre la sélection

    var passwordTableColumn = [_userTable tableColumnWithIdentifier:C_COLUMN_PASSWORD_ID];
    [passwordTableColumn setEditable:YES]; //permettre la sélection

    var lastUpdateTableColumn = [_userTable tableColumnWithIdentifier:C_COLUMN_LAST_UPDATE_ID];
    [lastUpdateTableColumn setEditable:YES]; //permettre la sélection

    var vetupGuidTableColumn = [_userTable tableColumnWithIdentifier:C_COLUMN_VETUPGUID_ID];
    [vetupGuidTableColumn setEditable:NO];

    var registrationReferrerTableColumn = [_userTable tableColumnWithIdentifier:C_COLUMN_REGISTRATION_REFERRER_ID];
    [registrationReferrerTableColumn setEditable:NO];


    //TABLE VIEW SORTING
    var idSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"uid" ascending:YES];
    [idTableColumn setSortDescriptorPrototype:idSortDescriptor];

    var userTypeSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"userTypeId" ascending:YES];
    [userTypeIdTableColumn setSortDescriptorPrototype:userTypeSortDescriptor];

    var clinicIdDescriptor = [CPSortDescriptor sortDescriptorWithKey:"clinicId" ascending:YES];
    [clinicIdTableColumn setSortDescriptorPrototype:clinicIdDescriptor];

    var emailSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"email" ascending:YES];
    [emailTableColumn setSortDescriptorPrototype:emailSortDescriptor];

    var firstnameSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"firstname" ascending:YES];
    [firstnameTableColumn setSortDescriptorPrototype:firstnameSortDescriptor];

    var lastnameSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"lastname" ascending:YES];
    [lastnameTableColumn setSortDescriptorPrototype:lastnameSortDescriptor];

    var passwordSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"password" ascending:YES];
    [passwordTableColumn setSortDescriptorPrototype:passwordSortDescriptor];

    var lastUpdateSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"lastUpdate" ascending:YES];
    [lastUpdateTableColumn setSortDescriptorPrototype:lastUpdateSortDescriptor];

    var vetupGuidSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"vetupGuid" ascending:YES];
    [vetupGuidTableColumn setSortDescriptorPrototype:vetupGuidSortDescriptor];

    var registrationReferrerSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"registrationReferrer" ascending:YES];
    [registrationReferrerTableColumn setSortDescriptorPrototype:registrationReferrerSortDescriptor];


//    var passwordSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"password" ascending:YES];
//    [passwordTableColumn setSortDescriptorPrototype:passwordSortDescriptor];


/*
    var passwordTableColumn = [_userTable tableColumnWithIdentifier:C_COLUMN_PASSWORD_ID];
    [passwordTableColumn setEditable:NO];

    var creationDateTableColumn = [_userTable tableColumnWithIdentifier:C_COLUMN_CREATION_DATE_ID];
    [creationDateTableColumn setEditable:NO];
*/
/*
var C_COLUMN_UID                = "uid",
    C_COLUMN_USER_TYPE_ID       = "userType",
    C_COLUMN_CLINIC_ID          = "clinicId",
    C_COLUMN_EMAIL_ID           = "email",
    C_COLUMN_FIRSTNAME_ID       = "firstname",
    C_COLUMN_LASTNAME_ID        = "lastname",
*/
    [_predicateEditor setDelegate:self];
    [_predicateEditor setBackgroundColor:[CPColor whiteColor]];
    [_predicateEditor setCanRemoveAllRows:YES];

    //SIPredicateStringValueTransformer *transformer = [[[SIPredicateStringValueTransformer alloc] init] autorelease];
    //var bindingOptions = [CPMutableDictionary dictionaryWithObjectsAndKeys:transformer, NSValueTransformerBindingOption, [NSNumber numberWithBool:YES], NSValidatesImmediatelyBindingOption, nil];
//    [predicateEditor bind:@"value" toObject:self withKeyPath:@"self.bindedPredicateEditorValue" options:bindingOptions];
    [_predicateEditor bind:@"value" toObject:self withKeyPath:@"self.bindedPredicateEditorValue" options:nil];



    //observe les changements de la propriété bindedPredicateEditorValue bindée sur le objectValue du CPPredicateEditor
//    [self addObserver:self forKeyPath:@"bindedPredicateEditorValue" options:CPKeyValueObservingOptionOld | CPKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"bindedPredicateEditorValue" options:CPKeyValueObservingOptionNew context:nil];

    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_getVetupUsersNotification:)  name:WSGetVetupUsersNotification   object:nil];

    //10000 user par requête
    _pageSize = 10000;
    _totalPages = 0;
    _nbLoadedUser = 0;

    [_totalUsersTF setEditable:NO];
    [_progressLoadingTF setEditable:NO];

    [_tableCountTF setEditable:NO];
    [_tableCountTF setStringValue:@"0"];


/*
1
[self addObserver:self forKeyPath:@"self.sliderValue" options:NSKeyValueObservingOptionNew context:nil];
And implement observeValueForKeyPath:ofObject:change:context:
?
1
2
3
4
5
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSInteger newVal = (NSInteger)[change objectForKey:NSKeyValueChangeNewKey];
    NSLog(@"changed %ld", newVal);
}
*/


/*
    //sorting
    var idSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"uid" ascending:YES];
    [idTableColumn setSortDescriptorPrototype:idSortDescriptor];

    var emailSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"email" ascending:YES];
    [emailTableColumn setSortDescriptorPrototype:emailSortDescriptor];

    var nbLinkedUsersSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"nbLinkedUsers" ascending:YES];
    [nbLinkedUsersTableColumn setSortDescriptorPrototype:nbLinkedUsersSortDescriptor];

    var passwordSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"password" ascending:YES];
    [passwordTableColumn setSortDescriptorPrototype:passwordSortDescriptor];

    var creationDateSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"creationDate" ascending:YES];
    [creationDateTableColumn setSortDescriptorPrototype:creationDateSortDescriptor];


    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_getCRVUniqueUsersNotification:)          name:WSGetCRVUniqueUsersNotification     object:nil];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_getCRVUsersNotification:)                name:WSGetCRVUsersNotification           object:nil];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_mergeUsersNotification:)                 name:WSMergeCRVUsersNotification           object:nil];
*/







/*
    //Init search field

    [_searchField setRecentsAutosaveName:"autosave"];
    [_searchField setTarget:self];
    [_searchField setAction:@selector(_updateFilter:)];


    //ajout du menu de recherche au searchfield

    _searchMenuTemplate = [_searchField defaultSearchMenuTemplate];

    _menuItemPrefix = @"   ";
    _searchCriteriaIndex = 0;
    _searchCriteriaIndexes = [CPArray arrayWithArray:[1, 2, 3, 4]];
    _criteriasKeyPath  = ["email", "firstname", "lastname", "uid"];

    [_searchMenuTemplate insertItemWithTitle:@"Rechercher par"
                                     action:nil
                              keyEquivalent:@""
                                    atIndex:0];


    var item = [[CPMenuItem alloc] initWithTitle:_menuItemPrefix + @"Email"
                                          action:@selector(_changeSearchCriteria:)
                                   keyEquivalent:@""];

    [item setTarget:self];
    [item setTag:1];
    [item setState:CPOffState];
    [_searchMenuTemplate insertItem:item atIndex:1];


    item = [[CPMenuItem alloc] initWithTitle:_menuItemPrefix + @"Prénom"
                                          action:@selector(_changeSearchCriteria:)
                                   keyEquivalent:@""];

    [item setTarget:self];
    [item setTag:2];
//    [item setState:CPOffState];
    [item setState:CPOnState];
    [_searchMenuTemplate insertItem:item atIndex:2];

    item = [[CPMenuItem alloc] initWithTitle:_menuItemPrefix + @"Nom"
                                      action:@selector(_changeSearchCriteria:)
                                keyEquivalent:@""];
    [item setTarget:self];
    [item setTag:3];
    [item setState:CPOffState];
    [_searchMenuTemplate insertItem:item atIndex:3];

    item = [[CPMenuItem alloc] initWithTitle:_menuItemPrefix + @"Id"
                                      action:@selector(_changeSearchCriteria:)
                                keyEquivalent:@""];
    [item setTarget:self];
    [item setTag:4];
    [item setState:CPOffState];
    [_searchMenuTemplate insertItem:item atIndex:4];


    [_searchField setSearchMenuTemplate:_searchMenuTemplate];


    [self _changeSearchCriteria:[[_searchField menu] itemAtIndex:1]];
    [self _updateFilter:_searchField];

    [_searchField setDelegate:self];
    */

    CPLog.debug(@"<<<< Leaving ModuleAnalyseUserController::awakeFromCib");
}



- (void)refreshDataFromServer
{
    _currentPage = 1;
    _nbLoadedUser = 0;
    _totalUsers = 0;

    [self _displayProgress:0];
    [self _updateNbLoadedUser:0];


    //On vide le tableau des users
    [[DataManager sharedManager] initVetupUserArray];

    [_users removeAllObjects];
    [self refresh];

    [[AppController appDelegate] startProgressWithText:@"Chargement des vetup users en cours, veuillez patienter..."];
    [[RequestManager sharedManager] performGetVetupUsers:_pageSize currentPage:1];


/*
    [[RequestManager sharedManager] performGetVetupUsers:10000 currentPage:1];
    [[RequestManager sharedManager] performGetVetupUsers:10000 currentPage:2];
    [[RequestManager sharedManager] performGetVetupUsers:10000 currentPage:3];
    [[RequestManager sharedManager] performGetVetupUsers:10000 currentPage:4];
    [[RequestManager sharedManager] performGetVetupUsers:10000 currentPage:5];
    [[RequestManager sharedManager] performGetVetupUsers:10000 currentPage:6];
    [[RequestManager sharedManager] performGetVetupUsers:10000 currentPage:7];
    [[RequestManager sharedManager] performGetVetupUsers:10000 currentPage:8];
    [[RequestManager sharedManager] performGetVetupUsers:10000 currentPage:9];
    [[RequestManager sharedManager] performGetVetupUsers:10000 currentPage:10];
    [[RequestManager sharedManager] performGetVetupUsers:10000 currentPage:11];
    */

}


- (void)refresh
{
    [_userTable reloadData];
}

#pragma mark Delegate EDSVGIcon click

- (void)onClickIcon:(id)sender
{
    [self refreshDataFromServer];
}

//----o PUBLIC
#pragma mark -
#pragma mark Action


#pragma mark -
#pragma mark KVO Observation => pour détecter des modifs sur le CPPredicateEditor

- (void)observeValueForKeyPath:(CPString)aKeyPath
                      ofObject:(id)anObject
                        change:(CPDictionary)aChange
                       context:(id)aContext
{
    if ([aKeyPath isEqualToString:@"bindedPredicateEditorValue"])
    {
//        CPLog.debug("---- observeValueForKeyPath: %@   editor value: %@", aKeyPath, [_predicateEditor objectValue]);
        var filterDescription = [bindedPredicateEditorValue description];
        [_criterasLabelTF setStringValue:filterDescription];

/*
        var filteredArray = [_users filteredArrayUsingPredicate:bindedPredicateEditorValue];
        _users = filteredArray;
        [self refresh]
        */

        [self _refreshTableFromPredicate];
    }
}

#pragma mark -
#pragma mark Delegate predicate

- (void)ruleEditorRowsDidChange:(CPNotification)notification
{
//    CPLog.debug(@" ruleEditorRowsDidChange :  %@", [_predicateEditor objectValue]);
}


- (void)print:(id)sender
{
    CPLog.debug(@" print");

}


#pragma mark -
#pragma mark IB Action

- (IBAction)refreshDataFromServerAction:(id)aSender
{
    [self refreshDataFromServer];
}

/*
- (IBAction)predicateEditorAction:(id)sender
{
    CPLog.debug(@" ---predicateEditorAction");
}
*/

- (IBAction)testMultiselection:(id)aSender
{
    CPLog.debug(@" ---testMultiselection");

    var indexes     = [_userTable selectedRowIndexes],
    objects     = [_users objectsAtIndexes:indexes];



    if ([objects count] > 0)
    {
        var users = [CPArray new];

        for (var i = 0; i < [objects count]; i++)
        {
            var user    = [objects objectAtIndex:i];
            [users addObject:[user email]];

            CPLog.debug(@" ----- testMultiselection: %@", [user email]);
        }

/*
        [[AppController appDelegate] startProgressWithText:@"Suppression des utilisateurs CRV..."];
        [[AppController appDelegate] startProgress];

        [[RequestManager sharedManager] performDeleteCRVUsers:emails];
*/
    }
    else
    {
        [[ErrorManager sharedManager] displayErrorMessage:@"Vous devez sélectionner les utilisateurs à supprimer"];
    }
}



#pragma mark -
#pragma mark Private


- (void)_displayProgress:(CPNumber)progressValue
{
    var msg = [CPString stringWithFormat:@"%d%%", progressValue];
    [_progressLoadingTF setStringValue:msg];
}

- (void)_updateNbLoadedUser:(CPNumber)loadedUser
{
    _nbLoadedUser += loadedUser;

    var msg = [CPString stringWithFormat:@"%d/%d", _nbLoadedUser, _totalUsers];
    [_totalUsersTF setStringValue:msg];
}

- (void)_refreshTableFromPredicate
{
    var allUsers = [[DataManager sharedManager] vetupUsers],
        filteredArray = allUsers;

    if (self.bindedPredicateEditorValue != nil)
    {
        filteredArray = [allUsers filteredArrayUsingPredicate:self.bindedPredicateEditorValue];
    }

    _users = filteredArray;

    var formattedCount = [CPString stringWithFormat:@"%d", [_users count]];
    [_tableCountTF setStringValue:formattedCount];

    [self refresh];
}


/*

- (void)_uniqueUserSelectionChanged
{
    var row = [_userTable selectedRow];

    if (row >= 0)
    {
        var selectedUniqueUser  = [_uniqueUsers objectAtIndex:row];
        _linkedUsers = [selectedUniqueUser linkedUsers];
        [self refreshLinkedUsers];
    }
}


- (void)_changeSearchCriteria:(CPMenuItem)menuItem
{
    _searchCriteriaIndex = [menuItem tag] - 1;

    [_searchField setPlaceholderString:[[menuItem title] substringFromIndex:[_menuItemPrefix length]]];

    [self _updateSearchMenuTemplate];
}

- (void)_updateSearchMenuTemplate
{
    for (var i = 0; i < _searchCriteriaIndexes.length; i++)
        [[_searchMenuTemplate itemAtIndex:_searchCriteriaIndexes[i]] setState:CPOffState];


    var selectedCriteriaIndex = _searchCriteriaIndexes[_searchCriteriaIndex],
        menuItem = [_searchMenuTemplate itemAtIndex:selectedCriteriaIndex];

    [menuItem setState:CPOnState];

    [_searchField setSearchMenuTemplate:_searchMenuTemplate];

    //on relance la recherche
    [self _updateFilter:_searchField];
}

- (void)_updateFilter:(id)sender
{
//    CPLog.debug(@">>>> Entering ModuleUniqueUserController::_updateFilter");

    var  uniqueUsers    = [[DataManager sharedManager] uniqueUsers],
         result         = uniqueUsers,
         searchString   = [sender stringValue],
         keyPath        = _criteriasKeyPath[_searchCriteriaIndex];

    if (![searchString isEqualToString:@""])
    {
        var predicate = nil;
        if ([keyPath isEqualToString:@"uid"])
        {
            var uid = [searchString intValue];
            predicate = [CPPredicate predicateWithFormat:@"%K = %d", keyPath, uid];
        }
        else
        {
            predicate = [CPPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", keyPath, searchString];
        }

        result = [uniqueUsers filteredArrayUsingPredicate:predicate];
    }

    _uniqueUsers    = result;

    [_nbUniqueUsers setStringValue:[_uniqueUsers count]];
    [_uniqueUserTable reloadData];
}
*/

#pragma mark -
#pragma mark Delegate CPSearchField


#pragma mark Alert View - suppression de la couleur

- (void)alertView:(CPAlert)alertView clickedButtonAtIndex:(int)buttonIndex
{
    CPLog.debug(@"TEST: %@", buttonIndex);
}


#pragma mark -
#pragma mark Delegate table users


- (int)numberOfRowsInTableView:(CPTableView)aTableView
{
    var result = 0;

    result = [_users count];

    return result;
}

/*! TableView delegate
*/
- (void)tableViewSelectionDidChange:(CPNotification)aNotification
{
//    CPLog.debug("TABLEVIEW: : tableViewSelectionDidChange aNotification: %@", );

/*
    var tableView = [aNotification object];
    if (_uniqueUserTable == tableView)
    {
        [self _uniqueUserSelectionChanged];
    }
    */
}


- (id)tableView:(id)aTableView objectValueForTableColumn:(CPTableColumn)aColumn row:(CPInteger)aRow
{
   // CPLog.debug("TABLEVIEW: : objectValueForTableColumn aRow: %@", aRow);


   var  user        = _users[aRow],
        name        = @"",
        identifier  = [aColumn identifier];

    switch (identifier)
    {
        case C_COLUMN_UID:
        {
            name = [user uid];
        }
        break;
        case C_COLUMN_USER_TYPE_ID:
        {
            name = [user userTypeId];
//            name = [user userTypeName];
        }
        break;
        case C_COLUMN_CLINIC_ID:
        {
            name = [user clinicId];
        }
        break;
        case C_COLUMN_EMAIL_ID:
        {
            name = [user email];
        }
        break;
        case C_COLUMN_FIRSTNAME_ID:
        {
            name = [user firstname];
        }
        break;
        case C_COLUMN_LASTNAME_ID:
        {
            name = [user lastname];
        }
        break;
        case C_COLUMN_PASSWORD_ID:
        {
            name = [user password];
        }
        break;
        case C_COLUMN_LAST_UPDATE_ID:
        {
            name = [user lastUpdate];
        }
        break;
        case C_COLUMN_VETUPGUID_ID:
        {
            name = [user vetupGuid];
        }
        break;
        case C_COLUMN_REGISTRATION_REFERRER_ID:
        {
            name = [user registrationReferrer];
        }
        break;
    }

   return name;
}


- (void)tableView:(CPTableView)aTableView sortDescriptorsDidChange:(CPArray)oldDescriptors
{
    var newDescriptors  = [aTableView sortDescriptors],
        currentObject   = [aTableView selectedRow];

    [_users sortUsingDescriptors:newDescriptors];

    [aTableView reloadData];
}


#pragma mark -
#pragma mark Edition des cellules de la table colorTable



#pragma mark -
#pragma mark WS Notification


- (void)_getVetupUsersNotification:(CPNotification)notification;
{
    CPLog.debug(@"_getVetupUsersNotification");

//    [[CPNotificationCenter defaultCenter] removeObserver:self name:WSGetReferenceDataNotification object:nil];

    var userInfo = [notification userInfo],
        error    = [userInfo objectForKey:ServicesErrorKey];

    [[AppController appDelegate] stopProgress];

    if (nil == error)
    {
        var job = [userInfo objectForKey:ServicesJobKey],
            request = [job request];

        var currentPage = [request currentPage],
            dataManager =  [DataManager sharedManager],
            nbUsers = [request loadedUsers];

        if (1 == currentPage)
        {
            //Première page, on initialise la table avec les premières données et on lance le chargement des suivante
            _totalUsers = [request totalUsers];
            _totalPages = ROUND((_totalUsers / _pageSize) + 0.5) ;
        }

        if (currentPage < _totalPages)
        {
            [[AppController appDelegate] startProgressWithText:@"Chargement des vetup users en cours, veuillez patienter..."];
            [[RequestManager sharedManager] performGetVetupUsers:_pageSize currentPage:currentPage + 1];
        }
        else
        {
            [[AppController appDelegate] stopProgressWithText:@""];
        }

        var percent = ROUND((currentPage * 100) / _totalPages);
        [self _displayProgress:percent];
        [self _updateNbLoadedUser:nbUsers];

        [self _refreshTableFromPredicate];
    }
    else
    {
        [[AppController appDelegate] stopProgressWithText:@"Le chargement des vetup users a échoué"];
        var errorMsg = @"Le chargement des vetup users a échoué";
        [[ErrorManager sharedManager] displayErrorMessage:errorMsg];
    }
}



@end



