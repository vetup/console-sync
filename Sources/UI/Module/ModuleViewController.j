//
// MainViewController.j
//
// Created by Philippe Fuentes.
//

@import <Foundation/CPObject.j>
@import <AppKit/CPViewController.j>

//Permet de pouvoir utiliser les objets suivant lies aux tabs
@import "ModuleDataListTabController.j"
@import "ModuleUserTabController.j"

/*
@import "TestThemeTabController.j"
@import "TestTooltipTabController.j"
@import "TestPaintCodeTabController.j"
@import "TestVideoTabController.j"
@import "TestSVGTabController.j"
@import "TestSynchroTabController.j"
*/

var moduleViewControllerSharedInstance = nil;

@implementation ModuleViewController : CPViewController
{
    //@outlet TestThemeTabController _themeController;
    @outlet ModuleDataListTabController _dataListController;
}


+ (ModuleViewController)sharedController
{
    if (moduleViewControllerSharedInstance == nil)
    {
        moduleViewControllerSharedInstance = [[ModuleViewController alloc] init];
    }

    return moduleViewControllerSharedInstance;
}

- (id)init
{
    //imbecile !, n'appelle pas self view dans le init avant initWithCibName, car c'est lors de l'appel de self view que le syteme essaie de charger le cib
    //CPLog.info(@">>>> Entering AdminViewController::init : %@", [self view]);

    CPLog.info(@">>>> Entering ModuleViewController::init");

    if (self = [super initWithCibName:@"./nib/ModuleViewController" bundle:nil])
    {
    }

    CPLog.info(@"<<<< Leaving ModuleViewController::init");

    return self;
}


/*! called at cib awakening
*/

- (void)awakeFromCib
{
    CPLog.info(@">>>> Entering ModuleViewController::awakeFromCib");



    CPLog.info(@"<<<< Leaving ModuleViewController::awakeFromCib");
}


//----o PUBLIC
#pragma mark -
#pragma mark Public

- (void)refresh
{
}


#pragma mark -
#pragma mark Private



@end
