@import <Foundation/CPObject.j>
@import "../Common/ServicesNotifications.j"
@import "./WSRequestJob.j"
@import "../Requests/WSUpdateVetupUser.j"
@import "../../Data/VetupUser.j"

@class DataManager;

@implementation WSUpdateVetupUserJob : WSRequestJob
{
    //Input request parameter
//    JSObject _value;
    CPDictionary _value;
    VetupUser _vetupUser;
}

- (id)init
{
//  CPLog.info(@">>>> Entering WSGetCRVUsersJob::INIT");
    if (self = [super initWithServiceNotification:WSUpdateVetupUserNotification])
    {

    }
    return self;
}

- (id)initWithParam:(JSObject)aValue user:(VetupUser)aVetupUser
{
    if (self = [self init])
    {
        _value = aValue;
        _vetupUser = aVetupUser;
    }
    return self;
}

// MARK: Job implementation

- (void)start
{
//  CPLog.info(@">>>> Entering WSGetCRVUsersJob::start ");
    var request = [[WSUpdateVetupUser alloc] init];

    [request setValue:_value];
    [request setVetupUser:_vetupUser];
    _request = request;

    [super start];
}

- (void)jobTerminated
{
//    CPLog.debug(@">>>> Entering WSGetReferenceDataJob::jobTerminated ");
    [super jobTerminated];
//  CPLog.info(@"<<<<< Leaving WSGetCRVUsersJob::jobTerminated ");
}

@end

