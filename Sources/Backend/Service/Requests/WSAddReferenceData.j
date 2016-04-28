@import <Foundation/CPObject.j>
@import "../Common/WSBaseRequest.j"
@import "../../Data/Color.j"


@global KObjectTypeColor;
@global KObjectTypeSpecie;
@global KObjectTypeBreed;


//WSTestSubPath    = @"jsonvetoonline/sync"
WSAddReferenceDataSubPath    = @"jsonconsole/sync"
WSAddReferenceDataFunction   = @"addReferenceData"


@implementation WSAddReferenceData : WSBaseRequest
{
    //Input/Output request parameter
    CPObject   _object           @accessors(property=object);


    //private
    //CPString   _objectType;
}

// MARK: Init/dealloc

- (id)init
{
    CPLog.info(@">>>> Entering WSAddReferenceData::INIT");

    if (self = [super init])
    {
        _subpath = WSAddReferenceDataSubPath;
    }
    return self;
}


- (void)start
{
    CPLog.info(@">>>> Entering WSAddReferenceData::start");

    var className   = [_object className],
        objectType  = @"unknown";

    if ("Color" == className)
        objectType = KObjectTypeColor;
    else if ("Specie" == className)
        objectType = KObjectTypeSpecie;
    else if ("Breed" == className)
        objectType = KObjectTypeBreed;

    //_objectType = objectType;

//    var obj = [Tools dictionaryToJSObject:_colors];

    var objectJS    = [_object toJSObject],
        jsonStr     = [CPString JSONFromObject:objectJS];

    _jsonObjectToPost =
            {
                "jsonrpc": "2.0",
                "method"                : WSAddReferenceDataFunction,
                "params"                : { "objectType" : objectType, "object" : jsonStr},
                "id"                    : GlobalIncrementalRequestId
            };

    [super start];
}

- (void)parseJSONResponse:(id)iResult
{
    CPLog.info(@">>>> Entering WSAddReferenceData::parseJSONResponse: %@", iResult);

    [super parseJSONResponse:iResult];


//    if (WSNoError == self.error.code)
    if (nil == _error)
    {
        var objectJS = iResult.data;

        [_object setUid:objectJS.id];

        /*
        if (KObjectTypeColor == _objectType)
        {
            //On positionne l'id du nouvel objet
            [_object setUid:colorJS.id];
        }
        */

    }
    else
    {
        CPLog.debug(@"<<<< TESTON !! PAS OK");

    }


    CPLog.info(@"<<<< Leaving  WSAddReferenceData::parseJSONResponse");
}


@end
