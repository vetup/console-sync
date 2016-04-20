@import <OJUnit/OJTestCase.j>
@import "../Sources/Backend/Data/Breed.j"

@implementation BreedUpdateTest : OJTestCase
{
}

- (void)testInitWithBreed
{
    var breed = [[Breed alloc] init];

    [breed setUid:18];
    [breed setName:@"breedname"];
    [breed setSpecieId:104];

    var newBreed = [[BreedUpdate alloc] initWithBreed:breed];

    [self assert:[newBreed uid] equals:[breed uid]];
    [self assert:[newBreed name] equals:[breed name]];
    [self assert:[newBreed specieId] equals:[breed specieId]];
    [self assert:[newBreed saveName] equals:[breed name]];
}


@end
