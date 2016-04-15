@import <Foundation/CPObject.j>
@import "../Common/ServicesNotifications.j"
@import "./WSRequestJob.j"
@import "../Requests/WSGetCRVUniqueUsers.j"

@class DataManager;


@implementation WSGetCRVUniqueUsersJob : WSRequestJob
{
}

- (id)init
{
//    CPLog.info(@">>>> Entering WSGetCRVUsersJob::INIT");

    if (self = [super initWithServiceNotification:WSGetCRVUniqueUsersNotification])
    {

    }
    return self;
}



// MARK: Job implementation

- (void)start
{
//    CPLog.info(@">>>> Entering WSGetCRVUsersJob::start ");

    var request = [[WSGetCRVUniqueUsers alloc] init];
    _request = request;

    [super start];
}

- (void)jobTerminated
{
//    CPLog.debug(@">>>> Entering WSGetReferenceDataJob::jobTerminated ");

    var data                = [_request getData],
        uniqueUsers         = [data objectForKey:"uniqueUsers"],
        uniqueUsersMap      = [data objectForKey:"uniqueUsersMap"];

    [[DataManager sharedManager] setUniqueUsers:uniqueUsers];
    [[DataManager sharedManager] setUniqueUsersMap:uniqueUsersMap];

    [[DataManager sharedManager] refreshIsMerged];

    [super jobTerminated];

//    CPLog.info(@"<<<<< Leaving WSGetCRVUsersJob::jobTerminated ");
}

@end
