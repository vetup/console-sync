
//compatibilité JSon pour serialization
@import "../../Categories/json/CPObject_CPJSONAware.j"
@import "../../Categories/json/CPString_CPJSONAware.j"

@implementation Color : CPObject
{
    CPUInteger  uid        @accessors(property=uid);
    CPString    name       @accessors(property=name);
}

- (id)init
{
    if (self = [super init])
    {
        uid      = 0;
        name    = @"";
    }
    return self;
}

@end



@implementation ColorUpdate : Color
{
    CPString saveName   @accessors(property=saveName);
}

- (id)initWithColor:(Color)color
{
    if (self = [super init])
    {
        uid         = [color uid];
        name        = [color name];
        saveName    = name;
    }
    return self;
}

@end



