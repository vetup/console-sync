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

var C_COLUMN_EMAIL_ID           = "email",
    C_COLUMN_OCCURENCE_ID       = "nbOccurence",
    C_COLUMN_USER_TYPE_ID       = "userType",
    C_COLUMN_IS_MERGED_ID       = "isMerged",
    C_COLUMN_CLINIC_DB_NAME_ID  = "dbClinicName";



//SELECT * FROM vetup_user where vetup_user.clinicId NOT IN (SELECT id from vetup_clinic)


@implementation ModuleCleanUserController : CPObject
{
    @outlet CPView          _container;
    //Datasource pour la table categories
    @outlet CPTableView     _emailUserTable;
    @outlet CPTableView     _invalidEmailUserTable;

//    @outlet CPView          _buttonBarContainer;

    @outlet CPTextField      _totalNbEmailUsers;
    @outlet CPTextField      _totalNbInvalidEmailUsers;
    @outlet CPTextField      _totalNbMergedlUsers;
    //@outlet EDSVGIcon      _con;
    @outlet CPTextField      _nbInvalidClinicId;


    @outlet LPMultiLineTextField     _analyseTF;

    //Data
    CPMutableArray          _emailUsers;
    CPMutableArray          _invalidEmailUsers;
}


- (id)init
{
    return self;
}


- (void)awakeFromCib
{
    CPLog.debug(@">>>> Entering ModuleCleanUserController::awakeFromCib");
    //DEBUG
    [_container setBackgroundColor:[CPColor whiteColor]];

    //Les data sont dispo ?
    var emailUsers = [[DataManager sharedManager] emailUsers];
    if (nil == emailUsers)
    {
        [self refreshDataFromServer];
    }
    else
    {
        _emailUsers = emailUsers;
        //self._colorsMap = [[DataManager sharedManager] colorsMap];
    }

    //Delegate / data source pour le drag & drop
    [_emailUserTable setDataSource:self];
    [_emailUserTable setDelegate:self];
    [_emailUserTable setAllowsEmptySelection:YES];
    [_emailUserTable setAllowsMultipleSelection:YES];

    [_invalidEmailUserTable setDataSource:self];
    [_invalidEmailUserTable setDelegate:self];
    [_invalidEmailUserTable setAllowsEmptySelection:YES];
    [_invalidEmailUserTable setAllowsMultipleSelection:YES];

    var emailTableColumn = [_emailUserTable tableColumnWithIdentifier:C_COLUMN_EMAIL_ID];
   [emailTableColumn setEditable:YES]; //permettre la sélection

    var occurenceTableColumn = [_emailUserTable tableColumnWithIdentifier:C_COLUMN_OCCURENCE_ID];
    [occurenceTableColumn setEditable:NO];

    var userTypeTableColumn = [_emailUserTable tableColumnWithIdentifier:C_COLUMN_USER_TYPE_ID];
    [userTypeTableColumn setEditable:NO];

    var isMergedTableColumn = [_emailUserTable tableColumnWithIdentifier:C_COLUMN_IS_MERGED_ID];
    [isMergedTableColumn setEditable:NO];

    var clinicTableColumn = [_emailUserTable tableColumnWithIdentifier:C_COLUMN_CLINIC_DB_NAME_ID];
    [clinicTableColumn setEditable:NO];

    //sorting
    var emailSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"email" ascending:YES];
    [emailTableColumn setSortDescriptorPrototype:emailSortDescriptor];

//    var occurenceSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:C_COLUMN_OCCURENCE_ID ascending:YES];
    var occurenceSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"nbOccurence" ascending:YES];
    [occurenceTableColumn setSortDescriptorPrototype:occurenceSortDescriptor];

    var isMergedSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"isMerged" ascending:YES];
    [isMergedTableColumn setSortDescriptorPrototype:isMergedSortDescriptor];

    var clinicSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"dbName" ascending:YES];
    [clinicTableColumn setSortDescriptorPrototype:clinicSortDescriptor];

    //invalid email table
    emailTableColumn = [_invalidEmailUserTable tableColumnWithIdentifier:C_COLUMN_EMAIL_ID];
    [emailTableColumn setEditable:NO];

    occurenceTableColumn = [_invalidEmailUserTable tableColumnWithIdentifier:C_COLUMN_OCCURENCE_ID];
    [occurenceTableColumn setEditable:NO];

    userTypeTableColumn = [_invalidEmailUserTable tableColumnWithIdentifier:C_COLUMN_USER_TYPE_ID];
    [userTypeTableColumn setEditable:NO];

    var clinicTableColumn = [_invalidEmailUserTable tableColumnWithIdentifier:C_COLUMN_CLINIC_DB_NAME_ID];
    [clinicTableColumn setEditable:NO];

    //sorting
    var emailSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"email" ascending:YES];
    [emailTableColumn setSortDescriptorPrototype:emailSortDescriptor];

