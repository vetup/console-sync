@import <OJUnit/OJTestCase.j>
@import "../Sources/Backend/Data/Color.j"

@implementation ColorUpdateTest : OJTestCase
{
}


- (void)testInitWithColor
{
    var color = [[Color alloc] init];
    [color setUid:18];
    [color setName:@"colorname"];

    var newColor = [[ColorUpdate alloc] initWithColor:color];

    [self assert:[newColor uid] equals:[color uid]];
    [self assert:[newColor name] equals:[color name]];
    [self assert:[newColor saveName] equals:[color name]];
}


@end
