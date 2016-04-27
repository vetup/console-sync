/*
 * AppController.j
 * VCCAdmin
 *
 * Created by You on September 9, 2013.
 * Copyright 2013, Your Company All rights reserved.
 */

@import <Foundation/Foundation.j>

//PF: 25/06/2015 - permettre un jake deploy, inclure ce fichier dans AppController
@import <Foundation/CPDelayedPerform.j>

@import <AppKit/AppKit.j>
@import <AppKit/CPPopUpButton.j>
@import <AppKit/CPToolbar.j>
@import <AppKit/CPWindow.j>
@import <AppKit/CPView.j>
@import <AppKit/CPTextField.j>

@import <LPKit/LPCrashReporter.j>

//Test jake deploy
//@import <LPKit/LPMultiLineTextField.j>

@import <GrowlCappuccino/GrowlCappuccino.j>


@import "./Sources/UI/Common/LoginController.j"
@import "./Sources/UI/Common/RequestInProgressView.j"
@import "./Sources/UI/MainViewController.j"


@import "./Sources/Categories/CPBundle+Localizable.j"


//TEMP
@import "./Sources/Backend/Managers/UserManager.j"

@global CPLocalizedString
//ADA29B
//DECFC2
//F1E0D4

//var KStatusBarColor     =   [CPColor colorWithRed:168/0xFF green:215/0xFF blue:247/0xFF alpha:1.0]
var KTopBarColor        =   [CPColor colorWithRed:0xAD/0xFF green:0xA2/0xFF blue:0x9B/0xFF alpha:1.0]
var KStatusBarColor     =   [CPColor colorWithRed:0xDE/0xFF green:0xCF/0xFF blue:0xC2/0xFF alpha:1.0]
var KWindowBGColor      =   [CPColor colorWithRed:0xF1/0xFF green:0xE0/0xFF blue:0xD4/0xFF alpha:1.0]

var VetupAuthenticationKey = @"Vetup Authentication";


@implementation AppController : CPObject
{
    @outlet CPWindow    theWindow;
    @outlet LoginController _loginController;
    @outlet CPView _container;

    @outlet CPTextField _statusBarTF;
    @outlet CPTextField _versionAndCopyrightTF;
    @outlet CPView _statusBarView;
    @outlet CPView _topBarView;

    @outlet CPTextField _statusMessage;

    RequestInProgressView _requestInProgressView;
    int            _nbRequestInProgress;

    BOOL _isBusy @accessors(property=isBusy);
}

+ (AppController)appDelegate
{
    return [[CPApplication sharedApplication] delegate];
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    // This is called when the application is done loading.

    var test_mainapp = [UserManager sharedManager];
}

- (void)awakeFromCib
{

    //Permet la gestion concurrente de la vue de progression modale => on la rend invisible si aucune demande en cours (_nbRequestInProgress à zéro)
    _nbRequestInProgress = 0;

    // This is called when the cib is done loading.
    // You can implement this method on any object instantiated from a Cib.
    // It's a useful hook for setting up current UI values, and other things.

    // In this case, we want the window from Cib to become our full browser window
    [theWindow setFullPlatformWindow:YES];
    [theWindow setAcceptsMouseMovedEvents:YES];

//F1E0D4
    [[theWindow contentView] setBackgroundColor:KWindowBGColor];

    [LPCrashReporter sharedErrorLogger];
    [[LPCrashReporter sharedErrorLogger] setVersion:@"1.0.0"];


    /* Growl */
    CPLog.trace(@"initializing Growl");
    [[TNGrowlCenter defaultCenter] setView:[theWindow contentView]];


//DEBUG COLOR
/*
    [theWindow setBackgroundColor:[CPColor redColor]];
    [_container setBackgroundColor:[CPColor blueColor]];
    [[adminViewController view] setBackgroundColor:[CPColor yellowColor]];
*/


//View pour ue attente serveur, modale
    _requestInProgressView = [[RequestInProgressView alloc] initWithFrame:[[theWindow contentView] bounds]];
    [[theWindow contentView] addSubview:_requestInProgressView];


    var bundle = [CPBundle mainBundle];

    //Accès via authentification ?
    var hasToAuthenticate = [bundle objectForInfoDictionaryKey:VetupAuthenticationKey];
    if ([hasToAuthenticate isEqualToString:@"true"])
    {
        [self _showLoginWindow];
    }
    else
    {
        [self showMainView];
    }


    //Mise à jour TF de version copyright
    //© Vetup
    var version          = [bundle objectForInfoDictionaryKey:InfoVersionKey];
    var copyright        = [bundle objectForInfoDictionaryKey:@"CPHumanReadableCopyright"];

    var versionAndCopyright = [CPString stringWithFormat:@"%@  %@", version, copyright];

    [_versionAndCopyrightTF setStringValue:versionAndCopyright];


    [_statusBarView setBackgroundColor:KStatusBarColor];
    [_topBarView setBackgroundColor:KTopBarColor];

    //initialisation en amont de la main window (sinon un certain nombre d'objet ne seront pas initialisé au moment du login)
    [MainViewController sharedController];


}

//----o ACTION


//----o Public

- (void)startProgress
{
   // [_requestInProgressView show];
    _nbRequestInProgress++;
}

- (void)stopProgress
{
    _nbRequestInProgress--;
    if (_nbRequestInProgress < 0)
        _nbRequestInProgress = 0;

    if (0 == _nbRequestInProgress)
        [_requestInProgressView hide];
}

/*
- (void)startProgressWithText:(CPString)text
{
    [self startProgressWithText:text isModal:false];

}

- (void)startProgressWithText:(CPString)text isModal:(Boolean)isModal

*/



- (void)startProgressWithText:(CPString)text
{
    [_statusMessage setStringValue:text];
}

- (void)stopProgressWithText:(CPString)text
{
    [_statusMessage setStringValue:text];
}



- (void)showMainView
{
    CPLog.debug(">> Entering:  showMainView");

    var mainViewController  = [MainViewController sharedController],
        view                = [mainViewController view];

    [_container addSubview:view];
    [view setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    var frame = [_container frame];
    frame.origin.x = 0;
    frame.origin.y = 0;
    [view setFrame:frame];
}


//utilisé sur un logout
- (void)hideMainView
{
    CPLog.debug(">> Entering:  hideMainView");

    var mainViewController = [MainViewController sharedController];

    var view =  [mainViewController view];

    [view removeFromSuperview];

}

- (void)refreshMainView
{
    var mainViewController = [MainViewController sharedController];
    [mainViewController refresh];
}



- (void)logout
{
    [self hideMainView];
    [self _showLoginWindow];

}

- (void)setStatusBarText:(CPString)iText
{
    [_statusBarTF setStringValue:iText];
}


//----o ACTION


//----o PRIVATE
- (void)_showLoginWindow
{
    [_loginController showWindow: nil];
}


@end
