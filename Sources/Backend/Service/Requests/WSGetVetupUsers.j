@import <Foundation/CPObject.j>
@import "../Common/WSBaseRequest.j"
//@import "../../Data/EmailUser.j"

@global DataManager;

WSGetVetupUsersSubPath    = @"jsonconsole/sync"
WSGetVetupUsersFunction   = @"getVetupUsers"

@implementation WSGetVetupUsers : WSBaseRequest
{
    //Input request parameter
    CPNumber  _pageSize       @accessors(setter=setPageSize);
    CPNumber  _currentPage    @accessors(setter=setCurrentPage, getter=currentPage);


    //Output request parameter
    CPMutableDictionary     _data   @accessors(getter=getData);
    CPNumber  _nbLoadedUsers  @accessors(getter=loadedUsers);
    CPNumber  _totalUsers  @accessors(getter=totalUsers);
}

// MARK: Init/dealloc

- (id)init
{
    CPLog.info(@">>>> Entering WSGetVetupUsers::INIT");

    if (self = [super init])
    {
        _subpath = WSGetVetupUsersSubPath;
    }
    return self;
}


- (void)start
{
    CPLog.info(@">>>> Entering WSGetVetupUsers::start");

    _jsonObjectToPost =
            {
                "jsonrpc": "2.0",
                "method"                : WSGetVetupUsersFunction,
                "params"                : { "pageSize" : _pageSize, "currentPage" : _currentPage},
                "id"                    : GlobalIncrementalRequestId
            };

    [super start];
}

- (void)parseJSONResponse:(id)iResult
{
    CPLog.info(@">>>> Entering WSGetVetupUsers::parseJSONResponse: %@", iResult);

    [super parseJSONResponse:iResult];


//    if (WSNoError == self.error.code)
    if (nil == _error)
    {
        var data = iResult.data;

        if (data != nil)
        {
            _data = [CPMutableDictionary new];

            var vetupUsersJS = data.vetupUsers;

            if (vetupUsersJS != nil)
            {
                _nbLoadedUsers = [vetupUsersJS count];
                //On économise de la mémoire, on alimente _vetupUsers de DataManager
//                var vetupUsers = [[DataManager sharedManager] vetupUsersFromJSArray:vetupUsersJS];
                [[DataManager sharedManager] addVetupUsersFromJSArray:vetupUsersJS];
//                [_data setObject:vetupUsers forKey:"vetupUsers"];
            }
            _totalUsers = data.totalUsers
        }
    }
    else
    {
        CPLog.debug(@"===> WSGetVetupUsers::parseJSONResponse ERROR");
    }

    CPLog.info(@"<<<< Leaving  WSGetVetupUsers::parseJSONResponse");
}



@end
