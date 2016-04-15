@import <Foundation/CPObject.j>
@import "../Common/ServicesNotifications.j"
@import "./WSRequestJob.j"
@import "../Requests/WSDeleteCRVUserWithInvalidClinicId.j"

@class DataManager;


@implementation WSDeleteCRVUserWithInvalidClinicIdJob : WSRequestJob
{
}

- (id)init
{
//    CPLog.info(@">>>> Entering WSGetCRVUsersJob::INIT");

    if (self = [super initWithServiceNotification:WSDeleteCRVUserWithInvalidClinicIdNotification])
    {

    }
    return self;
}



// MARK: Job implementation

- (void)start
{
//    CPLog.info(@">>>> Entering WSGetCRVUsersJob::start ");

    var request = [[WSDeleteCRVUserWithInvalidClinicId alloc] init];
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

    [[DataManager sharedManager] refreshIsMerged];

    [super jobTerminated];

//    CPLog.info(@"<<<<< Leaving WSGetCRVUsersJob::jobTerminated ");
}

@end
