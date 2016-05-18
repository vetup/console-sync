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
    @outlet CPButton            _loadingButton;

    @outlet CPTextField _progressLoadingTF;
    @outlet CPTextField _totalUsersTF;
    @outlet CPTextField _criterasLabelTF;
    @outlet CPTextField _tableCountTF;
    @outlet CPTextField _actionTF;

    @outlet LPMultiLineTextField     _analyseTF;

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
//    [_container setBackgroundColor:[CPColor greenColor]];

    //1- créer la scroll view
    var frame = [_container frame];
    frame.size.height -= 20; //place pour la scrollbar
    frame.size.width -= 20; //place pour la scrollbar
    var scrollView = [[CPScrollView alloc] initWithFrame:frame];
    [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
 //   [scrollView setBackgroundColor:[CPColor redColor]];
    [scrollView setHasHorizontalScroller:true];
    [scrollView setHasVerticalScroller:true];

    //2- transférer les subview du container vers une nouvelle vue, en calculant la taille du nouveau container
//     var documentSubView = [[CPView alloc] initWithFrame:CGRectMake(0,0,5000,600)],
     var documentSubView = [[CPView alloc] initWithFrame:[_container frame]],
//     var documentSubView = [CPView new],
         containerSubviews = [_container subviews];

    var height = 0,
        width = 0;

    for (var i = 0; i < [containerSubviews count]; i++)
    {
        var subView = containerSubviews[i],
            frame = [subView frame];

        var newHeight = frame.size.height + frame.origin.y;
        height = MAX(height, newHeight);

        var newWidth = frame.size.width + frame.origin.x;
        width = MAX(width, newWidth);

        [documentSubView addSubview:subView];
    }

    [documentSubView setFrame:CGRectMake(0 ,0, width + 40, 600)];

    //3 - Ajouter la scrollview au container
    [_container addSubview:scrollView];

    //4 - positionner le documentView
    [scrollView setDocumentView:documentSubView];
/*
    var superview = [_container superview];
    [scrollView setBackgroundColor:[CPColor redColor]];
    [superview addSubView:scrollView];
    */

//    [_container setHasHorizontalScroller:true];
//    [_container setHasHorizontalScroller:false];

//[_scrollview setDocumentView:_tableview];

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
    [vetupGuidTableColumn setEditable:YES];

    var registrationReferrerTableColumn = [_userTable tableColumnWithIdentifier:C_COLUMN_REGISTRATION_REFERRER_ID];
    [registrationReferrerTableColumn setEditable:YES];


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
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_infoVetupUsersNotification:)  name:WSInfoVetupUserNotification   object:nil];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_deleteVetupUsersNotification:)  name:WSDeleteVetupUserNotification   object:nil];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_updateVetupUserNotification:)  name:WSUpdateVetupUserNotification   object:nil];


    //10000 user par requête
    _pageSize = 10000;
    _totalPages = 0;
    _nbLoadedUser = 0;

    [_totalUsersTF setEditable:NO];
    [_progressLoadingTF setEditable:NO];

    [_tableCountTF setEditable:NO];
    [_tableCountTF setStringValue:@"0"];
    [_actionTF setStringValue:@""];

//    [_criterasLabelTF setEditable:YES];
    [_criterasLabelTF setSelectable:YES];
    [_criterasLabelTF setEditable:YES];

    //analyse Multiline textfield
    [_analyseTF setEditable:NO];
    [_analyseTF setEnabled:YES];
    [_analyseTF setScrollable:YES];

    CPLog.debug(@"<<<< Leaving ModuleAnalyseUserController::awakeFromCib");
}



