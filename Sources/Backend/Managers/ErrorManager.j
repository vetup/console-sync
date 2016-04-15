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
    var alertInformative =  [CPString stringWithFormat:@"Problème lors de la communication avec le serveur: \n%@",iError.code];

    var alert = [[CPAlert alloc] init];
//                [alert setDelegate:self];
    [alert setDelegate:nil];
    [alert setAlertStyle:CPCriticalAlertStyle];
    [alert addButtonWithTitle:@"Ok"];
//                [alert addButtonWithTitle:@"Report..."];
    [alert setMessageText:alertMessage];
    [alert setInformativeText:alertInformative];
    [alert runModal];

//TODO: la méthode ios qui suit !, localization des messages d'erreurs

    /*
    NSString *message = nil;

    if([[error domain] isEqual:NSURLErrorDomain] && [error code] == kNLNoInternetError)
    {
        [self _displayErrorMessage:NSLocalizedString(@"GLOBAL_SERVER_UNREACHABLE",@"")];

        return;
    }
    else if([[error domain] isEqual:NSURLErrorDomain] && [error code] == kNLNoConnexionToHostError)
    {
        [self _displayErrorMessage:NSLocalizedString(@"GLOBAL_HOST_NO_CONNEXION",@"")];
        return;
    }
    else if ([[error domain] isEqual:NSURLErrorDomain] && [error code] == kNLConnexionTimeoutHostError)
    {
        [self _displayErrorMessage:NSLocalizedString(@"GLOBAL_HOST_NO_CONNEXION",@"")];
        return;
    }
    //PF: 8/06/2012 - une erreur NSURLErrorDomain pas identifiée, on affiche erreur de connexion
    else if ([[error domain] isEqual:NSURLErrorDomain])
    {
        [self _displayErrorMessage:NSLocalizedString(@"GLOBAL_SERVER_UNREACHABLE",@"")];
        return;
    }
    else if ([[error domain] isEqual:WSGmailErrorDomain])
    {
        [self _displayErrorMessage:@"XML format error"];
        return;
    }
    else //stocke le message pour être utilisé en DEBUG_MODE
    {
        message =   [NSString stringWithFormat:@"desc: %@  domain: %@  code: %d",
                     [error localizedDescription],
                     [error domain],
                     [error code]];
    }

//PF VCC
    if([[error domain] isEqual:WSVetupErrorDomain] && [error code] == WS_UNKNOWN_ERROR)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];

        _isErrorBeingDisplayed = true;

    }




    NSLog(@"ErrorManager: %@", message);

#if DEBUG_MODE
    if (error)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
#endif

    */

}



/*- (BOOL)windowShouldClose:(id)window
{
    var confirmBox = [[CPAlert alloc] init];
    [confirmBox setTitle:nil];
    [confirmBox setAlertStyle:CPInformationalAlertStyle];
    [confirmBox setMessageText:[[TNLocalizationCenter defaultCenter] localize:@"Do you want to discard the changes in the email?"]];
    [confirmBox setInformativeText:[[TNLocalizationCenter defaultCenter] localize:@"Your changes will be lost if you discard them."]];
    [confirmBox addButtonWithTitle:[[TNLocalizationCenter defaultCenter] localize:@"Save as draft"]];
    [confirmBox addButtonWithTitle:[[TNLocalizationCenter defaultCenter] localize:@"Discard"]];
    [confirmBox addButtonWithTitle:[[TNLocalizationCenter defaultCenter] localize:@"Cancel"]];
    [confirmBox beginSheetModalForWindow:theWindow modalDelegate:self didEndSelector:@selector(confirmEnd:returnCode:) contextInfo:nil];

    return NO;
}

- (void)confirmEnd:(CPAlert)confirm returnCode:(int)returnCode
{
    CPLog.trace(@"confirmEnd - returnCode = %d", returnCode);
    switch (returnCode)
    {
    case CPAlertDiscard:
        [CPApp stopModal];
        [theWindow close];
        break;
    case CPAlertSaveAsDraft:
        [self saveAsDraftButtonClickedAction:nil];
        break;
    }
}
*/
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

   //pas de runModal si on veut pouvoir utiliser le end selector
  //      [alert beginSheetModalForWindow:[CPApp mainWindow] modalDelegate:self didEndSelector:@selector(confirmEnd:returnCode:) contextInfo:nil];
   //     [alert runModal];

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



    /*
        CPLog.trace(@"confirmEnd - returnCode = %d", returnCode);
    switch (returnCode)
    {
    case CPAlertDiscard:
        [CPApp stopModal];
        [theWindow close];
        break;
    case CPAlertSaveAsDraft:
        [self saveAsDraftButtonClickedAction:nil];
        break;
    */
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
    error.domain = iDomain;
    error.code = iCode;

    return error;
}

@end
