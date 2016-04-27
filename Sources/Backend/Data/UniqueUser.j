
//compatibilité JSon pour serialization
@import "../../Categories/json/CPObject_CPJSONAware.j"
@import "../../Categories/json/CPString_CPJSONAware.j"

@implementation UniqueUser : CPObject
{
    CPNumber    uid                 @accessors(property=uid);
    CPString    email               @accessors(property=email);
    CPString    firstname           @accessors(property=firstname);
    CPString    lastname            @accessors(property=lastname);
    CPString    password            @accessors(property=password);
    CPString    creationDate        @accessors(property=creationDate);
    CPArray     linkedUsers         @accessors(property=linkedUsers);
    CPNumber    nbLinkedUsers       @accessors(property=nbLinkedUsers); //Pour affichage dans la table des users unique, déterminé par le count du tableau linkedUsers
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
        creationDate    = @"";
        linkedUsers     = nil;
        nbLinkedUsers   = 0;
    }
    return self;
}

@end



