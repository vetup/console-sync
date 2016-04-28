//
// UserManager.j
//

@import <Foundation/CPObject.j>
@import <AppKit/CPAlert.j>

@import "../Service/Common/WSError.j"
//@import "../Service/JobsManagement/JobQueue.j";

var errorManagerSharedInstance = nil;

@implementation ErrorManager : CPObject
{
     BOOL _isErrorBeingDisplayed;
}

+ (ErrorManager)sharedManager
{
    if (errorManagerSharedInstance == nil)
    {
        errorManagerSharedInstance = [[ErrorManager alloc] init];
    }

    return errorManagerSharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
        _isErrorBeingDisplayed = false;
    }
    return self;
}


#pragma mark -
#pragma mark Public


- (void)presentError:(WSError)iError
{

    var alertMessage = @"WS Error";
    var alertInformative = [CPString stringWithFormat:@"Problème lors de la communication avec le serveur: \ncode: %@  desc: %@", [iError code], [iError desc]];
//    var alertInformative = @"test TOTO";

//    var alert = [CPAlert new];
    var alert = [[CPAlert alloc] init];
    [alert setAlertStyle:CPCriticalAlertStyle];
    [alert addButtonWithTitle:@"Ok"];
    [alert setMessageText:alertMessage];
    [alert setInformativeText:alertInformative];

//    [alert beginSheetModalForWindow:[[CPApplication sharedApplication] mainWindow]];

/*
    var test = [[CPApplication sharedApplication] mainWindow];
    var theWindow =  [[AppController appDelegate] testTheWindow]
    var test2 = [CPApp keyWindow];
    [[alert window] setPlatformWindow:[theWindow platformWindow]];
    test = [[CPApplication sharedApplication] mainWindow];
*/

    [alert runModalWithDidEndBlock:function(alert, returnCode)
    {
       // CPLog.info("didEndBlock: alert = %s, code = %d", [alert description], returnCode);
    }];

/*
    if (![CPApp keyWindow])
    {
        [alert _createWindowWithStyle:_CPModalWindowMask];
      //  [[alert window] setPlatformWindow:[theWindow platformWindow]];
    }
*/

    //[alert beginSheetModalForWindow:test1];


//https://groups.google.com/forum/#!searchin/objectivej/CPAlert/objectivej/0qxSrSwwE-0/Qu2xofKmCQAJ
/*
    [alert runModalWithDidEndBlock:function(alert, returnCode)
    {
       // CPLog.info("didEndBlock: alert = %s, code = %d", [alert description], returnCode);
       var test = 4;
       test = 5;
    }];*/
}


//garanti d'afficher une seule popup d'erreur
- (void) displayErrorMessage:(CPString)iMsg
{
    if (false == _isErrorBeingDisplayed)
    {
        var alertMessage = @"Error";
        var alert = [[CPAlert alloc] init];
//        [alert setDelegate:self];
        [alert setAlertStyle:CPCriticalAlertStyle];
        [alert addButtonWithTitle:@"Ok"];
        [alert setMessageText:alertMessage];
        [alert setInformativeText:iMsg];

        //PF: j'utilise runModalWithDidEndBlock au lieu de beginSheetModalForWindow car sinon j'ai des crash avec les sheets dans des sheets...
        [alert runModalWithDidEndBlock:function(alert, returnCode)
            {
               // CPLog.info("didEndBlock: alert = %s, code = %d", [alert description], returnCode);
                _isErrorBeingDisplayed = false;

            }];

        _isErrorBeingDisplayed = true;
    }
}

- (void)confirmEnd:(CPAlert)confirm returnCode:(int)returnCode
{
    CPLog.debug(@"confirmEnd - returnCode = %d", returnCode);
    _isErrorBeingDisplayed = false;
}

- (void)alertView:(CPAlert)alertView clickedButtonAtIndex:(int)buttonIndex
{
    _isErrorBeingDisplayed = false;

     CPLog.debug(@"ErrorManager: clickedButtonAtIndex");

}


/*
//MARK: UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _isErrorBeingDisplayed = false;
}

//MARK: Private
- (void) _displayErrorMessage:(NSString *)iMsg
{
    if (false == _isErrorBeingDisplayed)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:iMsg
                              message:nil delegate:self
                              cancelButtonTitle:NSLocalizedString( @"GLOBAL_OK", @"") otherButtonTitles:NULL];
        [alert show];
        [alert release];

        _isErrorBeingDisplayed = true;

    }
}
*/

- (WSError)errorWithCodeAndDomain:(CPString)iCode domain:(CPString)iDomain
{
    var error = [[WSError alloc] init];

    [error setCode:iCode];
    [error setDomain:iDomain];

    return error;
}

@end
