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
    C_COLUMN_EMAIL_ID           = "email",
    C_COLUMN_NB_LINKED_USERS_ID = "nbLinkedUsers",
    C_COLUMN_FIRSTNAME_ID       = "firstname",
    C_COLUMN_LASTNAME_ID        = "lastname",
    C_COLUMN_PASSWORD_ID        = "password",
    C_COLUMN_CREATION_DATE_ID   = "creationDate",
    C_COLUMN_USER_TYPE_ID       = "userType",
//    C_COLUMN_CLINIC_DB_NAME_ID  = "dbClinicName";
    C_COLUMN_CLINIC_ID          = "clinicId";



//SELECT * FROM vetup_user where vetup_user.clinicId NOT IN (SELECT id from vetup_clinic)


@implementation ModuleUniqueUserController : CPObject
{
    @outlet CPView          _container;
    //Datasource pour la table categories
    @outlet CPTableView     _uniqueUserTable;
    @outlet CPTableView     _linkedUserTable;

    @outlet LPMultiLineTextField     _analyseTF;

     @outlet CPTextField      _nbUniqueUsers;

    //Data
    CPMutableArray          _uniqueUsers;
    CPMutableArray          _linkedUsers;
}


- (id)init
{
    return self;
}


- (void)awakeFromCib
{
    CPLog.debug(@">>>> Entering ModuleUniqueUserController::awakeFromCib");
    //DEBUG
    [_container setBackgroundColor:[CPColor whiteColor]];

    //Les data sont dispo ?
    /*
    var uniqueUsers = [[DataManager sharedManager] uniqueUsers];
    if (nil == uniqueUsers)
    {
        [self refreshDataFromServer];
    }
    else
    {
        _uniqueUsers = uniqueUsers;
        //self._colorsMap = [[DataManager sharedManager] colorsMap];
    }
    */

    //Delegate / data source pour le drag & drop
    [_uniqueUserTable setDataSource:self];
    [_uniqueUserTable setDelegate:self];
    [_uniqueUserTable setAllowsEmptySelection:YES];
    [_uniqueUserTable setAllowsMultipleSelection:YES];

    [_linkedUserTable setDataSource:self];
    [_linkedUserTable setDelegate:self];
    [_linkedUserTable setAllowsEmptySelection:YES];
    [_linkedUserTable setAllowsMultipleSelection:YES];

/*
C_COLUMN_ID                 = "id",
    C_COLUMN_EMAIL_ID           = "email",
    C_COLUMN_NB_LINKED_USERS_ID = "nbLinkedUsers",
    C_COLUMN_FIRSTNAME_ID       = "firstname",
    C_COLUMN_LASTNAME_ID        = "lastname",
    C_COLUMN_CLINIC_DB_NAME_ID  = "dbClinicName";

*/
    var idTableColumn = [_uniqueUserTable tableColumnWithIdentifier:C_COLUMN_UID];
    [idTableColumn setEditable:YES]; //permettre la sélection

    var emailTableColumn = [_uniqueUserTable tableColumnWithIdentifier:C_COLUMN_EMAIL_ID];
    [emailTableColumn setEditable:YES]; //permettre la sélection

    var nbLinkedUsersTableColumn = [_uniqueUserTable tableColumnWithIdentifier:C_COLUMN_NB_LINKED_USERS_ID];
    [nbLinkedUsersTableColumn setEditable:NO];

    var passwordTableColumn = [_uniqueUserTable tableColumnWithIdentifier:C_COLUMN_PASSWORD_ID];
    [passwordTableColumn setEditable:NO];

    var creationDateTableColumn = [_uniqueUserTable tableColumnWithIdentifier:C_COLUMN_CREATION_DATE_ID];
    [creationDateTableColumn setEditable:NO];


    //sorting
    var idSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"uid" ascending:YES];
    [idTableColumn setSortDescriptorPrototype:idSortDescriptor];

    var emailSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"email" ascending:YES];
    [emailTableColumn setSortDescriptorPrototype:emailSortDescriptor];

