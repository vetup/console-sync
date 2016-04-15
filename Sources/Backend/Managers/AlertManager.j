@import <Foundation/Foundation.j>

var alertManagerSharedInstance = nil;

@implementation AlertManager : CPObject
{
}

+ (AlertManager)sharedManager
{
    if (alertManagerSharedInstance == nil)
    {
        alertManagerSharedInstance = [[AlertManager alloc] init];
    }

    return alertManagerSharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}


+ (void) okErrorPopup:(CPString)iTitle msg:(CPString)iMsg
{
	[[AlertManager sharedManager] showaAlert:iTitle msg:iMsg];
}


- (void) showaAlert:(CPString)iTitle msg:(CPString)iMsg
{
//    var alertInformative =  [CPString stringWithFormat:@"Problème lors de la communication avec le serveur: \n%@",iMsg];

    var alert = [[CPAlert alloc] init];
//                [alert setDelegate:self];
    [alert setDelegate:nil];
    [alert setAlertStyle:CPCriticalAlertStyle];
    [alert addButtonWithTitle:@"Ok"];
//                [alert addButtonWithTitle:@"Report..."];
    [alert setMessageText:iTitle];
    [alert setInformativeText:iMsg];
    [alert runModal];
}




@end

