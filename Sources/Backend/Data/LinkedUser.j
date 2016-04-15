
//compatibilité JSon pour serialization
@import "../../Categories/json/CPObject_CPJSONAware.j"
@import "../../Categories/json/CPString_CPJSONAware.j"

@implementation LinkedUser : CPObject
{
    CPNumber    uid                 @accessors(property=uid);
    CPString    email               @accessors(property=email);
    CPString    firstname           @accessors(property=firstname);
    CPString    lastname            @accessors(property=lastname);
    CPString    password            @accessors(property=password);
//    CPString    dbName              @accessors(property=dbName);
    CPNumber    clinicId            @accessors(property=clinicId);
    CPString    userType            @accessors(property=userType);
}

- (id)init
{
    if (self = [super init])
    {
        uid             = 0;
        email           = @"";
        firstname       = @"";
        lastname        = @"";
        password        = @"";
//        dbName          = @"";
        clinicId        = 0;
        userType        = @"";
    }
    return self;
}

@end



