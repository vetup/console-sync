
//compatibilité JSon pour serialization
@import "../../Categories/json/CPObject_CPJSONAware.j"
@import "../../Categories/json/CPString_CPJSONAware.j"

@implementation VetupUser : CPObject
{
    CPNumber    uid                     @accessors(property=uid);
    CPNumber    userTypeId              @accessors(property=userTypeId);
//    CPString    userTypeName            @accessors(property=userTypeName);
    CPNumber    clinicId                @accessors(property=clinicId);
    CPString    email                   @accessors(property=email);
    CPString    firstname               @accessors(property=firstname);
    CPString    lastname                @accessors(property=lastname);
    CPString    password                @accessors(property=password);
    CPString    registrationReferrer    @accessors(property=registrationReferrer);
    CPString    vetupGuid               @accessors(property=vetupGuid);
    CPString    lastUpdate              @accessors(property=lastUpdate);
}

- (id)init
{
    if (self = [super init])
    {
        uid                     = 0;
        userTypeId              = 0;
//        userTypeName            = @"";
        clinicId                = 0;
        email                   = @"";
        firstname               = @"";
        lastname                = @"";
        password                = @"";
        registrationReferrer    = @"";
        vetupGuid               = @"";
        lastUpdate              = @"";
    }
    return self;
}

@end



