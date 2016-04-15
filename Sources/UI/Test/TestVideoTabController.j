//
// ModuleArticleParamTabController.j
//
// Created by Philippe Fuentes.
//
@import <Foundation/Foundation.j>
@import <Foundation/CPObject.j>

@import "./EDVideoPlayer.j"

@implementation TestVideoTabController : CPObject
{
    @outlet CPView _tabView;
    @outlet CPView _containerView;

    EDVideoPlayer _videoPlayer;
}

- (id)init
{
    CPLog.info(@">>>> Entering TestVideoTabController::init");

    CPLog.info(@"<<<< Leaving TestVideoTabController::init");

    return self;
}


- (void)awakeFromCib
{
 //   CPLog.debug(@">>>> Entering TestTemplateTabController::awakeFromCib");

    [_tabView setBackgroundColor:[CPColor whiteColor]];

    [_containerView setBackgroundColor:[CPColor redColor]];
//    [_containerView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
 //   [_containerView setAutoresizingMask:CPViewNotSizable];
//
//        [textField setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];


    _videoPlayer = [[EDVideoPlayer alloc] initWithFrame:CGRectMake(0, 0, 480, 360)];

    [_videoPlayer setBackgroundColor:[CPColor greenColor]];

    [_containerView addSubview:_videoPlayer];
//    CPLog.debug(@"<<<< Leaving TestTemplateTabController::awakeFromCib");
}


- (void)refresh
{

}


//----o PUBLIC
#pragma mark -
#pragma mark Action



#pragma mark -
#pragma mark IB Action
- (@action)play:(id)sender
{
    [_videoPlayer play];
}

- (@action)stop:(id)sender
{
    [_videoPlayer stop];
}

#pragma mark -
#pragma mark Private



#pragma mark -
#pragma mark WS Notification



@end





