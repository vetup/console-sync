
//compatibilité JSon pour serialization
@import "../../Categories/json/CPObject_CPJSONAware.j"
@import "../../Categories/json/CPString_CPJSONAware.j"

@implementation EmailUser : CPObject
{
    CPString    email               @accessors(property=email);
//    CPUInteger  nbOccurence         @accessors(property=nbOccurence);
    CPNumber    nbOccurence         @accessors(property=nbOccurence);
    CPString    dbName              @accessors(property=dbName);
    CPString    userType            @accessors(property=userType);

    //rensigner grace à uniqueUsersMap pour l'affichage dans le table des doublons
    CPString    isMerged            @accessors(property=isMerged);
}

- (id)init
{
    if (self = [super init])
    {
        nbOccurence     = 0;
        email           = @"";
        dbName          = @"";
        userType        = @"";
        isMerged        = @"no";
    }
    return self;
}

@end



