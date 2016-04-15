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
@import "./EDFlatFadeAndTextEffectButton.j"
@import "./EDButtonWithEffect.j"



@implementation TestThemeTabController : CPObject
{
    @outlet CPView _tabView;
    @outlet CPView _containerView;
    @outlet CPButton _buttonTest1;
}

- (id)init
{
    CPLog.info(@">>>> Entering TestThemeTabController::init");

    CPLog.info(@"<<<< Leaving TestThemeTabController::init");

    return self;
}


- (void)awakeFromCib
{
    CPLog.debug(@">>>> Entering TestThemeTabController::awakeFromCib");

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


//    [_buttonTest1 setValue:[CPColor colorWithHexString:@"-colortext"] forThemeAttribute:@"text-color" inState:CPThemeStateHighlighted];


//    [_buttonTest1 setThemeState:CPButtonStateBezelStyleRounded];
//   [_buttonTest1 setThemeState:CPThemeStateHighlighted];



//    [_containerView addSubview:test];

    var button1 = [EDFlatButton buttonWithTitle:@"ED Button 1"];
    [button1 setFrame:CGRectMake(10,10, 100, 30)];
    [_containerView addSubview:button1];


    var button2 = [[EDFlatFadeButton alloc] initWithFrame:CGRectMake(10,50, 100, 50) fadeDuration:0.1];
    [button2 setTitle:@"ED Button Flat"];

    [button2 setColor:[CPColor colorWithHexString:@"c9433d"]];
    [button2 setMouseHoverColor:[CPColor colorWithHexString:@"A43633"]];
    [button2 setHighlightColor:[CPColor colorWithHexString:@"E84D48"]];

    [button2 setTextColor:[CPColor colorWithHexString:@"FFFFFF"]];


    [_containerView addSubview:button2];



    var button3 = [[EDFlatFadeRoundedButton alloc] initWithFrame:CGRectMake(10, 110, 100, 50) fadeDuration:0.1 cornerRadius:5.0];
//    var button3 = [[EDFlatFadeRoundedButton alloc] initWithFrame:CGRectMake(10, 110, 100, 50) fadeDuration:0.1 cornerRadius:30.0];
    [button3 setTitle:@"ED Rounded Button Flat"];
    [button3 setColor:[CPColor colorWithHexString:@"c9433d"]];
    [button3 setMouseHoverColor:[CPColor colorWithHexString:@"A43633"]];
    [button3 setHighlightColor:[CPColor colorWithHexString:@"E84D48"]];

    [button3 setTextColor:[CPColor colorWithHexString:@"FFFFFF"]];

    [_containerView addSubview:button3];


//    var button4 = [[EDFlatFadeAndTextEffectButton alloc] initWithFrame:CGRectMake(120, 0, 100, 50) fadeDuration:0.1];
    var button4 = [[EDButtonWithEffect alloc] initWithFrame:CGRectMake(120, 0, 100, 50) fadeDuration:0.1 moveText:YES];
    [button4 setTitle:@"ED Fade and text effect"];
    [button4 setColor:[CPColor colorWithHexString:@"c9433d"]];
    [button4 setMouseHoverColor:[CPColor colorWithHexString:@"A43633"]];
    [button4 setHighlightColor:[CPColor colorWithHexString:@"E84D48"]];

    [button4 setTextColor:[CPColor colorWithHexString:@"FFFFFF"]];

    [_containerView addSubview:button4];



//- (id)initWithFrame:(CGRect)iFrame fadeDuration:(double)iDuration moveText:(boolean)iMoveText




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