- (void)refreshDataFromServer
{
    _currentPage = 1;
    _nbLoadedUser = 0;
    _totalUsers = 0;

    [self _displayProgress:0];
    [self _updateNbLoadedUser:0];


    [_loadingButton setTitle:@"Loading..."];

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
//        [self _refreshFilteredData];

        var filterDescription = [bindedPredicateEditorValue description],
            currentFilter =  [_criterasLabelTF stringValue];

        if (![currentFilter isEqualToString:filterDescription])
        {
            [_criterasLabelTF setStringValue:filterDescription];
            CPLog.debug(@" PREDICATE: %@", filterDescription);
            [self _refreshTableFromPredicate];
        }

    }
}

#pragma mark -
#pragma mark Delegate predicate

- (void)ruleEditorRowsDidChange:(CPNotification)notification
{
    CPLog.debug(@" ruleEditorRowsDidChange :  %@", [_predicateEditor objectValue]);
}


- (void)print:(id)sender
{
    CPLog.debug(@" print");

}


#pragma mark -
#pragma mark IB Action

- (IBAction)clear:(id)aSender
{
    [_analyseTF setStringValue:@""];
}


- (IBAction)refreshDataFromServerAction:(id)aSender
{
    [self refreshDataFromServer];
}

- (IBAction)getInfoAction:(id)aSender
{
//    CPLog.debug(@" ---testMultiselection");

    var indexes = [_userTable selectedRowIndexes],
        objects = [_users objectsAtIndexes:indexes];

    if ([objects count] > 0)
    {
        var ids = [CPArray new];

        for (var i = 0; i < [objects count]; i++)
        {
            var user = [objects objectAtIndex:i],
            //var idStr = [CPString stringWithFormat:"%d", [user uid]];
                idStr = [[user uid] stringValue];
            [ids addObject:idStr];

           // CPLog.debug(@" ----- testMultiselection: %@", [user email]);
        }


        [[AppController appDelegate] startProgressWithText:@"obtention des infos vetup_users..."];
//        [[AppController appDelegate] startProgress];

        [_actionTF setStringValue:@"Fetching data..."];

        [[RequestManager sharedManager] performInfoVetupUsers:ids];
    }
    else
    {
        [[ErrorManager sharedManager] displayErrorMessage:@"Vous devez sélectionner les utilisateurs dans la table"];
    }
}


- (IBAction)deleteAction:(id)aSender
{
    var indexes = [_userTable selectedRowIndexes],
        objects = [_users objectsAtIndexes:indexes];

    if ([objects count] > 0)
    {
        var ids = [CPArray new];

        for (var i = 0; i < [objects count]; i++)
        {
            var user = [objects objectAtIndex:i],
                idStr = [[user uid] stringValue];
            [ids addObject:idStr];
        }

        [[AppController appDelegate] startProgressWithText:@"suppression des vetup_users..."];
        [_actionTF setStringValue:@"Deleting data..."];

        [[RequestManager sharedManager] performDeleteVetupUsers:ids];
    }
    else
    {
        [[ErrorManager sharedManager] displayErrorMessage:@"Vous devez sélectionner les utilisateurs dans la table"];
    }
}

- (IBAction)setPattern1Action:(id)aSender
{
    var predicateFormat = @"clinicId == 0 AND vetupGuid != \"null\"",
        predicate = [CPPredicate predicateWithFormat:predicateFormat];

    [_predicateEditor setObjectValue:predicate];
    [_predicateEditor reloadPredicate];
}


- (IBAction)setPattern2Action:(id)aSender
{
    var predicateFormat = @"vetupGuid == \"null\" AND clinicId != 0 AND registrationReferrer == \"Import\"",
        predicate = [CPPredicate predicateWithFormat:predicateFormat];

    [_predicateEditor setObjectValue:predicate];
    [_predicateEditor reloadPredicate];
}

//

#pragma mark -
#pragma mark Private


/*
- (void)_refreshFilteredData
{
    var filterDescription = [bindedPredicateEditorValue description];
    [_criterasLabelTF setStringValue:filterDescription];

    CPLog.debug(@" PREDICATE: %@", filterDescription);
    [self _refreshTableFromPredicate];
}
*/

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
        filteredArray = [allUsers filteredArrayUsingPredicate:self.bindedPredicateEditorValue];

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
#pragma mark Edition des cellules de la table vetup_user


