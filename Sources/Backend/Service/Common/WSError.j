@import <Foundation/CPObject.j>

/*
Pour la gestion des erreurs serveurs
J'ai créé un objet pour matcher la gestion sous iOS mais j'utilise vraiment que le "code" pour l'intant
*/


WSVetupErrorDomain 		= @"VetupWebServicesErrorDomain";
WSInternetErrorDomain 	= @"InternetErrorDomain"; //Pour ce qui n'est pas du domaine de Vetup, a voir...

@implementation WSError : CPObject
{
    CPString _code 		@accessors(property=code);
    CPString _domain  	@accessors(property=domain);
    CPString _desc 		@accessors(property=desc);
}


#pragma mark -
#pragma mark Init


- (id) init
{
    if ( self = [super init] )
    {
        _code   = @"";
        _domain = @"";
        _desc   = @"";
    }
    return self;
}

@end


