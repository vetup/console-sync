@import <Foundation/CPObject.j>
@import "../Common/ServicesNotifications.j"
@import "./WSRequestJob.j"
@import "../Requests/WSUpdateReferenceData.j"


@implementation WSUpdateReferenceDataJob : WSRequestJob
{
    CPObject        _object;
}

- (id)init
{
//    if (self = [super initWithServiceNotification:WSUpdateReferenceDataNotification])
    if (self = [super initWithServiceNotification:@""])
    {

    }
    return self;
}



- (id)initWithObject:(CPObject)object
{
    CPLog.info(@">>>> Entering WSUpdateReferenceDataJob::INIT initWithObject");

    if (self = [self init])
    {
        _object    = object;

        var className       = [_object className],
            notification    = @"";

        switch (className)
        {
            case "ColorUpdate":         notification = WSUpdateColorReferenceDataNotification;      break;
            case "SpecieUpdate":        notification = WSUpdateSpecieReferenceDataNotification;     break;
            case "BreedUpdate":         notification = WSUpdateBreedReferenceDataNotification;      break;
        }

        _serviceNotification = notification;
    }
    return self;
}


// MARK: Job implementation

- (void)start
{
//    CPLog.info(@">>>> Entering WSUpdateReferenceDataJob::start ");

    var request = [[WSUpdateReferenceData alloc] init];

    [request setObject:_object];

    _request = request;

    [super start];
}

- (void)jobTerminated
{
    [super jobTerminated];
}

@end
