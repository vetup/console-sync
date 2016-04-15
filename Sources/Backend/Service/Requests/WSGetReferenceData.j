@import <Foundation/CPObject.j>
@import "../Common/WSBaseRequest.j"
@import "../../Data/Color.j"
@import "../../Data/Specie.j"
@import "../../Data/Breed.j"

@global KObjectTypeColor;
@global KObjectTypeSpecieAndBreed;

WSGetReferenceDataSubPath    = @"jsonconsole/sync"
WSGetReferenceDataFunction   = @"getReferenceData"


@implementation WSGetReferenceData : WSBaseRequest
{
    //Input request parameter
    CPString            _objectType     @accessors(setter=setObjectType);
    //Output request parameter
    CPMutableDictionary    _data        @accessors(getter=getData);
}


// MARK: Init

- (id)init
{
    CPLog.info(@">>>> Entering WSGetReferenceDataSubPath::INIT");

    if (self = [super init])
    {
        _subpath = WSGetReferenceDataSubPath;
    }
    return self;
}


- (void)start
{
    CPLog.info(@">>>> Entering WSGetReferenceDataSubPath::start");

    _jsonObjectToPost =
            {
                "jsonrpc": "2.0",
                "method"                : WSGetReferenceDataFunction,
                "params"                : { "objectType" : _objectType},
                "id"                    : GlobalIncrementalRequestId
            };

    [super start];
}


- (void)parseJSONResponse:(id)iResult
{
    CPLog.info(@">>>> Entering WSGetReferenceData::parseJSONResponse: %@", iResult);

    [super parseJSONResponse:iResult];


    if (WSNoError == self.error.code)
    {
        var data = iResult.data;

        if (KObjectTypeColor == _objectType)
        {
            _data = [CPMutableDictionary new];
            var colors = [CPMutableArray new];

            for (var i = 0;  i < [data count]; i++)
            {
                var color       = [data objectAtIndex:i],
                    colorObj    = [Color new];

                [colorObj setUid:color.id];
                [colorObj setName:color.name];

                [colors addObject:colorObj];
            }

            [_data setObject:colors forKey:"colors"];
           }
           else if (KObjectTypeSpecieAndBreed == _objectType)
           {

                _data = [CPMutableDictionary new];

                //SPECIES
                data = iResult.data.species;
                var species = [CPMutableArray new];

                for (var i = 0;  i < [data count]; i++)
                {
                    var specie       = [data objectAtIndex:i],
                        specieObj    = [Specie new];

                    [specieObj setUid:specie.id];
                    [specieObj setName:specie.name];

                    [species addObject:specieObj];
                }

                [_data setObject:species forKey:"species"];

                //BREEDS
                data = iResult.data.breeds;
                var breeds = [CPMutableArray new];

                for (var i = 0;  i < [data count]; i++)
                {
                    var breed       = [data objectAtIndex:i],
                        breedObj    = [Breed new];

                    [breedObj setUid:breed.id];
                    [breedObj setName:breed.name];
                    [breedObj setSpecieId:breed.specie.id];

                    [breeds addObject:breedObj];
                }

                [_data setObject:breeds forKey:"breeds"];
           }

    }
    else
    {
        CPLog.debug(@"<<<< TESTON !! PAS OK");

    }


    CPLog.info(@"<<<< Leaving  WSGetReferenceData::parseJSONResponse");
}



@end
