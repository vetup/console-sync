@import <Foundation/CPObject.j>
@import "../Common/WSBaseRequest.j"
@import "../../Data/EmailUser.j"

@global DataManager;

WSDeleteCRVUserWithInvalidClinicIdSubPath    = @"jsonconsole/sync"
WSDeleteCRVUserWithInvalidClinicIdFunction   = @"deleteCRVUserWithInvalidClinicId"

@implementation WSDeleteCRVUserWithInvalidClinicId : WSBaseRequest
{
    CPMutableDictionary     _data                       @accessors(getter=getData);
    CPString                _userStat                   @accessors(getter=userStat);
    CPUInteger              _nbInvalidClinicId          @accessors(getter=nbInvalidClinicId);
}

// MARK: Init/dealloc

- (id)init
{
    CPLog.info(@">>>> Entering WSDeleteCRVUserWithInvalidClinicId::INIT");

    if (self = [super init])
    {
        _subpath = WSDeleteCRVUserWithInvalidClinicIdSubPath;
    }
    return self;
}


- (void)start
{
    CPLog.info(@">>>> Entering WSDeleteCRVUserWithInvalidClinicId::start");

    _jsonObjectToPost =
            {
                "jsonrpc": "2.0",
                "method"                : WSDeleteCRVUserWithInvalidClinicIdFunction,
                "params"                : {},
                "id"                    : GlobalIncrementalRequestId
            };

    [super start];
}

- (void)parseJSONResponse:(id)iResult
{
    CPLog.info(@">>>> Entering WSDeleteCRVUserWithInvalidClinicId::parseJSONResponse: %@", iResult);

    [super parseJSONResponse:iResult];


    if (WSNoError == self.error.code)
    {
        var data = iResult.data;

        if (data != nil)
        {
            _data = [CPMutableDictionary new];

            var emailUsersJS = data.emailUser;
            if (emailUsersJS != nil)
            {
                var emailUsers = [[DataManager sharedManager] emailUsersFromJSArray:emailUsersJS];
                [_data setObject:emailUsers forKey:"emailUsers"];
            }

            var invalidEmailUsersJS = data.invalidEmailUser;
            if (invalidEmailUsersJS != nil)
            {
                var invalidEmailUsers = [[DataManager sharedManager] emailUsersFromJSArray:invalidEmailUsersJS];
                [_data setObject:invalidEmailUsers forKey:"invalidEmailUsers"];
            }

            _userStat           = data.userStat;
            _nbInvalidClinicId  = data.nbInvalidClinicId;
        }
    }
    else
    {
        CPLog.debug(@"<<<< TESTON !! PAS OK");
    }

    CPLog.info(@"<<<< Leaving  WSDeleteCRVUserWithInvalidClinicId::parseJSONResponse");
}



@end