//    var occurenceSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:C_COLUMN_OCCURENCE_ID ascending:YES];
    var occurenceSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"nbOccurence" ascending:YES];
    [occurenceTableColumn setSortDescriptorPrototype:occurenceSortDescriptor];

    var clinicSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"dbName" ascending:YES];
    [clinicTableColumn setSortDescriptorPrototype:clinicSortDescriptor];

    var typeSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:"userType" ascending:YES];
    [userTypeTableColumn setSortDescriptorPrototype:typeSortDescriptor];


//selector:@selector(localizedStandardCompare:)

  /*
    var emailSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:C_COLUMN_EMAIL_ID ascending:YES];

    [emailTableColumn setSortDescriptorPrototype:emailSortDescriptor];
    var emailSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:C_COLUMN_EMAIL_ID ascending:YES];
    [emailTableColumn setSortDescriptorPrototype:emailSortDescriptor];
*/


/*
var C_COLUMN_EMAIL_ID           = "email";
var C_COLUMN_OCCURENCE_ID       = "nbOccurence";
var C_COLUMN_USER_TYPE_ID       = "userType";
var C_COLUMN_CLINIC_DB_NAME_ID  = "dbClinicName";
*/

/*
//[cancelButton setAutoresizingMask:CPViewMinXMargin | CPViewMinYMargin];
   // [_colorTable setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable | CPViewMinXMargin | CPViewMinYMargin];
  //[_colorTable setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];


    //Delegate / data source pour le drag & drop
    [_colorTable setDataSource:self];
    [_colorTable setDelegate:self];
    [_colorTable setAllowsEmptySelection:NO];

    var nameTableColumn = [_colorTable tableColumnWithIdentifier:@"name"];
    [nameTableColumn setEditable:YES];

    var nameSortDescriptor = [CPSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [nameTableColumn setSortDescriptorPrototype:nameSortDescriptor];


    //Add button bar
    [self _addButtonBar];

    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_getReferenceColorListNotification:)          name:WSGetColorsReferenceDataNotification           object:nil];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_updateReferenceColorListNotification:)       name:WSUpdateColorReferenceDataNotification         object:nil];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_addReferenceColorListNotification:)          name:WSAddColorReferenceDataNotification            object:nil];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_deleteReferenceColorListNotification:)       name:WSDeleteColorReferenceDataNotification         object:nil];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_analyseReferenceColorListNotification:)      name:WSAnalyseColorsReferenceDataNotification       object:nil];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_synchronizeReferenceColorListNotification:)  name:WSSynchronizeColorsReferenceDataNotification   object:nil];




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
    */

    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_getCRVUsersNotification:)          name:WSGetCRVUsersNotification           object:nil];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_deleteUsersNotification:)       name:WSDeleteCRVUsersNotification           object:nil];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_deleteUsersWithInvalidClinicIdNotification:)       name:WSDeleteCRVUserWithInvalidClinicIdNotification           object:nil];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_mergeUsersNotification:)       name:WSMergeCRVUsersNotification           object:nil];



    CPLog.debug(@"<<<< Leaving ModuleColorDataListController::awakeFromCib");
}



- (void)refreshDataFromServer
{
    [[AppController appDelegate] startProgressWithText:@"Chargement des utilisateurs CRV..."];
    [[AppController appDelegate] startProgress];

    [[RequestManager sharedManager] performGetCRVUsers];
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
    [_emailUserTable reloadData];
    [_invalidEmailUserTable reloadData];


    [_totalNbMergedlUsers setStringValue:[[DataManager sharedManager] nbMergedUser]];
}


#pragma mark Delegate EDSVGIcon click

- (void)onClickIcon:(id)sender
{
    [self refreshDataFromServer];
}


//----o PUBLIC
#pragma mark -
#pragma mark Action