//    var occurenceSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:C_COLUMN_OCCURENCE_ID ascending:YES];
    var nbLinkedUsersSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"nbLinkedUsers" ascending:YES];
    [nbLinkedUsersTableColumn setSortDescriptorPrototype:nbLinkedUsersSortDescriptor];

    var passwordSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"password" ascending:YES];
    [passwordTableColumn setSortDescriptorPrototype:passwordSortDescriptor];

    var creationDateSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"creationDate" ascending:YES];
    [creationDateTableColumn setSortDescriptorPrototype:creationDateSortDescriptor];



    //LINKED USERS TABLE

    idTableColumn = [_linkedUserTable tableColumnWithIdentifier:C_COLUMN_UID];
    [idTableColumn setEditable:YES]; //permettre la sélection

    emailTableColumn = [_linkedUserTable tableColumnWithIdentifier:C_COLUMN_EMAIL_ID];
    [emailTableColumn setEditable:NO];

    var userTypeTableColumn = [_linkedUserTable tableColumnWithIdentifier:C_COLUMN_USER_TYPE_ID];
    [userTypeTableColumn setEditable:NO];

    var clinicTableColumn = [_linkedUserTable tableColumnWithIdentifier:C_COLUMN_CLINIC_ID];
    [clinicTableColumn setEditable:NO];

    //sorting
    emailSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"email" ascending:YES];
    [emailTableColumn setSortDescriptorPrototype:emailSortDescriptor];

    var clinicSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"clinicId" ascending:YES];
    [clinicTableColumn setSortDescriptorPrototype:clinicSortDescriptor];

    var typeSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"userType" ascending:YES];
    [userTypeTableColumn setSortDescriptorPrototype:typeSortDescriptor];

    idSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"uid" ascending:YES];
    [idTableColumn setSortDescriptorPrototype:idSortDescriptor];


    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_getCRVUniqueUsersNotification:)          name:WSGetCRVUniqueUsersNotification     object:nil];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_getCRVUsersNotification:)                name:WSGetCRVUsersNotification           object:nil];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_mergeUsersNotification:)                 name:WSMergeCRVUsersNotification           object:nil];


    CPLog.debug(@"<<<< Leaving ModuleUniqueUserController::awakeFromCib");
}



- (void)refreshDataFromServer
{
    [[AppController appDelegate] startProgressWithText:@"Chargement des utilisateurs unique CRV (table vetup_crv_user)..."];
    [[AppController appDelegate] startProgress];

    [[RequestManager sharedManager] performGetCRVUniqueUsers];
}


/*
- (void)refreshAnalyseFromServer
{
    [_analyseStatusLabel setStringValue:@"Analyse en cours..."];
    [[RequestManager sharedManager] performAnalyseReferenceData:KObjectTypeColor];
}
*/


- (void)refresh
{
    [_uniqueUserTable reloadData];
//    [_invalidEmailUserTable reloadData];
}