- (void)tableView:(CPTableView)aTableView setObjectValue:(id)aValue forTableColumn:(CPTableColumn)aColumn row:(CPInteger)aRow
{
 //   CPLog.debug(@"ModuleArticleCategoryTabController::setObjectValue: row: %d   value: %@", aRow, aValue);
    var value = [aValue stringByTrimmingWhitespace],
        user = _users[aRow],
        identifier = [aColumn identifier],
        currentValue = @"",
        property = @"",
        currentUser = [[VetupUser alloc] initWithVetupUser:user];

    if (![value isEqualToString:@""])
    {
        switch (identifier)
        {
            case C_COLUMN_FIRSTNAME_ID:             { currentValue = [user firstname]; property = @"firstname"; [user setFirstname:value]; } break;
            case C_COLUMN_LASTNAME_ID:              { currentValue = [user lastname]; property = @"lastname"; [user setLastname:value];} break;
            case C_COLUMN_PASSWORD_ID:              { currentValue = [user password]; property = @"password"; [user setPassword:value];} break;
            case C_COLUMN_VETUPGUID_ID:             { currentValue = [user vetupGuid]; property = @"vetupGuid"; [user setVetupGuid:value];} break;
            case C_COLUMN_REGISTRATION_REFERRER_ID: { currentValue = [user registrationReferrer]; property = @"registrationReferrer"; [user setRegistrationReferrer:value];} break;
        }

        var isValueChanged = (![property isEqualToString:@""] && ![currentValue isEqual:value]),
            isUpdateAllowed = true;

        if (isValueChanged & [property isEqualToString:@"vetupGuid"])
        {
//      [value intValue] renvoie 0 si ce n'est pas un entier (ca suffit pour notre besoin, même si 0 est un entier)

            var isValidVetupGuidValue = ( ([value intValue] != 0) && ([value length] == 19) || [value isEqualToString:@"null"]);
            if (0 == isValidVetupGuidValue)
            {
                isUpdateAllowed = false;
                [user setVetupGuid:[currentUser vetupGuid]]; //On remet l'ancienne valeur
                [[ErrorManager sharedManager] displayErrorMessage:@"vetupGuid doit être un entier de 19 chiffres ou null"];
            }
        }

        if (isUpdateAllowed && isValueChanged)
        {
            var dict =  @{property: value},  //dictionnaire literal
                message = [CPString stringWithFormat:@"Updating user [%d]...", [user uid]];

            [_actionTF setStringValue:message];

            [[AppController appDelegate] startProgressWithText:@"Modification du user en cours..."];
            //[[AppController appDelegate] startProgress];
            [[RequestManager sharedManager] performUpdateVetupUser:dict user:currentUser];

//            [self _refreshTableFromPredicate];
            [self refresh];
        }
    }
}



#pragma mark -
#pragma mark WS Notification

- (void)_deleteVetupUsersNotification:(CPNotification)notification;
{
    CPLog.debug(@"_deleteVetupUsersNotification");

    var userInfo = [notification userInfo],
        error    = [userInfo objectForKey:ServicesErrorKey];

    [[AppController appDelegate] stopProgress];

    [_actionTF setStringValue:@""];
    [[AppController appDelegate] stopProgressWithText:@""];

    if (nil == error)
    {
        var job = [userInfo objectForKey:ServicesJobKey],
            request = [job request],
            allUsers = [[DataManager sharedManager] vetupUsers],
            info = [request info],
            indexes = [_userTable selectedRowIndexes],
            objects = [_users objectsAtIndexes:indexes],
            message = @"ids: ";

        for (var i = 0; i < [objects count]; i++)
        {
            var user = [objects objectAtIndex:i];
            message = [CPString stringWithFormat:@"%@ %@", message, [user uid]];
            [allUsers removeObject:user];
        }

        [self _refreshTableFromPredicate];

        var text = [CPString stringWithFormat:@"%@\nvetup_user supprimés correctement: %@", [_analyseTF stringValue], message];
        [_analyseTF setStringValue:text];

        [_userTable deselectAll];
    }
    else
    {
        var errorMsg = @"La suppression des vetup users a échoué";
        [[AppController appDelegate] stopProgressWithText:errorMsg];
        [[ErrorManager sharedManager] displayErrorMessage:errorMsg];
    }
}