/*
- (IBAction)save:(id)sender
{
    CPLog.info(@">>>> ModuleArticleCategoryTabController Entering save");

    if ([self _isValidCategories])
    {
        var targetId = [[UserManager sharedManager] currentTarget];
        var target = [[TargetManager sharedManager] targetWithId:targetId];
        var moduleArticle = [target moduleArticle];
        var categories = [moduleArticle categories];

        var categoriesJS = [categories toJSObject]; //Utilisation de la catégory Obj-C "CPArray_CPJSONAware.j"
        var jsonStr = [CPString JSONFromObject:categoriesJS];

        [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_setArticleModuleParamNotification:) name:WSSetArticleModuleParamNotification object:nil];
        [[RequestManager sharedManager] performSetArticleParam:KParamCategory value:jsonStr];

        [[AppController appDelegate] startProgress];
    }
    else
    {
         [[ErrorManager sharedManager] displayErrorMessage:@"Catégories invalides, véfiriez que les valeurs soient correctes"];
    }


    CPLog.info(@"<<<< ModuleArticleCategoryTabController Leaving");
}
*/



#pragma mark -
#pragma mark IB Action

- (IBAction)refreshDataFromServerAction:(id)aSender
{
    [self refreshDataFromServer];
}


- (IBAction)deleteBadEmailSelectionAction:(id)aSender
{
    var indexes     = [_invalidEmailUserTable selectedRowIndexes],
        objects     = [_invalidEmailUsers objectsAtIndexes:indexes];



    if ([objects count] > 0)
    {
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
    else
    {
        [[ErrorManager sharedManager] displayErrorMessage:@"Vous devez sélectionner les utilisateurs à supprimer"];
    }
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


    if ([objects count] > 0)
    {
        var emails = [CPArray new];

        for (var i = 0; i < [objects count]; i++)
        {
            var user        = [objects objectAtIndex:i],
                isMerged    = [user isMerged];

/*
            if ([isMerged isEqualToString:@"YES"])
            {
                [[ErrorManager sharedManager] displayErrorMessage:@"Le sélection ne doit contenir que des utilisateurs par encore mergé"];
                return;
            }
            */

            [emails addObject:[user email]];
        }
        [[AppController appDelegate] startProgressWithText:@"Merge des utilisateurs CRV..."];
        [[AppController appDelegate] startProgress];

        [[RequestManager sharedManager] performMergeCRVUsers:emails];
    }
    else
    {
        [[ErrorManager sharedManager] displayErrorMessage:@"Vous devez sélectionner les utilisateurs à merger dans la table vetup_crv_users"];
    }


     CPLog.debug(@"ModuleCleanUserController::mergeEmailSelectionAction: %@", emails);
}


/*
- (IBAction)clearSynchronizationTFAction:(id)aSender
{
//    CPLog.debug(@"ModuleColorDataListController::clearSynchronizationTFAction: %@", aSender);
    [_synchronizationTF setStringValue:@""];
}

- (IBAction)clearAnalyseTFAction:(id)aSender
{
//    CPLog.debug(@"ModuleColorDataListController::clearSynchronizationTFAction: %@", aSender);
    [_analyseTF setStringValue:@""];
}

- (IBAction)analyseColorsAction:(id)aSender
{
    [self refreshAnalyseFromServer];
}


- (IBAction)synchronizeColorsAction:(id)aSender
{
    [_synchronizationStatusLabel setStringValue:@"Synchronisation en cours..."];
    [[RequestManager sharedManager] performSynchronizeReferenceData:KObjectTypeColor];
}
*/


#pragma mark -
#pragma mark Private




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

    if (aTableView == _invalidEmailUserTable && _invalidEmailUsers != nil)
        result = [_invalidEmailUsers count];
    else if (aTableView == _emailUserTable && _emailUsers != nil)
        result = [_emailUsers count];

    return result;
}

- (id)tableView:(id)aTableView objectValueForTableColumn:(CPTableColumn)aColumn row:(CPInteger)aRow
{
   // CPLog.debug("TABLEVIEW: : objectValueForTableColumn aRow: %@", aRow);


   var  user   = _emailUsers[aRow],
        name        = @"",
        identifier  = [aColumn identifier];


    if (aTableView == _invalidEmailUserTable)
        user = _invalidEmailUsers[aRow];

    switch(identifier)
    {
        case C_COLUMN_EMAIL_ID:
        {
            name = [user email];
        }
        break;
        case C_COLUMN_OCCURENCE_ID:
        {
            name = [user nbOccurence];
        }
        break;
        case C_COLUMN_USER_TYPE_ID:
        {
            name = [user userType];
        }
        break;

        case C_COLUMN_CLINIC_DB_NAME_ID:
        {
            name = [user dbName];
        }
        break;
        case C_COLUMN_IS_MERGED_ID:
        {
            name = [user isMerged];
        }
        break;
    }

   return name;
}



