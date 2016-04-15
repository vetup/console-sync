@import <Foundation/CPObject.j>
@import "../Common/ServicesNotifications.j"
@import "./WSRequestJob.j"
@import "../Requests/WSAnalyseReferenceData.j"


@global KObjectTypeColor;
@global KObjectTypeSpecieAndBreed;

@implementation WSAnalyseReferenceDataJob : WSRequestJob
{
    CPString        _objectType;
}

- (id)init
{
    CPLog.info(@">>>> Entering WSAnalyseReferenceDataJob::INIT");

    if (self = [super initWithServiceNotification:@""])
    {

    }
    return self;
}



- (id)initWithObjectType:(CPString)objectType
{
    CPLog.info(@">>>> Entering WSAnalyseReferenceDataJob::INIT initWithObjectType");

    if (self = [self init])
    {
        _objectType    = objectType;

        var notification =@"";

        switch (_objectType)
        {
            case KObjectTypeColor:          notification = WSAnalyseColorsReferenceDataNotification;            break;
            case KObjectTypeSpecieAndBreed: notification = WSAnalyseSpeciesAndBreedsReferenceDataNotification;  break;
        }

        _serviceNotification = notification;
    }
    return self;
}


// MARK: Job implementation

- (void)start
{
    CPLog.info(@">>>> Entering WSAnalyseReferenceDataJob::start ");

    var request = [[WSAnalyseReferenceData alloc] init];

    [request setObjectType:_objectType];

    _request = request;

    [super start];
}

- (void)jobTerminated
{

    [super jobTerminated];

//    CPLog.info(@"<<<<< Leaving WSAnalyseReferenceDataJob::jobTerminated ");
}

@end
