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
@import "../../../Backend/Data/Color.j"
@import "../../../UI/Common/EDSVGIcon.j"

@class AppController;
//@class Color;

@global KObjectTypeColor;

/*
var C_COLUMN_UID_ID         = "uid";
var C_COLUMN_LABEL_ID       = "label";
var C_COLUMN_ALAUNE_ID      = "alaune";
*/
/*
*/

@implementation ModuleColorDataListController : CPObject
{
    @outlet CPView          _container;
    //Datasource pour la table categories
    @outlet CPTableView     _colorTable
    @outlet CPView          _buttonBarContainer;

    //Data
    CPMutableArray          _colors;
    CPMutableDictionary     _colorsMap;


    //Icons
    @outlet EDSVGIcon      _refreshIcon;

    //affichage de l'analyse
    @outlet LPMultiLineTextField     _analyseTF;
    @outlet CPTextField              _analyseStatusLabel;

    //affichage de l'analyse
    @outlet LPMultiLineTextField     _synchronizationTF;
    @outlet CPTextField              _synchronizationStatusLabel;


    Color                   _newItemBeingAdded;


    //DEBUG
    @outlet CPView          _syncContainer;
    @outlet CPView          _analyseContainer;
}


- (id)init
{
   // CPLog.info(@">>>> Entering ModuleColorDataListController::init");

   // CPLog.info(@"<<<< Leaving ModuleColorDataListController::init");

    return self;
}


- (void)awakeFromCib
{
    CPLog.debug(@">>>> Entering ModuleColorDataListController::awakeFromCib");

    //DEBUG
 //   [_syncContainer setBackgroundColor:[CPColor redColor]];
 //   [_analyseContainer setBackgroundColor:[CPColor greenColor]];
    [_syncContainer setBackgroundColor:[CPColor clearColor]];
    [_analyseContainer setBackgroundColor:[CPColor clearColor]];


    [_container setBackgroundColor:[CPColor whiteColor]];

    //Les data sont dispo ?
    var colors = [[DataManager sharedManager] colors];
    if (nil == colors)
    {
        [self refreshDataFromServer];
    }
    else
    {
        self._colors = colors;
        self._colorsMap = [[DataManager sharedManager] colorsMap];
    }

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


    [_refreshIcon setDelegate:self];

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

    CPLog.debug(@"<<<< Leaving ModuleColorDataListController::awakeFromCib");
}


- (void)refreshDataFromServer
{
    [[AppController appDelegate] startProgressWithText:@"Chargement des couleurs en cours..."];
    [[AppController appDelegate] startProgress];

    [[RequestManager sharedManager] performGetReferenceData:KObjectTypeColor];
}

- (void)refreshAnalyseFromServer
{
    [_analyseStatusLabel setStringValue:@"Analyse en cours..."];
    [[RequestManager sharedManager] performAnalyseReferenceData:KObjectTypeColor];
}




- (void)refresh
{
    [_colorTable reloadData];
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

- (void)_addColorAction:(id)sender
{
    CPLog.debug(@"ModuleColorDataListController::_addColorAction: %@", sender);


    if (_newItemBeingAdded == nil)
    {
        var colors  = self._colors,
            color   = [Color new];

        [color setUid:0];
        [color setName:@""];

        [self._colors addObject:color];

        var rowIndex = [self._colors count] - 1;

        [_colorTable reloadData];

        var indexSet = [CPIndexSet indexSetWithIndex:rowIndex];

        //PF: 10/12/2015 - si on ne scroll pas sur la cellule editColumn crash si la ligne n'est pas visible
        [_colorTable scrollRowToVisible:rowIndex];

        //sélection de la nouvelle couleur en fin de table
        [_colorTable selectRowIndexes:indexSet byExtendingSelection:NO];
        [_colorTable editColumn:0 row:rowIndex withEvent:nil select:NO];

        _newItemBeingAdded = color;
    }

}

- (void)_removeColorAction:(id)sender
{
    CPLog.debug(@"ModuleColorDataListController::_removeColorAction: %@", sender);

    var selectedIndex = [_colorTable selectedRow];

    CPLog.debug(@"_removeColorAction:: %@", selectedIndex);

    if (_newItemBeingAdded == nil && selectedIndex >= 0)
    {
        var color = self._colors[selectedIndex];

        var alertMessage = @"Attention",
            alertInformative =  [CPString stringWithFormat:@"Etes vous sur de vouloir supprimer la couleur %@ ?",[color name]],
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
               // CPLog.info("didEndBlock: alert = %s, code = %d", [alert description], returnCode);
                 CPLog.debug(@"TEST: %@", buttonIndex);
                if (1 == buttonIndex)
                {
                    [[AppController appDelegate] startProgressWithText:@"Suppression en cours..."];
                    [[AppController appDelegate] startProgress];

                    [[RequestManager sharedManager] performDeleteReferenceData:color];
                }
            }];
        /*
        var categories = [self _categoryList];
        [categories removeObjectsAtIndexes:[_categorieTable selectedRowIndexes]];
        [_categorieTable reloadData];
        */
    }
}


