@import <Foundation/CPObject.j>
@import "../Common/ServicesNotifications.j"
@import "./WSRequestJob.j"
@import "../Requests/WSMergeCRVUsers.j"

@class DataManager;

@implementation WSMergeCRVUsersJob : WSRequestJob
{
    //Input request parameter
    CPMutableArray         _emails;
}

- (id)init
{
//  CPLog.info(@">>>> Entering WSGetCRVUsersJob::INIT");
    if (self = [super initWithServiceNotification:WSMergeCRVUsersNotification])
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
    var request = [[WSMergeCRVUsers alloc] init];
    [request setEmails:_emails];
    _request = request;

    [super start];
}

- (void)jobTerminated
{
//    CPLog.debug(@">>>> Entering WSGetReferenceDataJob::jobTerminated ");

    var data                = [_request getData],
        emailUsers          = [data objectForKey:"emailUsers"],
        invalidEmailUsers   = [data objectForKey:"invalidEmailUsers"],
        uniqueUsers         = [data objectForKey:"uniqueUsers"],
        uniqueUsersMap      = [data objectForKey:"uniqueUsersMap"];

    [[DataManager sharedManager] setEmailUsers:emailUsers];
    [[DataManager sharedManager] setInvalidEmailUsers:invalidEmailUsers];
    [[DataManager sharedManager] setUniqueUsers:uniqueUsers];
    [[DataManager sharedManager] setUniqueUsersMap:uniqueUsersMap];


    [[DataManager sharedManager] refreshIsMerged];


    [super jobTerminated];
//  CPLog.info(@"<<<<< Leaving WSGetCRVUsersJob::jobTerminated ");
}

@end

