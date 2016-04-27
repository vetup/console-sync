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

    [_predicateEditor setDelegate:self];
    [_predicateEditor setBackgroundColor:[CPColor whiteColor]];
    [_predicateEditor setCanRemoveAllRows:YES];

    //SIPredicateStringValueTransformer *transformer = [[[SIPredicateStringValueTransformer alloc] init] autorelease];
    //var bindingOptions = [CPMutableDictionary dictionaryWithObjectsAndKeys:transformer, NSValueTransformerBindingOption, [NSNumber numberWithBool:YES], NSValidatesImmediatelyBindingOption, nil];
//    [predicateEditor bind:@"value" toObject:self withKeyPath:@"self.bindedPredicateEditorValue" options:bindingOptions];
    [_predicateEditor bind:@"value" toObject:self withKeyPath:@"self.bindedPredicateEditorValue" options:nil];



    //observe les changements de la propriété bindedPredicateEditorValue bindée sur le objectValue du CPPredicateEditor
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
        var filterDescription = [bindedPredicateEditorValue description];
        [_criterasLabelTF setStringValue:filterDescription];

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