/*
Supprime les catégories sélectionnées
*/
/*
- (void)_removeCategoryAction:(id)sender
{
    CPLog.debug(@"ModuleArticleCategoryTabController::_removeCategoryAction: %@", sender);

    if (_newItemBeingAdded == nil)
    {
        var categories = [self _categoryList];
        [categories removeObjectsAtIndexes:[_categorieTable selectedRowIndexes]];
        [_categorieTable reloadData];
    }
}
*/

#pragma mark -
#pragma mark IB Action

/*
- (IBAction)getColorsAction:(id)aSender
{
    [self refreshDataFromServer];
}
*/

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


/*
- (IBAction)addExtractedCategoryAction:(id)aSender
{
    var moduleArticle = [self _currentModuleArticle];

    var extractedCategories = [moduleArticle categoriesExtractedFromFlux];
    var categories = [moduleArticle categories];

    var selectedIndex = [_extractedCategorieArrayController selectionIndex];

    if (selectedIndex >= 0)
    {
        var catId = extractedCategories[selectedIndex];
        var category = [Category new];

        [category setUid:catId];
        [category setLabel:catId];
        [category setAlaune:false];

        [categories addObject:category];

//        [_categorieArrayController setContent:categories];
        [_categorieTable reloadData];

    }
}

- (IBAction)addAllExtractedCategoryAction:(id)aSender
{
    CPLog.debug(@"ModuleArticleCategoryTabController::addAllExtractedCategoryAction: %@", aSender);

    var moduleArticle = [self _currentModuleArticle];

    var extractedCategories = [moduleArticle categoriesExtractedFromFlux];
    var categories = [moduleArticle categories];

    for (var i=0; i < [extractedCategories count]; i++)
    {
        var catId = extractedCategories[i];
        var category = [Category new];

        [category setUid:catId];
        [category setLabel:catId];
        [category setAlaune:false];

        [categories addObject:category];
    }

    [_categorieTable reloadData];
  //  [_categorieArrayController setContent:categories];

    CPLog.debug(@"ModuleArticleCategoryTabController::addAllExtractedCategoryAction: count %d", [categories count]);
}
*/


#pragma mark -
#pragma mark Private



/*
-(ModuleArticle)_currentModuleArticle
{
    var targetId = [[UserManager sharedManager] currentTarget];
    var target = [[TargetManager sharedManager] targetWithId:targetId];
    var moduleArticle = [target moduleArticle];
    return moduleArticle;
}
*/
/*
- (CPArray)_categoryList
{
    var moduleArticle = [self _currentModuleArticle];
    return [moduleArticle categories];
}
*/

- (Boolean)_isColorExist:(CPString)name
{
    var result          = false,
        uppercaseName   = [name uppercaseString];

    for (var i = 0; i < [self._colors count]; i++)
    {
        var  color                  = self._colors[i],
             colorNameUppercase     = [[color name] uppercaseString];

        if ([uppercaseName isEqualToString:colorNameUppercase])
        {
            result = true;
            break;
        }
    }

    return result;
}


- (void)_addButtonBar
{
// Button Bar
    var plusButton = [CPButtonBar plusButton],
        minusButton = [CPButtonBar minusButton],

        buttonBar = [[CPButtonBar alloc] initWithFrame:CGRectMake(1.0, 0.0, 100, 26)];

    [plusButton setTarget:self];
    [minusButton setTarget:self];
    [plusButton setAction:@selector(_addColorAction:)];
    [minusButton setAction:@selector(_removeColorAction:)];

    [buttonBar setHasResizeControl:NO];
    //[buttonBar setAutoresizingMask:CPViewWidthSizable | CPViewMinYMargin];

    [buttonBar setButtons:[CPArray arrayWithObjects:plusButton, minusButton]];

    [_buttonBarContainer addSubview:buttonBar];
}

