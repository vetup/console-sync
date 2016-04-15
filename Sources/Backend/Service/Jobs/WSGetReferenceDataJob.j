@import <Foundation/CPObject.j>
@import "../Common/ServicesNotifications.j"
@import "./WSRequestJob.j"
@import "../Requests/WSGetReferenceData.j"

@class DataManager;

@global KObjectTypeColor;
@global KObjectTypeSpecieAndBreed;


@implementation WSGetReferenceDataJob : WSRequestJob
{
    CPString        _objectType;
}

- (id)init
{
    CPLog.info(@">>>> Entering WSGetReferenceDataJob::INIT");

    if (self = [super initWithServiceNotification:@""])
    {

    }
    return self;
}



- (id)initWithObjectType:(CPString)objectType
{
    CPLog.info(@">>>> Entering WSGetReferenceDataJob::INIT initWithObjectType");

    if (self = [self init])
    {
        _objectType    = objectType;

        var notification =@"";

        switch (_objectType)
        {
            case KObjectTypeColor:          notification = WSGetColorsReferenceDataNotification;            break;
            case KObjectTypeSpecieAndBreed: notification = WSGetSpeciesAndBreedsReferenceDataNotification;  break;
        }

        _serviceNotification = notification;

    }
    return self;
}


// MARK: Job implementation

- (void)start
{
    CPLog.info(@">>>> Entering WSGetReferenceDataJob::start ");

    var request = [[WSGetReferenceData alloc] init];

    [request setObjectType:_objectType];

    _request = request;

    [super start];
}

- (void)jobTerminated
{
//    CPLog.debug(@">>>> Entering WSGetReferenceDataJob::jobTerminated ");


    if (KObjectTypeColor == _objectType)
    {
        var colors = [[_request getData] objectForKey:"colors"];
        [[DataManager sharedManager] setColors:colors];
    }
    else if (KObjectTypeSpecieAndBreed == _objectType)
    {
        var species = [[_request getData] objectForKey:"species"];
        [[DataManager sharedManager] setSpecies:species];

        var breeds = [[_request getData] objectForKey:"breeds"];
        [[DataManager sharedManager] setBreeds:breeds];
    }


    [super jobTerminated];


    CPLog.info(@"<<<<< Leaving WSGetReferenceDataJob::jobTerminated ");

}

@end
