@import <OJUnit/OJTestCase.j>
@import "../Sources/Backend/Data/Color.j"

@implementation ColorTest : OJTestCase
{
}


- (void)testInit
{
    var color = [[Color alloc] init];

    [self assert:0 equals:[color uid]];
    [self assert:"" equals:[color name]];
}


- (void)testValue
{
    var color = [[Color alloc] init];

    [color setUid:201];
    [color setName:@"red"];

    [self assert:201 equals:[color uid]];
    [self assert:@"red" equals:[color name]];
}




/*
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
*/

@end