/*
- (BOOL)_isValidCategories
{

    var categories = [self _categoryList];

    var isInvalid = false;

    for (var i=0; i < [categories count]; i++)
    {
        var cat = categories[i];

        var uid     = [[cat uid] stringByTrimmingWhitespace];
        var label   = [[cat label] stringByTrimmingWhitespace];

        if ([uid isEqualToString:@""] || [label isEqualToString:@""])
        {
            isInvalid = true;
            break;
        }
    }

    if (isInvalid)
        return false;
    else
        return true;

}
*/

#pragma mark Alert View - suppression de la couleur

- (void)alertView:(CPAlert)alertView clickedButtonAtIndex:(int)buttonIndex
{

     CPLog.debug(@"TEST: %@", buttonIndex);

}


#pragma mark -
#pragma mark Delegate table colorTable


- (int)numberOfRowsInTableView:(CPTableView)tableView
{
    return [_colors count];
}

- (id)tableView:(id)tableView objectValueForTableColumn:(CPTableColumn)aColumn row:(CPInteger)aRow
{
   // CPLog.debug("TABLEVIEW: : objectValueForTableColumn aRow: %@", aRow);

   var  color   = _colors[aRow],
        name    = [color name];

   return name;
}


#pragma mark -
#pragma mark Edition des cellules de la table colorTable


- (void)tableView:(CPTableView)tableView setObjectValue:(id)aValue forTableColumn:(CPTableColumn)tableColumn row:(CPInteger)aRow
{
 //   CPLog.debug(@"ModuleArticleCategoryTabController::setObjectValue: row: %d   value: %@", aRow, aValue);

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
}

#pragma mark -
#pragma mark WS Notification



- (void)_getReferenceColorListNotification:(CPNotification)notification;
{
    CPLog.debug(@"_getReferenceColorListNotification");


//    [[CPNotificationCenter defaultCenter] removeObserver:self name:WSGetReferenceDataNotification object:nil];

    var userInfo = [notification userInfo],
        error    = [userInfo objectForKey:ServicesErrorKey];

   // var job = [userInfo objectForKey:ServicesJobKey];
   // var request = [job request];

    [[AppController appDelegate] stopProgress];

    if (nil == error)
    {
        //var msg = @"La modification a été réalisée avec succès";
        //[[TNGrowlCenter defaultCenter] pushNotificationWithTitle:@"Config Module Article" message:msg];

        [[AppController appDelegate] stopProgressWithText:@"Couleurs chargées"];

        var colors      = [[DataManager sharedManager] colors],
            colorMap    = [[DataManager sharedManager] colorsMap];

        self._colors     = colors;
        self._colorsMap  = colorMap;

        [self refresh];
    }
    else
    {
        [[AppController appDelegate] stopProgressWithText:@"Le chargement des couleurs de a échouée"];
        var errorMsg = @"Le chargement des couleurs a échoué";
        [[ErrorManager sharedManager] displayErrorMessage:errorMsg];
    }
}

- (void)_updateReferenceColorListNotification:(CPNotification)notification;
{
   // [[CPNotificationCenter defaultCenter] removeObserver:self name:WSUpdateReferenceDataNotification object:nil];

    [[AppController appDelegate] stopProgress];

    var userInfo    = [notification userInfo],
        error       = [userInfo objectForKey:ServicesErrorKey],
        job         = [userInfo objectForKey:ServicesJobKey],
        request     = [job request],
        colorUpdate = [request object];

    CPLog.debug(@"---- UPDATE COLOR: name: %@   id request: %@", [colorUpdate name], request.id);

    var color = [self._colorsMap objectForKey:[colorUpdate uid]];

    if (nil == error)
    {
        var msg = [CPString stringWithFormat:@"Couleur %@ modifiée avec succès", [color name]];
        [[AppController appDelegate] stopProgressWithText:msg];

        [self refreshAnalyseFromServer];
    }
    else
    {
        //On remet l'ancienne couleur
        var color = [self._colorsMap objectForKey:[colorUpdate uid]];
        [color setName:[colorUpdate saveName]];
        var errorMsg = [CPString stringWithFormat:@"L'enregistrement de la couleur %@ a échoué", [colorUpdate name]];
        [[TNGrowlCenter defaultCenter] pushNotificationWithTitle:@"Couleurs de référence" message:errorMsg];
        [[AppController appDelegate] stopProgressWithText:@""];
        [self refresh];
    }
}


