@import <Foundation/CPObject.j>
@import "../Common/ServicesNotifications.j"
@import "./WSRequestJob.j"
@import "../Requests/WSDeleteVetupUsers.j"

@class DataManager;

@implementation WSDeleteVetupUsersJob : WSRequestJob
{
    //Input request parameter
    CPMutableArray         _ids;
}

- (id)init
{
//  CPLog.info(@">>>> Entering WSGetCRVUsersJob::INIT");
    if (self = [super initWithServiceNotification:WSDeleteVetupUserNotification])
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
    var request = [[WSDeleteVetupUsers alloc] init];
    [request setIds:_ids];
    _request = request;

    [super start];
}

- (void)jobTerminated
{
    [super jobTerminated];
}

@end

