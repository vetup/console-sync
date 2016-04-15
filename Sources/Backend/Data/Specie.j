
//compatibilité JSon pour serialization
@import "../../Categories/json/CPObject_CPJSONAware.j"
@import "../../Categories/json/CPString_CPJSONAware.j"

//pas de _ dans les nom de propriétés pour ne pas les avoir lors de la sérialzation en JSON sur setParameter (KParamCategory)
@implementation Specie : CPObject
{
    CPUInteger  uid     @accessors(property=uid);
    CPString    name    @accessors(property=name);
}

- (id)init
{
    if (self = [super init])
    {
        uid     = 0;
        name    = @"";
    }
    return self;
}

@end


@implementation SpecieUpdate : Specie
{
    CPString saveName   @accessors(property=saveName);
}

- (id)initWithSpecie:(Specie)specie
{
    if (self = [super init])
    {
        uid         = [specie uid];
        name        = [specie name];
        saveName    = name;
    }
    return self;
}

@end
