@import <Foundation/CPObject.j>
@import "../Common/ServicesNotifications.j"
@import "./WSRequestJob.j"
@import "../Requests/WSGetCRVUsers.j"

@class DataManager;


@implementation WSGetCRVUsersJob : WSRequestJob
{
}

- (id)init
{
//    CPLog.info(@">>>> Entering WSGetCRVUsersJob::INIT");

    if (self = [super initWithServiceNotification:WSGetCRVUsersNotification])
    {

    }
    return self;
}



// MARK: Job implementation

- (void)start
{
//    CPLog.info(@">>>> Entering WSGetCRVUsersJob::start ");

    var request = [[WSGetCRVUsers alloc] init];
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

//    CPLog.info(@"<<<<< Leaving WSGetCRVUsersJob::jobTerminated ");
}

@end
