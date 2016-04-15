@import <Foundation/CPObject.j>
@import "../Common/ServicesNotifications.j"
@import "./WSRequestJob.j"
@import "../Requests/WSAddReferenceData.j"


@implementation WSAddReferenceDataJob : WSRequestJob
{
    CPObject        _object;
}

- (id)init
{
//    CPLog.info(@">>>> Entering WSAddReferenceDataJob::INIT");
    if (self = [super initWithServiceNotification:@""])
    {

    }
    return self;
}

- (id)initWithObject:(CPObject)object
{
    CPLog.info(@">>>> Entering WSAddReferenceDataJob::INIT initWithObject");

    if (self = [self init])
    {
        _object    = object;

        var className       = [_object className],
            notification    = @"";

        switch (className)
        {
            case "Color":         notification = WSAddColorReferenceDataNotification;      break;
            case "Specie":        notification = WSAddSpecieReferenceDataNotification;     break;
            case "Breed":         notification = WSAddBreedReferenceDataNotification;      break;
        }

        _serviceNotification = notification;
    }
    return self;
}


// MARK: Job implementation

- (void)start
{
    CPLog.info(@">>>> Entering WSAddReferenceDataJob::start ");

    var request = [[WSAddReferenceData alloc] init];

    [request setObject:_object];

    _request = request;

    [super start];
}

- (void)jobTerminated
{
//    CPLog.debug(@">>>> Entering WSTestWSJob::jobTerminated ");

    [super jobTerminated];

//    CPLog.info(@"<<<<< Leaving WSLoginJob::jobTerminated ");

}

@end
