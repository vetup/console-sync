@import <Foundation/CPObject.j>
@import "../Common/ServicesNotifications.j"
@import "./WSRequestJob.j"
@import "../Requests/WSDeleteCRVUsers.j"

@class DataManager;

@implementation WSDeleteCRVUsersJob : WSRequestJob
{
    //Input request parameter
    CPMutableArray         _emails;
}

- (id)init
{
//  CPLog.info(@">>>> Entering WSGetCRVUsersJob::INIT");
    if (self = [super initWithServiceNotification:WSDeleteCRVUsersNotification])
    {

    }
    return self;
}

- (id)initWithEmails:(CPMutableArray)emails
{
    if (self = [self init])
    {
        _emails = emails;
    }
    return self;
}

// MARK: Job implementation

- (void)start
{
//  CPLog.info(@">>>> Entering WSGetCRVUsersJob::start ");
    var request = [[WSDeleteCRVUsers alloc] init];
    [request setEmails:_emails];
    _request = request;

    [super start];
}

- (void)jobTerminated
{
//    CPLog.debug(@">>>> Entering WSGetReferenceDataJob::jobTerminated ");
    var data                = [_request getData],
        emailUsers          = [data objectForKey:"emailUsers"],
        invalidEmailUsers   = [data objectForKey:"invalidEmailUsers"];

    [[DataManager sharedManager] setEmailUsers:emailUsers];
    [[DataManager sharedManager] setInvalidEmailUsers:invalidEmailUsers];

    [super jobTerminated];
//  CPLog.info(@"<<<<< Leaving WSGetCRVUsersJob::jobTerminated ");
}

@end