- (void)_infoVetupUsersNotification:(CPNotification)notification;
{
    CPLog.debug(@"_infoVetupUsersNotification");

    var userInfo = [notification userInfo],
        error    = [userInfo objectForKey:ServicesErrorKey];

    [[AppController appDelegate] stopProgress];

    [_actionTF setStringValue:@""];
    [[AppController appDelegate] stopProgressWithText:@""];

    if (nil == error)
    {
        var job = [userInfo objectForKey:ServicesJobKey],
            request = [job request],
            info = [request info];

        var textContact = [CPString stringWithFormat:@"%@\n%@", [_analyseTF stringValue], info];
        [_analyseTF setStringValue:textContact];
    }
    else
    {
        var errorMsg = @"L'obtention des infos des vetup users a échoué";
        [[AppController appDelegate] stopProgressWithText:errorMsg];
        [[ErrorManager sharedManager] displayErrorMessage:errorMsg];
    }
}

- (void)_updateVetupUserNotification:(CPNotification)notification;
{
    CPLog.debug(@"_updateVetupUserNotification");

    var userInfo = [notification userInfo],
        error    = [userInfo objectForKey:ServicesErrorKey];

//    [[AppController appDelegate] stopProgress];

    [_actionTF setStringValue:@""];
    [[AppController appDelegate] stopProgressWithText:@""];

    var job = [userInfo objectForKey:ServicesJobKey],
        request = [job request];

    if (nil == error)
    {
        var info = [request info],
            textContact = [CPString stringWithFormat:@"%@\n%@", [_analyseTF stringValue], info];

        [_analyseTF setStringValue:textContact];
    }
    else
    {
        var errorMsg = @"La modification du user a échoué",
            updatedUser = [request vetupUser],
            user = [[DataManager sharedManager] vetupUserByUid:[updatedUser uid]];

        //on remet les valeurs intiales (avant la modification) dans l'objet vetup_user
        [user copyVetupUser:updatedUser];

        //[self _refreshTableFromPredicate];
        [self refresh];

        [[ErrorManager sharedManager] displayErrorMessage:errorMsg];
        [[AppController appDelegate] stopProgressWithText:errorMsg];
    }
}



- (void)_getVetupUsersNotification:(CPNotification)notification;
{
    CPLog.debug(@"_getVetupUsersNotification");

//    [[CPNotificationCenter defaultCenter] removeObserver:self name:WSGetReferenceDataNotification object:nil];

    var userInfo = [notification userInfo],
        error    = [userInfo objectForKey:ServicesErrorKey];

    [[AppController appDelegate] stopProgress];

    CPLog.debug(@"_getVetupUsersNotification error: %@", error);

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
            [_loadingButton setTitle:@"Load Vetup Users"];
        }

        var percent = ROUND((currentPage * 100) / _totalPages);
        [self _displayProgress:percent];
        [self _updateNbLoadedUser:nbUsers];

        [self _refreshTableFromPredicate];
    }
    else
    {
        [[AppController appDelegate] stopProgressWithText:@"Le chargement des vetup users a échoué"];

        var errorMsg = [CPString stringWithFormat:@"Le chargement des vetup users a échoué\n%@", [error desc]];
        [[ErrorManager sharedManager] displayErrorMessage:errorMsg];

        [_loadingButton setTitle:@"Load Vetup Users"];
    }
}



@end



