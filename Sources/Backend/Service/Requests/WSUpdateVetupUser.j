@import <Foundation/CPObject.j>
@import "../Common/WSBaseRequest.j"
//@import "../../../Categories/json/CPArray_CPJSONAware.j"
@import "../../../Categories/json/CPDictionary_JSON.j"

@import "../../Data/VetupUser.j"

@class DataManager;

WSUpdateVetupUserSubPath    = @"jsonconsole/sync"
WSUpdateVetupUserFunction   = @"updateVetupUser"

@implementation WSUpdateVetupUser : WSBaseRequest
{
    //Input request parameter
//    CPMutableArray         _ids   @accessors(setter=setIds);
//    JSObject _value   @accessors(setter=setValue);
    CPDictionary _value   @accessors(setter=setValue);
    VetupUser _vetupUser @accessors(property=vetupUser);

    //Output request parameter
    CPString _info  @accessors(getter=info);
}

// MARK: Init/dealloc

- (id)init
{
    CPLog.info(@">>>> Entering WSUpdateVetupUser::INIT");

    if (self = [super init])
    {
        _subpath = WSUpdateVetupUserSubPath;
    }
    return self;
}


- (void)start
{
    CPLog.info(@">>>> Entering WSUpdateVetupUser::start");

    var valueJS = [_value toJSObject],
        jsonStr = [CPString JSONFromObject:valueJS];

    _jsonObjectToPost =
            {
                "jsonrpc": "2.0",
                "method"                : WSUpdateVetupUserFunction,
                "params"                : {"userId": [_vetupUser uid], "value" : jsonStr},
                "id"                    : GlobalIncrementalRequestId
            };

    [super start];
}

- (void)parseJSONResponse:(id)iResult
{
    CPLog.info(@">>>> Entering WSUpdateVetupUser::parseJSONResponse: %@", iResult);

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
        CPLog.debug(@"WSUpdateVetupUser::parseJSONResponse: ERROR");
    }


    CPLog.info(@"<<<< Leaving  WSUpdateVetupUser::parseJSONResponse");
}



@end
