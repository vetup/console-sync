@import <Foundation/CPObject.j>
@import "../Common/ServicesNotifications.j"
@import "./WSRequestJob.j"
@import "../Requests/WSTestWS.j"

//!!!!!!!!!!!!!!!!!!!!!!!!
//Circular dependancy !! je peux pas appelé UserManager ici , qui lui même utilise WSLoginJob via RequestManager
//Using unknown class or uninitialized global variable 'UserManager'

@implementation WSTestWSJob : WSRequestJob
{
    CPString        _method;
}

- (id) init
{
    CPLog.info(@">>>> Entering WSTestWSJob::INIT");

    if ( self = [super initWithServiceNotification:WSTestWSNotification])
    {

    }
    return self;
}



- (id) initWithFunction:(CPString)method
{
    CPLog.info(@">>>> Entering WSLoginJob::INIT initWithFunction");

    if ( self = [self init] )
    {
        _method    = method;
    }
    return self;
}

/*
- (void) dealloc
{
    [_email     release];
    _email = nil;
    [_password  release];
    _password = nil;

    [super dealloc];
}*/

// MARK: Job implementation

- (void) start
{
    CPLog.info(@">>>> Entering WSTestWSJob::start ");

    var request = [[WSTestWS alloc] init];

    [request setFunction:_method];

    _request = request;

    [super start];
}

- (void) jobTerminated
{
//    CPLog.debug(@">>>> Entering WSTestWSJob::jobTerminated ");

    var uid = [_request getUid];

    if (uid != nil)
    {
        //Interdit ! circular dependancy !! (voir commentaire en début de fichier)
        //[[UserManager sharedManager] setUid: uid];
    }


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


    CPLog.info(@"<<<<< Leaving WSLoginJob::jobTerminated ");

}

@end
