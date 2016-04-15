//
// MainViewController.j
//
// Created by Philippe Fuentes.
//

@import <Foundation/CPObject.j>
@import <AppKit/CPViewController.j>
@import "./Module/ModuleViewController.j"

var mainControllerSharedInstance = nil;

@implementation MainViewController : CPViewController
{
}

+ (MainViewController)sharedController
{
    if (mainControllerSharedInstance == nil)
    {
        mainControllerSharedInstance = [[MainViewController alloc] init];
    }

    return mainControllerSharedInstance;
}


- (id)init
{
    //Imbecile !, n'appelle pas self view dans le init avant initWithCibName, car c'est lors de l'appel de self view que le systeme essaie de charger le cib
    //CPLog.info(@">>>> Entering AdminViewController::init : %@", [self view]);

    CPLog.info(@">>>> Entering MainViewController::init");

    if (self = [super initWithCibName:@"MainViewController" bundle:nil])
    {
     //   _targetViewController = nil;
    }

    CPLog.info(@"<<<< Leaving MainViewController::init");

    return self;
}


/*! called at cib awakening
*/

- (void)awakeFromCib
{
    CPLog.info(@">>>> Entering MainViewController::awakeFromCib");

    var moduleViewController  = [ModuleViewController sharedController],
        moduleView            = [moduleViewController view];

    [[self view] addSubview:moduleView];
    [moduleView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [moduleView setFrame:[[self view] frame]];

    CPLog.info(@"<<<< Leaving MainViewController::awakeFromCib");
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
