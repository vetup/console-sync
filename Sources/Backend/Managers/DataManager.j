@import <Foundation/Foundation.j>


@import "../Data/EmailUser.j"
@import "../Data/LinkedUser.j"
@import "../Data/UniqueUser.j"
@import "../Data/VetupUser.j"


var dataManagerSharedInstance = nil;

@implementation DataManager : CPObject
{
    CPMutableArray      _colors                 @accessors(property=colors);
    CPMutableDictionary _colorsMap              @accessors(readonly, getter=colorsMap);

    CPMutableArray      _species                @accessors(property=species);
    CPMutableDictionary _speciesMap             @accessors(readonly, getter=speciesMap);

    CPMutableArray      _breeds                 @accessors(property=breeds);
    CPMutableDictionary _breedsMap              @accessors(readonly, getter=breedsMap);
    CPMutableDictionary _breedsBySpeciesMap     @accessors(readonly, getter=breedsBySpeciesMap);

    //Module utilisateur
    CPMutableArray      _emailUsers             @accessors(property=emailUsers);
    CPMutableArray      _invalidEmailUsers      @accessors(property=invalidEmailUsers);
    CPMutableArray      _uniqueUsers            @accessors(property=uniqueUsers);
    CPMutableArray      _uniqueUsersMap         @accessors(property=uniqueUsersMap);

    CPMutableArray      _vetupUsers             @accessors(property=vetupUsers);



    CPNumber            _nbMergedUser          @accessors(property=nbMergedUser);
}

+ (DataManager)sharedManager
{
    if (dataManagerSharedInstance == nil)
    {
        dataManagerSharedInstance = [[DataManager alloc] init];
    }

    return dataManagerSharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
//        _targetById = [CPMutableDictionary new];
    }
    return self;
}

- (void)setColors:(CPMutableArray)colors
{
    //On construit la map pour un accès direct par id
    _colors = colors;
    _colorsMap = [CPMutableDictionary new];

    for (var i = 0; i < [_colors count]; i++)
    {
        var color = _colors[i];
        [_colorsMap setObject:color forKey:[color uid]];
    }
}


- (void)setSpecies:(CPMutableArray)species
{
    //On construit la map pour un accès direct par id
    _species = species;
    _speciesMap = [CPMutableDictionary new];

    for (var i = 0; i < [_species count]; i++)
    {
        var specie = _species[i];
        [_speciesMap setObject:specie forKey:[specie uid]];
    }

}


- (void)setBreeds:(CPMutableArray)breeds
{
    _breeds = breeds;
    _breedsBySpeciesMap = [CPMutableDictionary new];
    _breedsMap          = [CPMutableDictionary new];

    for (var i = 0; i < [_breeds count]; i++)
    {
        var breed = _breeds[i];
        [_breedsMap setObject:breed forKey:[breed uid]];

        var specieId            = [breed specieId],
            breedsForSpecieId   = [_breedsBySpeciesMap objectForKey:specieId];

        if (nil == breedsForSpecieId)
        {
            breedsForSpecieId = [CPMutableArray new];
            [_breedsBySpeciesMap setObject:breedsForSpecieId forKey:specieId];
        }
        [breedsForSpecieId addObject:breed];
    }
}

- (CPMutableArray)emailUsersFromJSArray:(id)emailUsersFromJSArray
{
    var emailUsers = [CPMutableArray new];

    for (var i = 0;  i < [emailUsersFromJSArray count]; i++)
    {
        var emailUser       = [emailUsersFromJSArray objectAtIndex:i],
            emailUserObj    = [EmailUser new];

        [emailUserObj setEmail:emailUser.email];
        [emailUserObj setNbOccurence:parseInt(emailUser.nbOccurence)];
        [emailUserObj setDbName:emailUser.dbName];
        [emailUserObj setUserType:emailUser.userType];

        [emailUsers addObject:emailUserObj];
    }

    return emailUsers;
}


- (void)initVetupUserArray
{
    [_vetupUsers removeAllObjects];
    _vetupUsers = [CPMutableArray new];
}

/*
- (CPMutableArray)vetupUsersFromJSArray:(id)vetupUsersFromJSArray
{
//    var vetupUsers = [CPMutableArray new];

    var vetupUsers =  _vetupUsers;

    for (var i = 0;  i < [vetupUsersFromJSArray count]; i++)
    {
        var vetupUser       = [vetupUsersFromJSArray objectAtIndex:i],
            vetupUserObj    = [VetupUser new];

        [vetupUserObj setUid:vetupUser.id];
        [vetupUserObj setEmail:vetupUser.email];
        [vetupUserObj setFirstname:vetupUser.firstname];
        [vetupUserObj setLastname:vetupUser.lastname];
        [vetupUserObj setPassword:vetupUser.password];

        [vetupUsers addObject:vetupUserObj];
    }

    return vetupUsers;
}*/