- (void)refreshLinkedUsers
{
    [_linkedUserTable reloadData];
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
#pragma mark IB Action

- (IBAction)refreshDataFromServerAction:(id)aSender
{
    [self refreshDataFromServer];
}


/*
- (IBAction)deleteBadEmailSelectionAction:(id)aSender
{
    var indexes     = [_invalidEmailUserTable selectedRowIndexes],
        objects     = [_invalidEmailUsers objectsAtIndexes:indexes];


    var emails = [CPArray new];

    for (var i = 0; i < [objects count]; i++)
    {
        var user    = [objects objectAtIndex:i];
        [emails addObject:[user email]];
    //  CPLog.debug(@"deleteBadEmailSelectionAction: %@", [user email]);
    }

    [[AppController appDelegate] startProgressWithText:@"Suppression des utilisateurs CRV..."];
    [[AppController appDelegate] startProgress];

    [[RequestManager sharedManager] performDeleteCRVUsers:emails];
}


- (IBAction)deleteInvalidClinicIdAction:(id)aSender
{
    [[AppController appDelegate] startProgressWithText:@"Suppression des utilisateurs CRV avec clinicId invalide..."];
    [[AppController appDelegate] startProgress];

    [[RequestManager sharedManager] performDeleteCRVUserWithInvalidClinicId];
}

- (IBAction)mergeEmailSelectionAction:(id)aSender
{
    var indexes     = [_emailUserTable selectedRowIndexes],
        objects     = [_emailUsers objectsAtIndexes:indexes];


    var emails = [CPArray new];

    for (var i = 0; i < [objects count]; i++)
    {
        var user    = [objects objectAtIndex:i];
        [emails addObject:[user email]];
    }

     CPLog.debug(@"ModuleColorDataListController::mergeEmailSelectionAction: %@", emails);

    [[RequestManager sharedManager] performMergeCRVUsers:emails];
}
*/

#pragma mark -
#pragma mark Private



- (void)_uniqueUserSelectionChanged
{
    var row = [_uniqueUserTable selectedRow];

    if (row >= 0) {
        var selectedUniqueUser  = [_uniqueUsers objectAtIndex:row];
        _linkedUsers = [selectedUniqueUser linkedUsers];
        [self refreshLinkedUsers];
    }

}




#pragma mark Alert View - suppression de la couleur

- (void)alertView:(CPAlert)alertView clickedButtonAtIndex:(int)buttonIndex
{
    CPLog.debug(@"TEST: %@", buttonIndex);
}


#pragma mark -
#pragma mark Delegate table colorTable


- (int)numberOfRowsInTableView:(CPTableView)aTableView
{
    var result = 0;

    if (aTableView == _linkedUserTable && _linkedUsers != nil)
        result = [_linkedUsers count];
    else if (aTableView == _uniqueUserTable && _uniqueUsers != nil)
        result = [_uniqueUsers count];

    return result;
}

/*! TableView delegate
*/
- (void)tableViewSelectionDidChange:(CPNotification)aNotification
{
//    CPLog.debug("TABLEVIEW: : tableViewSelectionDidChange aNotification: %@", );

    var tableView = [aNotification object];
    if (_uniqueUserTable == tableView)
    {
        [self _uniqueUserSelectionChanged];
    }
}


- (id)tableView:(id)aTableView objectValueForTableColumn:(CPTableColumn)aColumn row:(CPInteger)aRow
{
   // CPLog.debug("TABLEVIEW: : objectValueForTableColumn aRow: %@", aRow);


   var  user        = _uniqueUsers[aRow],
        name        = @"",
        identifier  = [aColumn identifier];


    if (aTableView == _linkedUserTable)
        user = _linkedUsers[aRow];

    switch(identifier)
    {
        case C_COLUMN_UID:
        {
            name = [user uid];
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
        case C_COLUMN_NB_LINKED_USERS_ID:
        {
            name = [user nbLinkedUsers];
        }
        break;
        case C_COLUMN_USER_TYPE_ID:
        {
            name = [user userType];
        }
        break;
        case C_COLUMN_PASSWORD_ID:
        {
            name = [user password];
        }
        break;
        case C_COLUMN_CREATION_DATE_ID:
        {
            name = [user creationDate];
        }
        break;

/*        case C_COLUMN_CLINIC_DB_NAME_ID:
        {
            name = [user dbName];
        }
        break;*/
        case C_COLUMN_CLINIC_ID:
        {
            name = [user clinicId];
        }
        break;
    }

   return name;
}


- (void)tableView:(CPTableView)aTableView sortDescriptorsDidChange:(CPArray)oldDescriptors
{
    var newDescriptors  = [aTableView sortDescriptors],
        currentObject   = [aTableView selectedRow];

    if (aTableView == _linkedUserTable)
        [_linkedUsers sortUsingDescriptors:newDescriptors];
    else
        [_uniqueUsers sortUsingDescriptors:newDescriptors];

    [aTableView reloadData];
}


#pragma mark -
#pragma mark Edition des cellules de la table colorTable



#pragma mark -
#pragma mark WS Notification



- (void)_getCRVUsersNotification:(CPNotification)notification;
{
    [self _getCRVUniqueUsersNotification:notification];
}

- (void)_mergeUsersNotification:(CPNotification)notification;
{
    [self _getCRVUniqueUsersNotification:notification];
}

- (void)_getCRVUniqueUsersNotification:(CPNotification)notification;
{
    CPLog.debug(@"_getCRVUniqueUsersNotification");

//    [[CPNotificationCenter defaultCenter] removeObserver:self name:WSGetReferenceDataNotification object:nil];

    var userInfo = [notification userInfo],
        error    = [userInfo objectForKey:ServicesErrorKey];

    [[AppController appDelegate] stopProgress];

    if (nil == error)
    {

        var uniqueUsers = [[DataManager sharedManager] uniqueUsers];
        _uniqueUsers    = uniqueUsers;

        [_nbUniqueUsers setStringValue:[_uniqueUsers count]];


        [_uniqueUserTable deselectAll];
        _linkedUsers = nil;

        [self refresh];
        [self refreshLinkedUsers];
    }
    else
    {
        [[AppController appDelegate] stopProgressWithText:@"Le chargement des utilisateurs CRV unique a échoué"];
        var errorMsg = @"Le chargement des utilisateurs CRV unique a échoué";
        [[ErrorManager sharedManager] displayErrorMessage:errorMsg];
    }
}



@end



