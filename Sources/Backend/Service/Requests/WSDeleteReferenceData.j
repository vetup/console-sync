@import <Foundation/CPObject.j>
@import "../Common/WSBaseRequest.j"
@import "../../Data/Color.j"


@global KObjectTypeColor;
@global KObjectTypeSpecie;
@global KObjectTypeBreed;


//WSTestSubPath    = @"jsonvetoonline/sync"
WSDeleteReferenceDataSubPath    = @"jsonconsole/sync"
WSDeleteReferenceDataFunction   = @"deleteReferenceData"


@implementation WSDeleteReferenceData : WSBaseRequest
{
    //Input/Output request parameter
    CPObject   _object           @accessors(property=object);
}

// MARK: Init/dealloc

- (id)init
{
    CPLog.info(@">>>> Entering WSDeleteReferenceData::INIT");

    if (self = [super init])
    {
        _subpath = WSDeleteReferenceDataSubPath;
    }
    return self;
}


- (void)start
{
    CPLog.info(@">>>> Entering WSDeleteReferenceData::start");

    var className   = [_object className],
        objectType  = @"unknown";

    if ("Color" == className)
        objectType = KObjectTypeColor;
    else if ("Specie" == className)
        objectType = KObjectTypeSpecie;
    else if ("Breed" == className)
        objectType = KObjectTypeBreed;


    var objectJS    = [_object toJSObject],
        jsonStr     = [CPString JSONFromObject:objectJS];

    _jsonObjectToPost =
            {
                "jsonrpc": "2.0",
                "method"                : WSDeleteReferenceDataFunction,
                "params"                : { "objectType" : objectType, "object" : jsonStr},
                "id"                    : GlobalIncrementalRequestId
            };

    [super start];
}

- (void)parseJSONResponse:(id)iResult
{
    CPLog.info(@">>>> Entering WSDeleteReferenceData::parseJSONResponse: %@", iResult);

    [super parseJSONResponse:iResult];

    CPLog.info(@"<<<< Leaving  WSDeleteReferenceData::parseJSONResponse");
}


@end