- (void)tableView:(CPTableView)aTableView sortDescriptorsDidChange:(CPArray)oldDescriptors
{

    var newDescriptors  = [aTableView sortDescriptors],
        currentObject   = [aTableView selectedRow];

    if (aTableView == _invalidEmailUserTable)
        [_invalidEmailUsers sortUsingDescriptors:newDescriptors];
    else
        [_emailUsers sortUsingDescriptors:newDescriptors];


    [aTableView reloadData];

/*
    [_fullArray sortUsingDescriptors:newDescriptors];


    if (_filteredArray != nil)
    {
        [_filteredArray sortUsingDescriptors:newDescriptors];
    }

    [aTableView reloadData];

    var newIndex = [_fullArray indexOfObject:currentObject];
    if (newIndex >= 0)
        [aTableView selectRowIndexes:[CPIndexSet indexSetWithIndex:newIndex] byExtendingSelection:NO];
    */
}


#pragma mark -
#pragma mark Edition des cellules de la table colorTable


- (void)tableView:(CPTableView)aTableView setObjectValue:(id)aValue forTableColumn:(CPTableColumn)tableColumn row:(CPInteger)aRow
{
 //   CPLog.debug(@"ModuleArticleCategoryTabController::setObjectValue: row: %d   value: %@", aRow, aValue);

/*
    var value = [aValue stringByTrimmingWhitespace];

    if (_newItemBeingAdded != nil)
    {
        if ([value isEqualToString:@""])
        {
            [_colors removeObject:_newItemBeingAdded];
        }
        else
        {
            //TODO: checker si une couleur du même nom existe déjà, pour éviter les doublons
            if (![self _isColorExist:value])
            {
                [_newItemBeingAdded setUid:0];
                [_newItemBeingAdded setName:value];

                [[AppController appDelegate] startProgressWithText:@"Ajout en cours..."];
                [[AppController appDelegate] startProgress];

                [[RequestManager sharedManager] performAddReferenceData:_newItemBeingAdded];
            }
            else
            {
                [_colors removeObject:_newItemBeingAdded];
                var errorMsg = @"Une couleur avec le même nom existe déjà";
                [[ErrorManager sharedManager] displayErrorMessage:errorMsg];
            }

        }
        _newItemBeingAdded = nil;
    }
    else
    {
        var color       = _colors[aRow];
        if (![value isEqualToString:@""] && ![[color name] isEqual:value])
        {
            var  colorUpdate = [[ColorUpdate alloc] initWithColor:color];

            [color setName:value];
            [colorUpdate setName:value];

            [[AppController appDelegate] startProgressWithText:@"Modification en cours..."];
            [[AppController appDelegate] startProgress];


//          [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_updateReferenceColorListNotification:) name:WSUpdateReferenceDataNotification object:nil];
            [[RequestManager sharedManager] performUpdateReferenceData:colorUpdate];
        }
    }
    */
}

#pragma mark -
#pragma mark WS Notification

- (void)_getCRVUsersNotification:(CPNotification)notification;
{
    CPLog.debug(@"_getCRVUsersNotification");

//    [[CPNotificationCenter defaultCenter] removeObserver:self name:WSGetReferenceDataNotification object:nil];

    var userInfo = [notification userInfo],
        error    = [userInfo objectForKey:ServicesErrorKey];

    [[AppController appDelegate] stopProgress];

    if (nil == error)
    {

        [[AppController appDelegate] stopProgressWithText:@"CRV Users chargées"];

        var emailUsers          = [[DataManager sharedManager] emailUsers],
            invalidEmailUsers   = [[DataManager sharedManager] invalidEmailUsers];

        _emailUsers             = emailUsers;
        _invalidEmailUsers      = invalidEmailUsers;

        [_totalNbEmailUsers setStringValue:[_emailUsers count]];

        if (_invalidEmailUsers != nil)
            [_totalNbInvalidEmailUsers setStringValue:[_invalidEmailUsers count]];


        var job                 = [userInfo objectForKey:ServicesJobKey],
            request             = [job request],
            userStat            = [request userStat],
            nbInvalidClinicId  = [request nbInvalidClinicId];

        [_analyseTF setStringValue:userStat];
        [_nbInvalidClinicId setStringValue:nbInvalidClinicId];

        [self refresh];
    }
    else
    {
        [[AppController appDelegate] stopProgressWithText:@"Le chargement des utilisateurs CRV a échoué"];
        var errorMsg = @"Le chargement des utilisateurs CRV a échoué";
        [[ErrorManager sharedManager] displayErrorMessage:errorMsg];
    }
}

