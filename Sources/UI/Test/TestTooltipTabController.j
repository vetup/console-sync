//
// ModuleArticleParamTabController.j
//
// Created by Philippe Fuentes.
//
@import <Foundation/Foundation.j>
@import <Foundation/CPObject.j>
//@import <GrowlCappuccino/GrowlCappuccino.j>
//@import <Cup/Cup.j>
@import "./EDFlatButton.j"
@import "./EDFlatFadeButton.j"
@import "./EDFlatFadeRoundedButton.j"


@implementation TestTooltipTabController : CPObject
{
    @outlet CPView _tabView;
    @outlet CPView _containerView;

    @outlet CPButton _buttonTest1;
}

- (id)init
{
    CPLog.info(@">>>> Entering TestTooltipTabController::init");

    CPLog.info(@"<<<< Leaving TestTooltipTabController::init");

    return self;
}


- (void)awakeFromCib
{
    CPLog.debug(@">>>> Entering TestTooltipTabController::awakeFromCib");

    [_tabView setBackgroundColor:[CPColor whiteColor]];

    [_buttonTest1 setTitle:@"MINOU"];

    [_buttonTest1 setFrame:CGRectMake(10,10, 100, 30)];


    var inset = CGInsetMake(10, 10, 10, 10);
    [_buttonTest1 setValue:inset forThemeAttribute:@"content-inset"];

//[CPFont fontWithName:@"Courier New" size:11.0]]
//[CPFont boldSystemFontOfSize:12.0]
    [_buttonTest1 setValue:[CPFont fontWithName:@"Arial" size:11.0] forThemeAttribute:@"font" inState:CPThemeStateBordered];

//    [_buttonTest1 setValue:[CPColor colorWithHexString:@"#FF0000"] forThemeAttribute:@"text-color" inState:CPThemeStateHighlighted];
    [_buttonTest1 setValue:[CPColor colorWithHexString:@"FFFFFF"] forThemeAttribute:@"text-color" inState:CPThemeStateDefault];
    [_buttonTest1 setValue:[CPColor colorWithHexString:@"FFFFFF"] forThemeAttribute:@"text-color" inState:CPThemeStateHighlighted];
    [_buttonTest1 setValue:[CPColor colorWithHexString:@"FFFFFF"] forThemeAttribute:@"text-color" inState:CPThemeStateDefault | CPThemeStateHighlighted];
    [_buttonTest1 setValue:[CPColor colorWithHexString:@"FFFFFF"] forThemeAttribute:@"text-color" inState:CPThemeStateBordered];

    [_buttonTest1 setValue:[CPColor colorWithHexString:@"c9433d"] forThemeAttribute:@"bezel-color" inState:CPThemeStateBordered];

    [_buttonTest1 setToolTip:@"Il est ou le petit minou"];


//        [self setValue:[CPColor colorWithHexString:@"c9433d"] forThemeAttribute:@"bezel-color" inState:CPThemeStateBordered];

    CPLog.debug(@"<<<< Leaving TestThemeTabController::awakeFromCib");
}


- (void)refresh
{

}


//----o PUBLIC
#pragma mark -
#pragma mark Action



#pragma mark -
#pragma mark IB Action


/*
- (IBAction)savePassword:(id)sender
{

    CPLog.info(@"<<<< ModuleAPNMessageTabController Leaving");
}

*/

#pragma mark -
#pragma mark Private



#pragma mark -
#pragma mark WS Notification



@end





