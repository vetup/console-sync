@import <Foundation/CPObject.j>
@import "../Common/WSBaseRequest.j"
@import "../../Data/EmailUser.j"

@global DataManager;

WSGetCRVUsersSubPath    = @"jsonconsole/sync"
WSGetCRVUsersFunction   = @"getCRVUsers"

@implementation WSGetCRVUsers : WSBaseRequest
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
    CPLog.info(@">>>> Entering WSGetCRVUsers::INIT");

    if (self = [super init])
    {
        _subpath = WSGetCRVUsersSubPath;
    }
    return self;
}


- (void)start
{
    CPLog.info(@">>>> Entering WSGetCRVUsers::start");

    _jsonObjectToPost =
            {
                "jsonrpc": "2.0",
                "method"                : WSGetCRVUsersFunction,
                "params"                : {},
                "id"                    : GlobalIncrementalRequestId
            };

    [super start];
}

- (void)parseJSONResponse:(id)iResult
{
    CPLog.info(@">>>> Entering WSGetCRVUsers::parseJSONResponse: %@", iResult);

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


            //Unique users
            var uniqueUsersJS = data.uniqueUsers.uniqueUsers;
//            var uniqueUsersJS = data.uniqueUsers;

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

    CPLog.info(@"<<<< Leaving  WSGetCRVUsers::parseJSONResponse");
}



@end