- (void)_deleteUsersNotification:(CPNotification)notification;
{
    CPLog.debug(@"_getDeleteUsersNotification");


    var userInfo = [notification userInfo],
        error    = [userInfo objectForKey:ServicesErrorKey];

    [[AppController appDelegate] stopProgress];

    if (nil == error)
    {

        [[AppController appDelegate] stopProgressWithText:@"CRV Users supprimés"];

        var emailUsers          = [[DataManager sharedManager] emailUsers],
            invalidEmailUsers   = [[DataManager sharedManager] invalidEmailUsers];

        _emailUsers             = emailUsers;
        _invalidEmailUsers      = invalidEmailUsers;

        [_totalNbEmailUsers setStringValue:[_emailUsers count]];

        if (_invalidEmailUsers != nil)
            [_totalNbInvalidEmailUsers setStringValue:[_invalidEmailUsers count]];

        [_invalidEmailUserTable deselectAll];

        [self refresh];
    }
    else
    {
        [[AppController appDelegate] stopProgressWithText:@"La suppression des utilisateurs CRV a échoué"];
        var errorMsg = @"La suppression des utilisateurs CRV a échoué";
        [[ErrorManager sharedManager] displayErrorMessage:errorMsg];
    }
}

- (void)_deleteUsersWithInvalidClinicIdNotification:(CPNotification)notification;
{
    CPLog.debug(@"_getDeleteUsersWithInvalidClinicIdNotification");


    var userInfo = [notification userInfo],
        error    = [userInfo objectForKey:ServicesErrorKey];

    [[AppController appDelegate] stopProgress];

    if (nil == error)
    {

        [[AppController appDelegate] stopProgressWithText:@"CRV Users supprimés"];

        var emailUsers          = [[DataManager sharedManager] emailUsers],
            invalidEmailUsers   = [[DataManager sharedManager] invalidEmailUsers];

        _emailUsers             = emailUsers;
        _invalidEmailUsers      = invalidEmailUsers;

        [_totalNbEmailUsers setStringValue:[_emailUsers count]];

        if (_invalidEmailUsers != nil)
            [_totalNbInvalidEmailUsers setStringValue:[_invalidEmailUsers count]];

        [_invalidEmailUserTable deselectAll];


        var job                 = [userInfo objectForKey:ServicesJobKey],
            request             = [job request],
            userStat            = [request userStat],
            nbInvalidClinicId  = [request nbInvalidClinicId];

        [_analyseTF setStringValue:userStat];
        [_nbInvalidClinicId setStringValue:nbInvalidClinicId];


        [self refresh];
    }
    else
    {
        [[AppController appDelegate] stopProgressWithText:@"La suppression des utilisateurs CRV a échoué"];
        var errorMsg = @"La suppression des utilisateurs CRV a échoué";
        [[ErrorManager sharedManager] displayErrorMessage:errorMsg];
    }
}

- (void)_mergeUsersNotification:(CPNotification)notification;
{
    CPLog.debug(@"_mergeUsersNotification");


    var userInfo = [notification userInfo],
        error    = [userInfo objectForKey:ServicesErrorKey];

    [[AppController appDelegate] stopProgress];

    if (nil == error)
    {

        [[AppController appDelegate] stopProgressWithText:@"Merge des CRV Users sélectionnés effectués"];

        var emailUsers          = [[DataManager sharedManager] emailUsers],
            invalidEmailUsers   = [[DataManager sharedManager] invalidEmailUsers];

        _emailUsers             = emailUsers;
        _invalidEmailUsers      = invalidEmailUsers;

        [_totalNbEmailUsers setStringValue:[_emailUsers count]];

        if (_invalidEmailUsers != nil)
            [_totalNbInvalidEmailUsers setStringValue:[_invalidEmailUsers count]];

        [_invalidEmailUserTable deselectAll];
        [_emailUserTable deselectAll];

        [self refresh];
    }
    else
    {
        [[AppController appDelegate] stopProgressWithText:@"Le merge des utilisateurs CRV a échoué"];
        var errorMsg = @"Le merge des utilisateurs CRV a échoué";
        [[ErrorManager sharedManager] displayErrorMessage:errorMsg];
    }
}

//        [[AppController appDelegate] stopProgressWithText:@"CRV Users chargées"];



@end



