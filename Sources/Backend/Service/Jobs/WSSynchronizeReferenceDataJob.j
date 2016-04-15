@import <Foundation/CPObject.j>
@import "../Common/ServicesNotifications.j"
@import "./WSRequestJob.j"
@import "../Requests/WSSynchronizeReferenceData.j"


@implementation WSSynchronizeReferenceDataJob : WSRequestJob
{
    CPString        _objectType;
}

- (id)init
{
    CPLog.info(@">>>> Entering WSSynchronizeReferenceDataJob::INIT");

    if (self = [super initWithServiceNotification:@""])
    {

    }
    return self;
}



- (id)initWithObjectType:(CPString)objectType
{
    CPLog.info(@">>>> Entering WSSynchronizeReferenceDataJob::INIT initWithObjectType");

    if (self = [self init])
    {
        _objectType    = objectType;

        var notification =@"";

        switch (_objectType)
        {
            case KObjectTypeColor:          notification = WSSynchronizeColorsReferenceDataNotification;            break;
            case KObjectTypeSpecieAndBreed: notification = WSSynchronizeSpeciesAndBreedsReferenceDataNotification;  break;
        }

        _serviceNotification = notification;
    }
    return self;
}


// MARK: Job implementation

- (void)start
{
    CPLog.info(@">>>> Entering WSSynchronizeReferenceDataJob::start ");

    var request = [[WSSynchronizeReferenceData alloc] init];

    [request setObjectType:_objectType];

    _request = request;

    [super start];
}

- (void)jobTerminated
{
//    CPLog.debug(@">>>> Entering WSGetReferenceDataJob::jobTerminated ");
   //var uid = [_request getUid];

/*
    if (uid != nil)
    {
        //Interdit ! circular dependancy !! (voir commentaire en début de fichier)
        //[[UserManager sharedManager] setUid: uid];
    }
*/

/*
    WSLogin * request = (WSLogin *)self.request;

    UserManager *manager = [UserManager sharedManager];
    if (nil != request.uid)
    {
        manager.uid = request.uid;
    }

    if (nil != request.orders)
    {
        manager.orders = request.orders;
    }

    if (nil != request.name)
    {
        manager.name = request.name;
    }

    manager.isVirbacBranded = request.isVirbacBranded;
*/

    [super jobTerminated];


    CPLog.info(@"<<<<< Leaving WSSynchronizeReferenceDataJob::jobTerminated ");

}

@end
