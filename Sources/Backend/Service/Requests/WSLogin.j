@import <Foundation/CPObject.j>
@import "../Common/WSBaseRequest.j"

//WSLoginSubPath    = @"restmessagebroker/admin"
//WSLoginFunction   = @"login"
WSLoginSubPath    = @"jsonconsole/sync"
WSLoginFunction   = @"login"

//ne pas faire d'include de UserManager car import cyclique ! (UserManager import WSLoginJob->WSLogin)
@class UserManager;

@implementation WSLogin : WSBaseRequest
{
    //Input request parameter
    CPString        _email       @accessors(setter=setEmail);
    CPString        _password    @accessors(setter=setPassword);

    //Output request parameter
    CPString        _uid        @accessors(getter=getUid);
    CPString        _name       @accessors(getter=getName);
    CPString        _role       @accessors(getter=getRole);

}

// MARK: Init/dealloc

- (id) init
{
    CPLog.info(@">>>> Entering WSLogin::INIT");

    if (self = [super init])
    {
        _subpath = WSLoginSubPath;
    }
    return self;
}


- (void) start
{
    //  urlAddress = @"DUMMYhttp://eussam.hd.free.fr:8080/vcc/bin-debug/restmessagebroker/rest/?method=getUserByEmailAndPass&arg1=Toto&arg2=Tata";

    CPLog.info(@">>>> Entering WSLogin::start");

    _jsonObjectToPost =
            {
                "jsonrpc": "2.0",
                "method"                : WSLoginFunction,
                "params"                : { "email" : _email, "password" : _password },
                "id"                    : WSLoginFunction //PF: 03/12/2013 - je met le nom de la fonction en id, à voir...
            };

    [super start];
}

- (void) parseJSONResponse:(id)iResult
{
    CPLog.info(@">>>> Entering WSLogin::parseJSONResponse: %@", iResult);

    [super parseJSONResponse:iResult];

    if (WSNoError == self.error.code)
    {
        var data = iResult.data;
        _uid = data.uid;
        _name = data.name;
        _role = data.role;

        CPLog.debug(@" WSLogin: Role: %@  Name: %@", self._role, self._name);
    }
    else
    {
        CPLog.debug(@"<<<< TESTON !! PAS OK");

    }

    //TODO: parser les data, cf ci dessous en ios

    CPLog.info(@"<<<< Leaving  WSLogin::parseJSONResponse");
}


@end
