@import <Foundation/CPObject.j>
@import "../Common/ServicesNotifications.j"
@import "./WSRequestJob.j"
@import "../Requests/WSDeleteReferenceData.j"


@implementation WSDeleteReferenceDataJob : WSRequestJob
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
    CPLog.info(@">>>> Entering WSDeleteReferenceDataJob::INIT initWithObject");

    if (self = [self init])
    {
        _object    = object;

        var className       = [_object className],
            notification    = @"";

        switch (className)
        {
            case "Color":         notification = WSDeleteColorReferenceDataNotification;      break;
            case "Specie":        notification = WSDeleteSpecieReferenceDataNotification;     break;
            case "Breed":         notification = WSDeleteBreedReferenceDataNotification;      break;
        }

        _serviceNotification = notification;

    }
    return self;
}


// MARK: Job implementation

- (void)start
{
    CPLog.info(@">>>> Entering WSDeleteReferenceDataJob::start ");

    var request = [[WSDeleteReferenceData alloc] init];

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
