//
// MainViewController.j
//
// Created by Philippe Fuentes.
//

@import <Foundation/CPObject.j>
@import <AppKit/CPViewController.j>

//Permet de pouvoir utiliser les objets suivant lies aux tabs
@import "TestThemeTabController.j"
@import "TestTooltipTabController.j"
@import "TestPaintCodeTabController.j"
@import "TestVideoTabController.j"
@import "TestSVGTabController.j"
@import "TestSynchroTabController.j"


var testViewControllerSharedInstance = nil;

@implementation TestViewController : CPViewController
{
    @outlet TestThemeTabController _themeController;
}


+ (TestViewController)sharedController
{
    if (testViewControllerSharedInstance == nil)
    {
        testViewControllerSharedInstance = [[TestViewController alloc] init];
    }

    return testViewControllerSharedInstance;
}

- (id)init
{
    //imbecile !, n'appelle pas self view dans le init avant initWithCibName, car c'est lors de l'appel de self view que le syteme essaie de charger le cib
    //CPLog.info(@">>>> Entering AdminViewController::init : %@", [self view]);

    CPLog.info(@">>>> Entering TestViewController::init");

    if (self = [super initWithCibName:@"./nib/TestViewController" bundle:nil])
    {
    }

    CPLog.info(@"<<<< Leaving TestViewController::init");

    return self;
}


/*! called at cib awakening
*/

- (void)awakeFromCib
{
    CPLog.info(@">>>> Entering TestViewController::awakeFromCib");



    CPLog.info(@"<<<< Leaving TestViewController::awakeFromCib");
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
