@import <Foundation/CPObject.j>
@import "../Common/ServicesNotifications.j"
@import "./WSRequestJob.j"
@import "../Requests/WSLogin.j"

//!!!!!!!!!!!!!!!!!!!!!!!!
//Circular dependancy !! je peux pas appelé UserManager ici , qui lui même utilise WSLoginJob via RequestManager
//Using unknown class or uninitialized global variable 'UserManager'

@implementation WSLoginJob : WSRequestJob
{
    CPString        _email;
    CPString        _password;
}

- (id) init
{
    CPLog.info(@">>>> Entering WSLoginJob::INIT");

    if ( self = [super initWithServiceNotification:WSLoginNotification] )
    {

    }
    return self;
}


- (id) initWithEmail:(CPString)email password:(CPString)password
{
    CPLog.info(@">>>> Entering WSLoginJob::INIT initWithEmail");

    if ( self = [self init] )
    {
        _email    = email;
        _password = password;

        CPLog.info(@">>>> Entering WSLoginJob::INIT EMAIL: %@", _email);
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
    CPLog.info(@">>>> Entering WSLoginJob::start ");

    var loginRequest = [[WSLogin alloc] init];

    [loginRequest setEmail:_email];
    [loginRequest setPassword:_password];

    _request = loginRequest;

    [super start];
}

- (void) jobTerminated
{
//    CPLog.debug(@">>>> Entering WSLoginJob::jobTerminated ");

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
