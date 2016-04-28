
@import <Foundation/CPObject.j>

@import "./WSError.j"
@import "./WSUtils.j"

@import "../../Managers/ErrorManager.j"


@implementation EDRequest : CPObject
{
    WSError _error  @accessors(property=error);
    CPURLRequest _URL;
    Object _jsonObjectToPost;
    CPDictionary _queryInfo;
    id _delegate  @accessors(setter=setDelegate);


//ServerConnection
    CPString        _accumulatedResponseString;
    int             _statusCode;
    int             _responsesCount;
    CPTimer         _timerTimeoutWaitingResponse;
    CPURLConnection _urlConnection;
    int             _timeoutInSeconds;

    CPString        _id @accessors(readonly, property=id);
}

#pragma mark -
#pragma mark Init/Dealloc


- (id) init
{
    if ( self = [super init] )
    {
        [self setDefaultTimeout];
    }
    return self;
}


#pragma mark -
#pragma mark Other

// works only for new requests. Old processing will use old value.
-(void)setTimeout:(int)timoutInSeconds
{
    _timeoutInSeconds = timoutInSeconds;
}

-(void)setDefaultTimeout
{
//    _timeoutInSeconds = 35;
    _timeoutInSeconds = 35*20;  //MES TEST SUR LES IMPORTS QUI PRENNENT DU TEMPS
}


- (void) start
{
//     CPLog.info(@">>>> Entering EDRequest::start");
    [self _start];
}


- (void) _start
{
    if (_queryInfo != nil)
    {
        var newUrl = [self _appendQueryToURL:self.URL andQueryInfo:_queryInfo];
        _URL = newUrl;

        CPLog.info(@"EDRequest: _start query: NSURL: %@", _URL);
    }

    _statusCode = 0;
    _responsesCount = 0;


    if (!_urlConnection)
        [_urlConnection cancel];
    if (!_timerTimeoutWaitingResponse)
        [_timerTimeoutWaitingResponse invalidate]; //stop

    var request = [[CPURLRequest alloc] initWithURL:_URL]; // TODO: need add random subparameter to avoid caching ?

    //PF: 07/02/2014 - enlever des headers éventuels chiants pour ne pas générer un appel OPTIONS au lieu de POST réalisé par le browser dans le cadre de CORS (cross domain)
    //cf :   https://groups.google.com/forum/#!topic/objectivej/zuQOLruJECE
    [[request allHTTPHeaderFields] removeAllObjects];

//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//- (void) setValue:      (CPString)  aValue
//forHTTPHeaderField:     (CPString)  aField


    [request setHTTPMethod:@"POST"];

    [request setHTTPBody:[CPString JSONFromObject:_jsonObjectToPost]];

    // This require a lot of memory - a new timer for each request! But there is no good way to solve Firefox issue with URLConnection and POST command which is not return responce 200 from first time, which can be 0 (NS_BINDING_ABORTED). (See more comments in function connectionDidFinishLoading above).
    _timerTimeoutWaitingResponse = [CPTimer scheduledTimerWithTimeInterval:_timeoutInSeconds  // timeout in seconds to raise timeout (_errorSelector).
                                     target:self
                                   selector:@selector(timerTimeoutWaitingResponseTick:)
                                   userInfo:nil
                                    repeats:NO];

    _urlConnection = [CPURLConnection connectionWithRequest:request delegate:self];
}


- (CPString)_paramStringFromDic:(CPDictionary)dic
{
    var getParametersString = @"",
        allKeys = [dic allKeys];

    for (var i = 0; i <  [allKeys count]; i++)
    {
        var aKey = [allKeys objectAtIndex:i],
            encodedStr = [dic valueForKey:aKey];

        getParametersString = [getParametersString stringByAppendingString:[CPString stringWithFormat:@"&%@=%@", aKey, encodedStr]];
    }

    return [getParametersString substringFromIndex:1];
}


//Append param to URL
- (CPURL)_appendQueryToURL: (CPURL)url andQueryInfo: (CPDictionary) query
{
    var getParametersString = @"";

    var urlStr = [_URL absoluteString];

    getParametersString = [self _paramStringFromDic:query];

   // NSLog(@"--- _appendQueryToURL: %@", getParametersString);

    var absoluteURL = [CPURL URLWithString:[CPString stringWithFormat:@"%@?%@", urlStr, getParametersString]];
//    NSURL * absoluteURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", urlStr, getParametersString]];

    return absoluteURL;
}


#pragma mark -
#pragma mark CPURLConnecion
- (void)connection:(CPURLConnection)connection didFailWithError:(id)aError
{
    // appelé quand j'ai un timout côté serveur
//     CPLog.error(@"PHIL3 CONNECTION failed");
    _error = [[ErrorManager sharedManager] errorWithCodeAndDomain:WSInternetError domain:WSInternetErrorDomain];

    var desc = [CPString stringWithFormat:@"name: %@  message: %@", aError.name, aError.message];
    [_error setDesc:desc];

    CPLog.error(@"EDRequest:: didFailWithError %@", aError);

    [_delegate EDRequest_finished:self];
}

