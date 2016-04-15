@import <Foundation/CPObject.j>
@import "../Common/WSBaseRequest.j"
@import "../../Data/Color.j"


@global KObjectTypeColor;

//WSTestSubPath    = @"jsonvetoonline/sync"
WSSynchronizeReferenceDataSubPath    = @"jsonconsole/sync"
WSSynchronizeReferenceDataFunction   = @"synchronizeReferenceData"

@implementation WSSynchronizeReferenceData : WSBaseRequest
{
    //Input request parameter
    CPString        _objectType     @accessors(setter=setObjectType);

    //Output request parameter
    CPString        _synchronizationResult      @accessors(getter=getSynchronizationResult);
}

// MARK: Init/dealloc

- (id)init
{
    CPLog.info(@">>>> Entering WSSynchronizeReferenceData::INIT");

    if (self = [super init])
    {
        _subpath = WSSynchronizeReferenceDataSubPath;
    }
    return self;
}


- (void)start
{
    CPLog.info(@">>>> Entering WSSynchronizeReferenceData::start");

    _jsonObjectToPost =
            {
                "jsonrpc": "2.0",
                "method"                : WSSynchronizeReferenceDataFunction,
                "params"                : { "objectType" : _objectType},
                "id"                    : GlobalIncrementalRequestId
            };

    [super start];
}

- (void)parseJSONResponse:(id)iResult
{
    CPLog.info(@">>>> Entering WSSynchronizeReferenceData::parseJSONResponse: %@", iResult);

    [super parseJSONResponse:iResult];

    if (WSNoError == self.error.code)
    {
        var synchronizationResult = iResult.data;

        _synchronizationResult = synchronizationResult;

        CPLog.debug(@"--- Synchronization result: %@", synchronizationResult);

        if (KObjectTypeColor == _objectType)
        {

        }
    }

    CPLog.info(@"<<<< Leaving  WSSynchronizeReferenceData::parseJSONResponse");
}


@end