- (void)addVetupUsersFromJSArray:(id)vetupUsersFromJSArray
{
    var vetupUsers =  _vetupUsers;

    for (var i = 0;  i < [vetupUsersFromJSArray count]; i++)
    {
        var vetupUser       = [vetupUsersFromJSArray objectAtIndex:i],
            vetupUserObj    = [VetupUser new];

        [vetupUserObj setUid:vetupUser.id];
        [vetupUserObj setUserTypeId:vetupUser.userTypeId];
        [vetupUserObj setClinicId:vetupUser.clinicId];
        [vetupUserObj setEmail:vetupUser.email];
        [vetupUserObj setFirstname:vetupUser.firstname];
        [vetupUserObj setLastname:vetupUser.lastname];
        [vetupUserObj setPassword:vetupUser.password];

        [vetupUserObj setLastUpdate:vetupUser.lastUpdate];

        [vetupUserObj setVetupGuid:vetupUser.vetupGuid];
        [vetupUserObj setRegistrationReferrer:vetupUser.registrationReferrer];

        [vetupUsers addObject:vetupUserObj];
    }
}

- (VetupUser)vetupUserByUid:(CPNumber)aUid
{
    var result = null;

    [_vetupUsers enumerateObjectsUsingBlock:function(aObject, aIndex, stop)
        {
            if ([aObject uid] == aUid)
            {
                result = aObject;
                stop = true;
            }
        }];

    return result;
}

- (CPMutableArray)uniqueUsersFromJSArray:(id)uniqueUsersFromJSArray
{
    var uniqueUsers = [CPMutableArray new];

    for (var i = 0;  i < [uniqueUsersFromJSArray count]; i++)
    {
        var uniqueUser       = [uniqueUsersFromJSArray objectAtIndex:i],
            uniqueUserObj    = [UniqueUser new];

        [uniqueUserObj setUid:uniqueUser.id];
        [uniqueUserObj setEmail:uniqueUser.email];
        [uniqueUserObj setFirstname:uniqueUser.firstname];
        [uniqueUserObj setLastname:uniqueUser.lastname];
        [uniqueUserObj setPassword:uniqueUser.password];
        [uniqueUserObj setCreationDate:uniqueUser.creationDate.date];

        //Création des linked users
        var linkedUsersJS = uniqueUser.linkedUsers;

        if (linkedUsersJS != nil)
        {
            var linkedUsers = [CPMutableArray new];

            for (var j = 0;  j < [linkedUsersJS count]; j++)
            {
                var linkedUser       = [linkedUsersJS objectAtIndex:j],
                    linkedUserObj    = [LinkedUser new];

                [linkedUserObj setUid:parseInt(linkedUser.userId)];
                [linkedUserObj setEmail:linkedUser.email];
                [linkedUserObj setFirstname:linkedUser.firstname];
                [linkedUserObj setLastname:linkedUser.lastname];
                [linkedUserObj setPassword:linkedUser.password];
//                [linkedUserObj setDbName:linkedUser.dbName];
                [linkedUserObj setClinicId:parseInt(linkedUser.clinicId)];
                [linkedUserObj setUserType:linkedUser.userType];


                [linkedUsers addObject:linkedUserObj];
            }

            [uniqueUserObj setLinkedUsers:linkedUsers];
            [uniqueUserObj setNbLinkedUsers:[linkedUsers count]];
        }

        [uniqueUsers addObject:uniqueUserObj];
    }

    return uniqueUsers;
}

- (void)refreshIsMerged
{
    _nbMergedUser = 0;

    if (_emailUsers != nil && _uniqueUsersMap != nil)
    {
        for (var i = 0;  i < [_emailUsers count]; i++)
        {
            var emailUser       = [_emailUsers objectAtIndex:i],
                email           = [emailUser email],
                uniqueUser      = [_uniqueUsersMap objectForKey:email];

            if (uniqueUser != nil)
            {
                [emailUser setIsMerged:@"YES"];
                _nbMergedUser++;
            }
            else
            {
                [emailUser setIsMerged:@"no"];
            }
        }
    }
}




@end

