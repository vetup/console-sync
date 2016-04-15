@import <Foundation/Foundation.j>
@import <AppKit/CPWindow.j>
@import <AppKit/CPTextField.j>

@import <GrowlCappuccino/GrowlCappuccino.j>
@import "./RequestInProgressView.j"
@import "./EKShakeAnimation.j"

@import "../../Backend/Service/Common/ServicesNotifications.j"
@import "../../Backend/Service/Common/WSUtils.j"

@import "../../Backend/Managers/ErrorManager.j"
@import "../../Backend/Managers/UserManager.j"
@import "../../Backend/Managers/AlertManager.j"

@import "../../Backend/Common/Tools.j"


@class AppController;

/*
var KTopBarColor        =   [CPColor colorWithRed:0xAD/0xFF green:0xA2/0xFF blue:0x9B/0xFF alpha:1.0]
var KStatusBarColor     =   [CPColor colorWithRed:0xDE/0xFF green:0xCF/0xFF blue:0xC2/0xFF alpha:1.0]
var KWindowBGColor      =   [CPColor colorWithRed:0xF1/0xFF green:0xE0/0xFF blue:0xD4/0xFF alpha:1.0]
*/

//@global KStatusBarColor;
var KBGColor        =   [CPColor colorWithRed:0xAD/0xFF green:0xA2/0xFF blue:0x9B/0xFF alpha:1.0]


@implementation LoginController : CPObject
{
    @outlet CPTextField _email;
    @outlet CPTextField _password;

    @outlet CPWindow   _mainWindow;
    @outlet CPView     _theView;

    RequestInProgressView _requestInProgressView;
}

- (void)awakeFromCib
{
    CPLog.info(@">>>> Entering LoginController::awakeFromCib:  %@" , [[_mainWindow contentView] bounds]);

    _requestInProgressView = [[RequestInProgressView alloc] initWithFrame:[[_mainWindow contentView] bounds]];

    [_theView setBackgroundColor:KBGColor];

    [[_mainWindow contentView] addSubview:_requestInProgressView];

    [_requestInProgressView hide];
    [_requestInProgressView setSpinnerPos:160 y:196];

//    [_email setStringValue:@"philippe.fuentes@vetup.com"];
    [_email setStringValue:@""];
//    [_email setStringValue:@""];
    [_password setStringValue:@""];


    //PF: 21/11/2014 - Change la hauteur à la main, marche pas via le xib...
    var frame = [_email frame];
    frame.size.height = 30;
    [_email setFrame:frame];

    frame = [_password frame];
    frame.size.height = 30;
    [_password setFrame:frame];

    CPLog.info(@"<<<< Leaving LoginController::awakeFromCib");
}


//----o PUBLIC
#pragma mark -
#pragma mark PUBLIC

//- (IBAction)showWindow:(id)aSender
- (void)showWindow:(id)aSender
{
//    [fieldNewPassword setStringValue:@""];
//    [fieldNewPasswordConfirm setStringValue:@""];
    [_mainWindow center];
    [_mainWindow makeKeyAndOrderFront:aSender];
}


//----o ACTION
- (IBAction)okAction:(id)aSender
{
//     CPLog.debug(@"LoginController::okAction 1  email: %@   pass:%@", [_email stringValue], [_password stringValue]);

    if ([self _checkEmail])
    {
        if ([self _checkPasswordLength:1])
        {
            //retire le focus !, sinon on continuer à écrire dedans

//PF: fais des trucs bizarre cette merde...
//            [_email resignFirstResponder];
//            [_password resignFirstResponder];

            [_requestInProgressView show];

            [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_loginNotification:) name:WSLoginNotification object:nil];

            [[UserManager sharedManager] login:[_email stringValue] password:[_password stringValue]];

//            [[EKShakeAnimation alloc] initWithView:[_mainWindow contentView]];
        }
        else
        {
            //Error !
             [[ErrorManager sharedManager] displayErrorMessage:@"Voud devez saisir un mot de passe"];
        }


    }
    else
    {
        //Error !
         [[ErrorManager sharedManager] displayErrorMessage:@"Mauvais format d'email"];
    }
}


//----o PRIVATE

-(BOOL)_checkEmail
{
    var email = [_email stringValue];
    if ([email length] > 0)
    {
        var re_email = /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*$/ ;

        return re_email.test(email);
    }

    return NO;
}



-(BOOL)_checkPasswordLength:(int)length
{
    var password = [_password stringValue];

    return ([password length] >= length);
}

/*
-(BOOL)checkPassword
{
    var password = [passwordTextField stringValue];
    var confirm = [confirmTextField stringValue];

    if ([password compare:confirm] == CPOrderedSame)
        return YES;

    return NO;
}*/



//----o NOTIFICATION

- (void)_loginNotification:(CPNotification)notification
{
    CPLog.debug(@"LoginController::_loginNotification received: %@", notification);

    [[CPNotificationCenter defaultCenter] removeObserver:self name:WSLoginNotification object:nil];

//TEST
//[[CPNotificationCenter defaultCenter] postNotificationName:@"TEST" object:self userInfo:nil];

    [_requestInProgressView hide];
    [[AppController appDelegate] stopProgress];

    var userInfo = [notification userInfo];

    var error = [userInfo objectForKey:ServicesErrorKey];


    if (nil == error)
    {
        var job = [userInfo objectForKey:ServicesJobKey];
        var uid = [[job request] getUid];
        var name = [_email stringValue];
        var role = [[job request] getRole];
        //var currentTarget = [[job request] getTarget];

        [[UserManager sharedManager] setUid:uid];
        [[UserManager sharedManager] setName:name];
        [[UserManager sharedManager] setRole:role];

        //[[UserManager sharedManager] setCurrentTarget:currentTarget];

        //CPLog.debug(@"LoginController::_loginNotification CURRENT TARGET: %@", currentTarget);

        [_mainWindow close];

        [[TNGrowlCenter defaultCenter] pushNotificationWithTitle:@"login notification" message:name];

        [[AppController appDelegate] showMainView];
        [[AppController appDelegate] refreshMainView];

        var msg = [CPString stringWithFormat:@"Connected as %@ (rôle: %@)", [[UserManager sharedManager] email], [[UserManager sharedManager] role]];

        [[AppController appDelegate]  setStatusBarText:msg];

    }
    else if (WSInternetError == error.code)
    {
      [AlertManager okErrorPopup:@"ERROR" msg:@"Vous n'êtes pas connecté à internet"];
    }
    else
    {
      [AlertManager okErrorPopup:@"ERROR" msg:@"Identification impossible"];
    }

//    CPLog.debug(@"LoginController::_loginNotification uid: %@  isSuperAdmin: %d",  [[UserManager sharedManager] getUid],  [[UserManager sharedManager] isSuperAdmin]);
}

@end
