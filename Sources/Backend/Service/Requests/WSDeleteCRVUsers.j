@import <Foundation/CPObject.j>
@import "../Common/WSBaseRequest.j"
@import "../../Data/EmailUser.j"
@import "../../../Categories/json/CPArray_CPJSONAware.j"

@class DataManager;

WSDeleteCRVUsersSubPath    = @"jsonconsole/sync"
WSDeleteCRVUsersFunction   = @"deleteCRVUsers"

@implementation WSDeleteCRVUsers : WSBaseRequest
{
    //Input request parameter
    CPMutableArray         _emails         @accessors(setter=setEmails);

    //Output request parameter
    CPMutableDictionary    _data           @accessors(getter=getData);
}

// MARK: Init/dealloc

- (id)init
{
    CPLog.info(@">>>> Entering WSDeleteCRVUsers::INIT");

    if (self = [super init])
    {
        _subpath = WSDeleteCRVUsersSubPath;
    }
    return self;
}


- (void)start
{
    CPLog.info(@">>>> Entering WSDeleteCRVUsers::start");

    var emailsJS    = [_emails toJSObject],
        jsonStr     = [CPString JSONFromObject:emailsJS];

    _jsonObjectToPost =
            {
                "jsonrpc": "2.0",
                "method"                : WSDeleteCRVUsersFunction,
                "params"                : {"emails":jsonStr},
                "id"                    : GlobalIncrementalRequestId
            };

    [super start];
}

- (void)parseJSONResponse:(id)iResult
{
    CPLog.info(@">>>> Entering WSDeleteCRVUsers::parseJSONResponse: %@", iResult);

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

            var invlidEmailUsersJS = data.invalidEmailUser;
            if (invlidEmailUsersJS != nil)
            {
                var invalidEmailUsers = [[DataManager sharedManager] emailUsersFromJSArray:invlidEmailUsersJS];
                [_data setObject:invalidEmailUsers forKey:"invalidEmailUsers"];
            }
        }
    }
    else
    {
        CPLog.debug(@"<<<< TESTON !! PAS OK");

    }

    CPLog.info(@"<<<< Leaving  WSDeleteCRVUsers::parseJSONResponse");
}



@end
