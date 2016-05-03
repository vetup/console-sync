@import <Foundation/CPObject.j>
@import "../Common/WSBaseRequest.j"
@import "../../../Categories/json/CPArray_CPJSONAware.j"

@class DataManager;

WSDeleteVetupUsersSubPath    = @"jsonconsole/sync"
WSDeleteVetupUsersFunction   = @"deleteVetupUsers"

@implementation WSDeleteVetupUsers : WSBaseRequest
{
    //Input request parameter
    CPMutableArray         _ids   @accessors(setter=setIds);

    //Output request parameter
    CPString _info  @accessors(getter=info);
}

// MARK: Init/dealloc

- (id)init
{
    CPLog.info(@">>>> Entering WSDeleteVetupUsers::INIT");

    if (self = [super init])
    {
        _subpath = WSDeleteVetupUsersSubPath;
    }
    return self;
}


- (void)start
{
    CPLog.info(@">>>> Entering WSDeleteVetupUsers::start");

    var idsJS = [_ids toJSObject],
        jsonStr = [CPString JSONFromObject:idsJS];

    _jsonObjectToPost =
            {
                "jsonrpc": "2.0",
                "method"                : WSDeleteVetupUsersFunction,
                "params"                : {"ids":jsonStr},
                "id"                    : GlobalIncrementalRequestId
            };

    [super start];
}

- (void)parseJSONResponse:(id)iResult
{
    CPLog.info(@">>>> Entering WSDeleteVetupUsers::parseJSONResponse: %@", iResult);

    [super parseJSONResponse:iResult];

//    _info = @"";

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
        CPLog.debug(@"WSDeleteVetupUsers::parseJSONResponse: ERROR");
    }

    CPLog.info(@"<<<< Leaving  WSDeleteVetupUsers::parseJSONResponse");
}



@end
