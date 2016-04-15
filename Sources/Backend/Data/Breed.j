
//compatibilité JSon pour serialization
@import "../../Categories/json/CPObject_CPJSONAware.j"
@import "../../Categories/json/CPString_CPJSONAware.j"

//pas de _ dans les nom de propriétés pour ne pas les avoir lors de la sérialzation en JSON sur setParameter (KParamCategory)
@implementation Breed : CPObject
{
    CPUInteger  uid         @accessors(property=uid);
    CPString    name        @accessors(property=name);
    CPUInteger  specieId    @accessors(property=specieId);
}

- (id)init
{
    if (self = [super init])
    {
        uid         = 0;
        name        = @"";
        specieId    = 0;
    }
    return self;
}

@end



@implementation BreedUpdate : Breed
{
    CPString saveName   @accessors(property=saveName);
}

- (id)initWithBreed:(Breed)breed
{
    if (self = [super init])
    {
        uid         = [breed uid];
        name        = [breed name];
        specieId    = [breed specieId];
        saveName    = name;
    }
    return self;
}

@end
