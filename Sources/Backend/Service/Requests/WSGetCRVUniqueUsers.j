@import <Foundation/CPObject.j>
@import "../Common/WSBaseRequest.j"
@import "../../Data/EmailUser.j"

@global DataManager;

WSGetCRVUniqueUsersSubPath    = @"jsonconsole/sync"
WSGetCRVUniqueUsersFunction   = @"getCRVUniqueUsers"

@implementation WSGetCRVUniqueUsers : WSBaseRequest
{
    //Input request parameter
//    CPString            _objectType     @accessors(setter=setObjectType);

    //Output request parameter
    CPMutableDictionary     _data                       @accessors(getter=getData);
    CPString                _userStat                   @accessors(getter=userStat);
    CPUInteger              _nbInvalidClinicId          @accessors(getter=nbInvalidClinicId);
}

// MARK: Init/dealloc

- (id)init
{
    CPLog.info(@">>>> Entering WSGetCRVUniqueUsers::INIT");

    if (self = [super init])
    {
        _subpath = WSGetCRVUniqueUsersSubPath;
    }
    return self;
}


- (void)start
{
    CPLog.info(@">>>> Entering WSGetCRVUniqueUsers::start");

    _jsonObjectToPost =
            {
                "jsonrpc": "2.0",
                "method"                : WSGetCRVUniqueUsersFunction,
                "params"                : {},
                "id"                    : GlobalIncrementalRequestId
            };

    [super start];
}

- (void)parseJSONResponse:(id)iResult
{
    CPLog.info(@">>>> Entering WSGetCRVUniqueUsers::parseJSONResponse: %@", iResult);

    [super parseJSONResponse:iResult];


//    if (WSNoError == self.error.code)
    if (nil == _error)
    {
        var data = iResult.data;

        if (data != nil)
        {
            _data = [CPMutableDictionary new];

            var uniqueUsersJS = data.uniqueUsers;

            if (uniqueUsersJS != nil)
            {
                var uniqueUsers = [[DataManager sharedManager] uniqueUsersFromJSArray:uniqueUsersJS];
                [_data setObject:uniqueUsers forKey:"uniqueUsers"];

                //On construit une map de uniqueUsers, utile pour l'affichage de la colonne (isMerged)
                var uniqueUsersMap = [CPMutableDictionary new];
                for (var i = 0; i < [uniqueUsers count]; i++)
                {
                    var uniqueUser  = uniqueUsers[i],
                        email       = [uniqueUser email];
                    [uniqueUsersMap setObject:uniqueUser forKey:email];
                }

                 [_data setObject:uniqueUsersMap forKey:"uniqueUsersMap"];
            }
        }
    }
    else
    {
        CPLog.debug(@"<<<< TESTON !! PAS OK");
    }

    CPLog.info(@"<<<< Leaving  WSGetCRVUniqueUsers::parseJSONResponse");
}



@end
