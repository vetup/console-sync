@import <Foundation/CPObject.j>
@import "../Common/WSBaseRequest.j"
@import "../../Data/Color.j"
//@import "../../Common/Tools.j"


@global KObjectTypeColor;
@global KObjectTypeSpecie;
@global KObjectTypeBreed;


//DEBUG
@class AppController;

//WSTestSubPath    = @"jsonvetoonline/sync"
WSUpdateReferenceDataSubPath    = @"jsonconsole/sync"
WSUpdateReferenceDataFunction   = @"updateReferenceData"

@implementation WSUpdateReferenceData : WSBaseRequest
{
    //Input request parameter
  //  CPString        _objectType     @accessors(setter=setObjectType);

    //Input/Output request parameter
    CPObject           _object           @accessors(property=object);
}

// MARK: Init/dealloc

- (id)init
{
    CPLog.info(@">>>> Entering WSUpdateReferenceData::INIT");

    if (self = [super init])
    {
        _subpath = WSUpdateReferenceDataSubPath;
    }
    return self;
}


- (void)start
{
//    CPLog.info(@">>>> Entering WSUpdateReferenceData::start");

    var className = [_object className],
        objectType = @"unknown";

    if ("ColorUpdate" == className)
        objectType = KObjectTypeColor;
    else if ("SpecieUpdate" == className)
        objectType = KObjectTypeSpecie;
    else if ("BreedUpdate" == className)
        objectType = KObjectTypeBreed;


//    var obj = [Tools dictionaryToJSObject:_colors];

    var     objectJS    = [_object toJSObject],
            jsonStr     = [CPString JSONFromObject:objectJS];

    _jsonObjectToPost =
            {
                "jsonrpc": "2.0",
                "method"                : WSUpdateReferenceDataFunction,
                "params"                : { "objectType" : objectType, "object" : jsonStr},
                "id"                    : GlobalIncrementalRequestId
            };

    [super start];
}

- (void)parseJSONResponse:(id)iResult
{
//    CPLog.info(@">>>> Entering WSUpdateReferenceData::parseJSONResponse: %@", iResult);

    [super parseJSONResponse:iResult];

//    CPLog.info(@"<<<< Leaving  WSUpdateReferenceData::parseJSONResponse");
}


@end
