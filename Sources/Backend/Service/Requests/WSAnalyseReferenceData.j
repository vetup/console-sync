@import <Foundation/CPObject.j>
@import "../Common/WSBaseRequest.j"
@import "../../Data/Color.j"

@global KObjectTypeColor;

WSAnalyseReferenceDataSubPath    = @"jsonconsole/sync"
WSAnalyseReferenceDataFunction   = @"analyseReferenceData"

@implementation WSAnalyseReferenceData : WSBaseRequest
{
    //Input request parameter
    CPString        _objectType         @accessors(setter=setObjectType);

    //Output request parameter
    CPString        _analyseResult      @accessors(getter=getAnalyseResult);
}

// MARK: Init/dealloc
- (id)init
{
    CPLog.info(@">>>> Entering WSAnalyseReferenceData::INIT");

    if (self = [super init])
    {
        _subpath = WSAnalyseReferenceDataSubPath;
    }
    return self;
}

- (void)start
{
    CPLog.info(@">>>> Entering WSAnalyseReferenceData::start");

    _jsonObjectToPost =
            {
                "jsonrpc": "2.0",
                "method"                : WSAnalyseReferenceDataFunction,
                "params"                : { "objectType" : _objectType},
                "id"                    : GlobalIncrementalRequestId
            };

    [super start];
}

- (void)parseJSONResponse:(id)iResult
{
    CPLog.info(@">>>> Entering WSAnalyseReferenceData::parseJSONResponse: %@", iResult);

    [super parseJSONResponse:iResult];


//    if (WSNoError == self.error.code)
    if (nil == _error)
   {
        var analyseResult = iResult.data;

        _analyseResult = analyseResult;

        CPLog.debug(@"--- Analyse result: %@", analyseResult);

        if (KObjectTypeColor == _objectType)
        {

        }
    }


    CPLog.info(@"<<<< Leaving  WSAnalyseReferenceData::parseJSONResponse");
}


@end
