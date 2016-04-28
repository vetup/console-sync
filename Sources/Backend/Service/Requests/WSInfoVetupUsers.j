@import <Foundation/CPObject.j>
@import "../Common/WSBaseRequest.j"
@import "../../../Categories/json/CPArray_CPJSONAware.j"

@class DataManager;

WSInfoVetupUsersSubPath    = @"jsonconsole/sync"
WSInfoVetupUsersFunction   = @"infoVetupUsers"

@implementation WSInfoVetupUsers : WSBaseRequest
{
    //Input request parameter
    CPMutableArray         _ids   @accessors(setter=setIds);

    //Output request parameter
    //CPMutableDictionary    _data           @accessors(getter=getData);
    CPString _info  @accessors(getter=info);
}

// MARK: Init/dealloc

- (id)init
{
    CPLog.info(@">>>> Entering WSInfoVetupUsers::INIT");

    if (self = [super init])
    {
        _subpath = WSInfoVetupUsersSubPath;
    }
    return self;
}


- (void)start
{
    CPLog.info(@">>>> Entering WSInfoVetupUsers::start");

    var idsJS = [_ids toJSObject],
        jsonStr = [CPString JSONFromObject:idsJS];

    _jsonObjectToPost =
            {
                "jsonrpc": "2.0",
                "method"                : WSInfoVetupUsersFunction,
                "params"                : {"ids":jsonStr},
                "id"                    : GlobalIncrementalRequestId
            };

    [super start];
}

- (void)parseJSONResponse:(id)iResult
{
    CPLog.info(@">>>> Entering WSInfoVetupUsers::parseJSONResponse: %@", iResult);

    [super parseJSONResponse:iResult];

    _info = @"";

//    if (WSNoError == self.error.code)
    if (nil == _error)
    {

        var data = iResult.data;

        if (data != nil)
        {
            _info = data;
        }
    }
    else
    {
        CPLog.debug(@"WSInfoVetupUsers::parseJSONResponse: ERROR");
    }


    CPLog.info(@"<<<< Leaving  WSInfoVetupUsers::parseJSONResponse");
}



@end