- (void)connection:(CPURLConnection)connection didReceiveResponse:(CPHTTPURLResponse)response
{
    _responsesCount = _responsesCount + 1;
    _accumulatedResponseString = [[CPString alloc] initWithString:@""];
    _statusCode = [response statusCode];
    if (_statusCode != 0)
    {
        // We got response, stop the timeout timer:
        [_timerTimeoutWaitingResponse invalidate]; //stop
    }
}

-(void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
    // We accumulate through several (possible) calls of didReceiveData
    _accumulatedResponseString = [_accumulatedResponseString stringByAppendingString:data];
//        CPLog.debug(@"PHIL1 : %@", _accumulatedResponseString);
}

-(void)connectionDidFinishLoading:(CPURLConnection)connection
{
   //  CPLog.debug(@"---- ENTERING  EDRequest connectionDidFinishLoading");

    // This is FIX for firefox (when calling URLConnection, first response is with status 0 and with useless didReceiveData and connectionDidFinishLoading calls.
    // Note that if _statusCode == 0 this not means error in Firefox. This means nothing, perhaps there is will be another response soon...
    // But in all browsers 0 means that current data is not a data. In WebKit
    // if 0 of course this means error in connection. In Firefox this means nothing.
    if (_statusCode == 0)
        return;

    // calling event of data did recieved
    if (_delegate)
    {
        try
        {
            var jsObject = [_accumulatedResponseString objectFromJSON];

            //on extrait le result de la requete
            var result = jsObject.result;

            //PF: 9/12/2015 - id de la requête
            _id = jsObject.id;

            //On parse la requête pas WSBaseRequest pour traiter le code d'erreur
            [self parseJSONResponse:result];

            [_delegate EDRequest_finished:self];
        }
        catch(e)
        {
            _error = [[ErrorManager sharedManager] errorWithCodeAndDomain:WSInternetError domain:WSInternetErrorDomain];
            [_error setDesc:e.message];
            CPLog.error(@"---- EDRequest connectionDidFinishLoading EXCEPTION: %@", e);
            [_delegate EDRequest_finished:self];
        }

    }

    // didn't help in firefox, still twice called connectionDidFinishLoading.
    [_urlConnection cancel];
}

- (void)timerTimeoutWaitingResponseTick:(var)anParam
{
    [_urlConnection cancel];
    if (_delegate)
    {
        CPLog.debug(@"---- ENTERING  EDRequest timerTimeoutWaitingResponseTick");
        _error = [[ErrorManager sharedManager] errorWithCodeAndDomain:WSInternetError domain:WSInternetErrorDomain];
        //objj_msgSend(_delegate, @selector(EDRequest_finished:), self, nil);
        [_delegate EDRequest_finished:self];
    }
}



/*
 * "aError" is a selector which will be called when connection is failed,
 * for example if remote server is not responding. So it will be called, when
 * ServerConnection failed to "call" requested "function" from server.
 */

/*
- (void) _callRemoteFunction:(CPString)functionNameToCall withFunctionParametersAsObject:functionParametersInObject delegate:(id)aDelegate didEndSelector:(SEL)aSelector error:(SEL)aError
{
    //CPLogConsole(functionNameToCall);
    _statusCode = 0;
    _responsesCount = 0;
    _delegate = aDelegate;

   _didEndSelector = aSelector;
    _errorSelector = aError;

    if (!_urlConnection)
        [_urlConnection cancel];
    if (!_timerTimeoutWaitingResponse)
        [_timerTimeoutWaitingResponse invalidate]; //stop

//localhost:8080/vccadmin/public/restmessagebroker/user


//?method=iPad_login&arg1=philippe.fuentes@gmail.com&arg3=88ba35b7b89cf29e4d6edd9f8ef7ffe229aa88b1&arg2=test&target=DWR_IPAD&version=DI%201.0.0
//?method=admin_login&arg1=philippe.fuentes@gmail.com&arg2=test&target=ADMIN_WEB&version=1.0.0
var urlStr = "http://localhost:8080/vccadmin/restmessagebroker/user?";
//urlStr += "method=admin_login&arg1=philippe.fuentes@gmail.com&arg2=test&target=ADMIN_WEB&version=1.0.0";
urlStr += "&DBGSESSID=1";

    var request = [[CPURLRequest alloc] initWithURL:urlStr]; // TODO: need add random subparameter to avoid caching ?

    [request setHTTPMethod:@"POST"];

    var jsonObjectToPost =
            {
                "jsonrpc": "2.0",
                "method"                : functionNameToCall,
                "params"                : functionParametersInObject,
                "id"                    : functionNameToCall //PF: 03/12/2013 - je met le nom de la fonction en id, à voir...
            };

    [request setHTTPBody:[CPString JSONFromObject:jsonObjectToPost]];

    // This require a lot of memory - a new timer for each request! But there is no good way to solve Firefox issue with URLConnection and POST command which is not return responce 200 from first time, which can be 0 (NS_BINDING_ABORTED). (See more comments in function connectionDidFinishLoading above).
    _timerTimeoutWaitingResponse = [CPTimer scheduledTimerWithTimeInterval:_timeoutInSeconds  // timeout in seconds to raise timeout (_errorSelector).
                                     target:self
                                   selector:@selector(timerTimeoutWaitingResponseTick:)
                                   userInfo:nil
                                    repeats:NO];

    _urlConnection = [CPURLConnection connectionWithRequest:request delegate:self];

   // [_urlConnection start]; // No need to call start, it is already started after creation
}
*/
@end