- (void)_addReferenceColorListNotification:(CPNotification)notification;
{
   // [[CPNotificationCenter defaultCenter] removeObserver:self name:WSUpdateReferenceDataNotification object:nil];

    [[AppController appDelegate] stopProgressWithText:@""];
    [[AppController appDelegate] stopProgress];

    var userInfo    = [notification userInfo],
        error       = [userInfo objectForKey:ServicesErrorKey],
        job         = [userInfo objectForKey:ServicesJobKey],
        request     = [job request],
        color       = [request object];

    CPLog.debug(@"---- ADD COLOR: name: %@   id request: %@", [color name], request.id);

    if (nil == error)
    {
        var msg = [CPString stringWithFormat:@"Couleur %@ ajoutée avec succès", [color name]];
        [[AppController appDelegate] stopProgressWithText:msg];

        [self refreshAnalyseFromServer];
    }
    else
    {
       //var color = [_colorsMap objectForKey:[colorUpdate id]];
        var errorMsg = [CPString stringWithFormat:@"L'enregistrement de la couleur %@ a échoué", [color name]];
        [[TNGrowlCenter defaultCenter] pushNotificationWithTitle:@"Couleurs de référence" message:errorMsg];

        [self._colors removeObject:color];

        [self refresh];
    }
}

- (void)_deleteReferenceColorListNotification:(CPNotification)notification;
{
   // [[CPNotificationCenter defaultCenter] removeObserver:self name:WSUpdateReferenceDataNotification object:nil];

    [[AppController appDelegate] stopProgress];
    [[AppController appDelegate] stopProgressWithText:@""];

    var userInfo    = [notification userInfo],
        error       = [userInfo objectForKey:ServicesErrorKey],
        job         = [userInfo objectForKey:ServicesJobKey],
        request     = [job request],
        color       = [request object];

    CPLog.debug(@"---- DELETE COLOR: name: %@   id request: %@", [color name], request.id);

    if (nil == error)
    {
        var msg = [CPString stringWithFormat:@"Couleur supprimée avec succès", [color name]];
        [[AppController appDelegate] stopProgressWithText:msg];

        [self._colors removeObject:color];
        [self refresh];

        [self refreshAnalyseFromServer];
    }
    else
    {
        var errorMsg = [CPString stringWithFormat:@"La suppression de la couleur %@ a échouée", [color name]];
        [[TNGrowlCenter defaultCenter] pushNotificationWithTitle:@"Couleurs de référence" message:errorMsg];
    }
}

- (void)_analyseReferenceColorListNotification:(CPNotification)notification;
{
//    [[CPNotificationCenter defaultCenter] removeObserver:self name:WSGetReferenceDataNotification object:nil];

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
        CPLog.debug(@"---- _analyseReferenceColorListNotification: %@", analyseResult);

        var previousText = [_analyseTF stringValue],
            newText      = [CPString stringWithFormat:@"%@\n%@", previousText, analyseResult];

        [_analyseTF setStringValue:newText];

var textarea = _analyseTF._DOMTextareaElement;
textarea.focus();
textarea.scrollTop = textarea.scrollHeight;
//[_analyseTF setNeedsLayout];


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


- (void)_synchronizeReferenceColorListNotification:(CPNotification)notification;
{
//    [[CPNotificationCenter defaultCenter] removeObserver:self name:WSGetReferenceDataNotification object:nil];

    var userInfo    = [notification userInfo],
        error       = [userInfo objectForKey:ServicesErrorKey],
        job         = [userInfo objectForKey:ServicesJobKey],
        request     = [job request];

    [_synchronizationStatusLabel setStringValue:@""];




    if (nil == error)
    {
        CPLog.debug(@"---- _synchronizeReferenceColorListNotification");

        var synchronizationResult = [request getSynchronizationResult];

        var previousText = [_synchronizationTF stringValue],
            newText      = [CPString stringWithFormat:@"%@\n%@", previousText, synchronizationResult];

        [_synchronizationTF setStringValue:newText];

        [self refreshAnalyseFromServer];
    }
    else
    {
        //Erreur
        CPLog.debug(@"---- _analyseReferenceColorListNotification: ERROR:  id: %@", [request id]);
        [[TNGrowlCenter defaultCenter] pushNotificationWithTitle:@"Synchronisation vers CRV" message:@"La synchronisation a échouée"];
    }
}



@end



