@import <Foundation/CPObject.j>
@import "../Common/WSBaseRequest.j"
@import "../../Data/EmailUser.j"
@import "../../../Categories/json/CPArray_CPJSONAware.j"

@class DataManager;

WSMergeCRVUsersSubPath    = @"jsonconsole/sync"
WSMergeCRVUsersFunction   = @"mergeCRVUsers"

@implementation WSMergeCRVUsers : WSBaseRequest
{
    //Input request parameter
    CPMutableArray         _emails         @accessors(setter=setEmails);

    //Output request parameter
    CPMutableDictionary    _data           @accessors(getter=getData);
}

// MARK: Init/dealloc

- (id)init
{
    CPLog.info(@">>>> Entering WSMergeCRVUsers::INIT");

    if (self = [super init])
    {
        _subpath = WSMergeCRVUsersSubPath;
    }
    return self;
}


- (void)start
{
    CPLog.info(@">>>> Entering WSMergeCRVUsers::start");

    var emailsJS    = [_emails toJSObject],
        jsonStr     = [CPString JSONFromObject:emailsJS];

    _jsonObjectToPost =
            {
                "jsonrpc": "2.0",
                "method"                : WSMergeCRVUsersFunction,
                "params"                : {"emails":jsonStr},
                "id"                    : GlobalIncrementalRequestId
            };

    [super start];
}

- (void)parseJSONResponse:(id)iResult
{
    CPLog.info(@">>>> Entering WSMergeCRVUsers::parseJSONResponse: %@", iResult);

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

    CPLog.info(@"<<<< Leaving  WSMergeCRVUsers::parseJSONResponse");
}



@end
