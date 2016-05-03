@import <Foundation/CPObject.j>
@import "../JobsManagement/Job.j"

@import "../Common/EDRequest.j"
@import "../Common/WSBaseRequest.j"

@import "../Common/WSError.j";

@import "../../Managers/ErrorManager.j";


@implementation WSRequestJob : Job
{
    WSError     _error @accessors(property=error);
    EDRequest   _request @accessors(getter=request);

    BOOL        _requestPerformed @accessors(property=requestPerformed);

    CPString    _serviceNotification;
}

- (id)initWithServiceNotification:(CPString)serviceNotification
{
//    CPLog.info(@">>>> Entering WSRequestJob::initWithServiceNotification");

    if (self = [super init])
    {
        _serviceNotification = serviceNotification;
        _requestPerformed = YES;
    }
    return self;
}

// MARK: Job implementation

- (void)start
{
 //   CPLog.info(@">>> Entering WSRequestJob::start <<");

    [super start];

   // CPLog.info(@">>>>>>>>> WSRequestJob::start  request: %@: ", _request);

    _requestPerformed = NO;
    [_request setDelegate:self];
    [_request start];

    //CPLog.info(@"<<< Leaving WSRequestJob::start<<<");
}

- (void)cancel
{
    [super cancel];

    if (!_requestPerformed )
    {
        [_request cancel];
    }
}

- (void)jobTerminated
{
 //   CPLog.info(@">>> Entering  WSRequestJob::jobTerminated  %@ <<<", self.error.domain);

    [super jobTerminated];

    //PF: 4/06/2013 - on a précisé qu'on ne veut pas traiter les erreurs sur une requête avec isErrorToBeProcessed à FALSE
    //mis en place pour les envoie de stat, on voulait pas être dérangé en cas d'erreur


// [[CPNotificationCenter defaultCenter] postNotificationName:_serviceNotification object:self userInfo:userInfo];
// return;

    try
    {
        //Si l'erreur n'est pas vetup, on l'affiche ici, c'est que c'est grave:)
        if ((_error != nil) && ![[_error domain] isEqual:WSVetupErrorDomain])
        {
            [[ErrorManager sharedManager] presentError:_error];
        }
        var userInfo = [[CPMutableDictionary alloc] init];

        if ((_error != nil) && (![[_error code] isEqualToString:WSNoError]))
        {
            [userInfo setObject:_error forKey:ServicesErrorKey];
        }
        [userInfo setObject:self forKey:ServicesJobKey];

        [[CPNotificationCenter defaultCenter] postNotificationName:_serviceNotification object:self userInfo:userInfo];
    }
    catch (e)
    {
        CPLog.error("WSRequestJob::jobTerminated: " + e);
    }

}

// MARK: VSRequest Delegate

//PF VCC


- (void)EDRequest_finished:(EDRequest)request
{
   // CPLog.info(@">>> Entering  WSRequestJob::EDRequest_finished : %@ <<<", request);

    self.requestPerformed = YES;

    _error = [request error];

    [self jobTerminated];

//    CPLog.debug(@"<<< Leaving WSRequestJob::EDRequest_finished ID: %@", [request id]);
}

@end
