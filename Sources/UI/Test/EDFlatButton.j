@import <Foundation/Foundation.j>
@import <AppKit/CPButton.j>
//@import "LPViewAnimation.j"
@import <LPKit/LPViewAnimation.j>

@implementation EDFlatButton : CPButton
{

}

- (id)init
{
    //CPLog.info(@">>>> Entering TestThemeTabController::init");

    if (self = [super init])
    {

        var inset = CGInsetMake(10, 10, 10, 10);
        [self setValue:inset forThemeAttribute:@"content-inset"];

    //[CPFont fontWithName:@"Courier New" size:11.0]]
    //[CPFont boldSystemFontOfSize:12.0]
        [self setValue:[CPFont fontWithName:@"Arial" size:11.0] forThemeAttribute:@"font" inState:CPThemeStateBordered];

    //    [_buttonTest1 setValue:[CPColor colorWithHexString:@"#FF0000"] forThemeAttribute:@"text-color" inState:CPThemeStateHighlighted];
     //   [self setValue:[CPColor colorWithHexString:@"FFFFFF"] forThemeAttribute:@"text-color" inState:CPThemeStateDefault];
    //    [self setValue:[CPColor colorWithHexString:@"CCCCCC"] forThemeAttribute:@"text-color" inState:CPThemeStateHighlighted];
    //    [self setValue:[CPColor colorWithHexString:@"FFFFFF"] forThemeAttribute:@"text-color" inState:CPThemeStateDefault | CPThemeStateHighlighted];
   //     [self setValue:[CPColor colorWithHexString:@"CCCCCC"] forThemeAttribute:@"text-color" inState:CPThemeStateBordered | CPThemeStateHighlighted];

        [self setValue:[CPColor colorWithHexString:@"c9433d"] forThemeAttribute:@"bezel-color" inState:CPThemeStateBordered];
        [self setValue:[CPColor colorWithHexString:@"0000FF"] forThemeAttribute:@"bezel-color" inState:CPThemeStateHovered];
        [self setValue:[CPColor colorWithHexString:@"FF0000"] forThemeAttribute:@"bezel-color" inState:CPThemeStateHighlighted];
    }
    //CPLog.info(@"<<<< Leaving TestThemeTabController::init");

    return self;
}


- (void)setTextColor:(CPColor)aColor
{
    [self setValue:aColor forThemeAttribute:@"text-color"];
}

- (void)setTextOverColor:(CPColor)aColor
{
    [self setValue:aColor forThemeAttribute:@"text-color" inState:CPThemeStateHighlighted];
}

- (void)mouseEntered:(CPEvent)anEvent
{
    CPLog.info(@"mouseEntered");
 //   [self setThemeState:CPThemeStateHighlighted];

    [[CPCursor pointingHandCursor] set];
    [super mouseEntered:anEvent];

  //  self._DOMElement.style.webkitTransform = "scale(0.75)";
}

- (void)mouseExited:(CPEvent)anEvent
{
    CPLog.info(@"mouseExited");
  //  [self unsetThemeState:CPThemeStateHighlighted];

    [[CPCursor arrowCursor] set];

    [super mouseExited:anEvent];
  //  self._DOMElement.style.webkitTransform = "scale(1)";
}






@end
