@import <OJUnit/OJTestCase.j>
@import "../Sources/Backend/Data/Breed.j"

@implementation BreedTest : OJTestCase
{
}


- (void)testInit
{
    var breed = [[Breed alloc] init];

    [self assert:0 equals:[breed uid]];
    [self assert:"" equals:[breed name]];
    [self assert:0 equals:[breed specieId]];
}

- (void)testValue
{
    var breed = [[Breed alloc] init];

    [breed setUid:201];
    [breed setName:@"dogbreed"];
    [breed setSpecieId:13];

    [self assert:201 equals:[breed uid]];
    [self assert:@"dogbreed" equals:[breed name]];
    [self assert:13 equals:[breed specieId]];
}

@end
