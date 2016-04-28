@import <Foundation/CPObject.j>
@import "../Common/ServicesNotifications.j"
@import "./WSRequestJob.j"
@import "../Requests/WSInfoVetupUsers.j"

@class DataManager;

@implementation WSInfoVetupUsersJob : WSRequestJob
{
    //Input request parameter
    CPMutableArray         _ids;
}

- (id)init
{
//  CPLog.info(@">>>> Entering WSGetCRVUsersJob::INIT");
    if (self = [super initWithServiceNotification:WSInfoVetupUserNotification])
    {

    }
    return self;
}

- (id)initWithIds:(CPMutableArray)ids
{
    if (self = [self init])
    {
        _ids = ids;
    }
    return self;
}

// MARK: Job implementation

- (void)start
{
//  CPLog.info(@">>>> Entering WSGetCRVUsersJob::start ");
    var request = [[WSInfoVetupUsers alloc] init];
    [request setIds:_ids];
    _request = request;

    [super start];
}

- (void)jobTerminated
{
//    CPLog.debug(@">>>> Entering WSGetReferenceDataJob::jobTerminated ");

/*
    var data                = [_request getData],
        emailUsers          = [data objectForKey:"emailUsers"],
        invalidEmailUsers   = [data objectForKey:"invalidEmailUsers"];

    [[DataManager sharedManager] setEmailUsers:emailUsers];
    [[DataManager sharedManager] setInvalidEmailUsers:invalidEmailUsers];
*/

    [super jobTerminated];
//  CPLog.info(@"<<<<< Leaving WSGetCRVUsersJob::jobTerminated ");
}

@end

