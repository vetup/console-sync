@import <Foundation/Foundation.j>
@import <Raphuccino/Raphuccino.j>

@import "EDHandCursorView.j"


@implementation EDSVGIcon : CPView
//@implementation EDSVGIcon : EDHandCursorView
{
    RCRaphaelView       _raphaelView;
    RCPath              _rcPath;
//    EDHandCursorView    _handCursorView;
     id _delegate  @accessors(property=delegate);
}

- (id)initWithFrame:(CGRect)frame
{

    if ((self = [super initWithFrame:frame]))
    {

        [self setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

        var fullFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);

        _raphaelView = [[RCRaphaelView alloc] initWithFrame:fullFrame];
        [_raphaelView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];


        [_raphaelView setDelegate:self];
        [self addSubview:_raphaelView];

 //       [_raphaelView setBackgroundColor:[CPColor redColor]];
        [_raphaelView setBackgroundColor:[CPColor clearColor]];

        var handCursorView = [[EDHandCursorView alloc] initWithFrame:fullFrame];
        [self addSubview:handCursorView];
        [handCursorView setDelegate:self];
    }

    return self;
}


#pragma mark Hand Cursor View delegate

- (void)handCursorViewMouseEntered:(CPEvent)anEvent
{
//    CPLog.debug(@"handCursorViewMouseEntered::mouseEntered");
    [self._rcPath animateWithDuration:100 toNewAttributes:{'fill': '#DECFC2', rotation:90, animationCurve:RCAnimationLinear}];
}

- (void)handCursorViewMouseExited:(CPEvent)anEvent
{
//    CPLog.debug(@"handCursorViewMouseExited::mouseExited");
    [self._rcPath animateWithDuration:100 toNewAttributes:{'fill': '#ADA29B', rotation:-90,  animationCurve:RCAnimationLinear}];
}

- (void)handCursorViewMouseUp:(CPEvent)anEvent
{
//   CPLog.debug(@"EDSVGIcon::handCursorViewMouseUp:");
   [[self delegate] onClickIcon:self];
}


#pragma mark Raphael delegate

//ADA29B
//DECFC2
//F1E0D4
//var KTopBarColor        =   [CPColor colorWithRed:0xAD/0xFF green:0xA2/0xFF blue:0x9B/0xFF alpha:1.0]
//var KStatusBarColor     =   [CPColor colorWithRed:0xDE/0xFF green:0xCF/0xFF blue:0xC2/0xFF alpha:1.0]
//var KWindowBGColor      =   [CPColor colorWithRed:0xF1/0xFF green:0xE0/0xFF blue:0xD4/0xFF alpha:1.0]

- (void)raphaelViewDidFinishLoading:(RCRaphaelView)aRaphaelView
{
    //Icon refresh
    self._rcPath = [RCPath pathWithRaphaelView:_raphaelView SVGString:@"M24.249,15.499c-0.009,4.832-3.918,8.741-8.75,8.75c-2.515,0-4.768-1.064-6.365-2.763l2.068-1.442l-7.901-3.703l0.744,8.694l2.193-1.529c2.244,2.594,5.562,4.242,9.26,4.242c6.767,0,12.249-5.482,12.249-12.249H24.249zM15.499,6.75c2.516,0,4.769,1.065,6.367,2.764l-2.068,1.443l7.901,3.701l-0.746-8.693l-2.192,1.529c-2.245-2.594-5.562-4.245-9.262-4.245C8.734,3.25,3.25,8.734,3.249,15.499H6.75C6.758,10.668,10.668,6.758,15.499,6.75z"];

    [self._rcPath setAttr:{
        fill: '#ADA29B',
        stroke: 'none',
    }];


    var containerRect       = [self frame],
        containerRectSize   = containerRect.size;

    //considérer les marges du path (le graph n'est pas inscrit dans un rectangle)
//    containerRectSize.width     -= (containerRectSize.width*0.2);
//    containerRectSize.height    -= (containerRectSize.width*0.25);
    containerRectSize.width     -= (containerRectSize.width * 0.30);
    containerRectSize.height    -= (containerRectSize.width * 0.40);

    var pathRect            = [self._rcPath bounds],
        pathRectSize        = pathRect.size;

    var scaleX = containerRectSize.width / pathRectSize.width,
        scaleY = containerRectSize.height / pathRectSize.height;

//    var originPoint = CPPointMake(pathRectSize.width/2.0, pathRectSize.height/2.0);
    var originPoint = CPPointMake(0, 0);
//    originPoint.x = 0;
//    originPoint.Y = 0;

    [self._rcPath scaleByX:scaleX y:scaleY origin:originPoint];


/*
    [self._rcPath setHoverStartFunction:function (event) {
        [self._rcPath setAttr:{cursor:"pointer"}];
        [self._rcPath animateWithDuration:100 toNewAttributes:{'fill': '#DECFC2', rotation:90, animationCurve:RCAnimationLinear}];
        ;

        //[[CPCursor pointingHandCursor] set];
    } endFunction:function (event) {
        [self._rcPath animateWithDuration:100 toNewAttributes:{'fill': '#ADA29B', rotation:-90,  animationCurve:RCAnimationLinear}];
    }];
    */

//    [self._rcPath setDelegate:self];

    CPLog.debug(@">> EDSVGIcon:raphaelViewDidFinishLoading");
    return;
}


/*
- (void)raphaelElementDidFinishAnimating:(RCElement)anElement
{
    CPLog.debug(@"raphaelElementDidFinishAnimating");
}

- (void)raphaelElementWasClicked:(RCElement)anElement
{
    CPLog.debug(@"raphaelElementWasClicked");
}

- (void)raphaelElementWasDoubleClicked:(RCElement)anElement
{
//    console.log("raphaelElementWasDoubleClicked: " + anElement);
    CPLog.debug(@"raphaelElementWasDoubleClicked");
}

- (void)raphaelElementMouseDown:(RCElement)anElement atPoint:(CPPoint)aPoint
{
//    console.log("raphaelElementMouseDown: " + anElement + " atPoint:" + aPoint.x + ", " + aPoint.y);
    CPLog.debug(@"raphaelElementMouseDown");
}

- (void)raphaelElementMouseUp:(RCElement)anElement atPoint:(CPPoint)aPoint
{
//    console.log("raphaelElementMouseUp: " + anElement + " atPoint:" + aPoint.x + ", " + aPoint.y);
    CPLog.debug(@"raphaelElementMouseUp");
}

- (void)raphaelElementMouseDidMove:(RCElement)anElement toPoint:(CPPoint)aPoint
{
//    console.log("raphaelElementMouseDidMove: " + anElement + " toPoint:" + aPoint.x + ", " + aPoint.y);
    CPLog.debug(@"raphaelElementMouseDidMove");
}

- (void)raphaelElementMouseOut:(RCElement)anElement
{
//    console.log("raphaelElementMouseOut: " + anElement);
    CPLog.debug(@"raphaelElementMouseOut");
}

- (void)raphaelElementMouseOver:(RCElement)anElement
{
//    console.log("raphaelElementMouseOver: " + anElement);
    CPLog.debug(@"raphaelElementMouseOver");
}

- (void)raphaelElementDidBeginHover:(RCElement)anElement
{
//    console.log("raphaelElementDidBeginHover: " + anElement);
    CPLog.debug(@"raphaelElementDidBeginHover");
}

- (void)raphaelElementDidEndHover:(RCElement)anElement
{
//    console.log("raphaelElementDidEndHover: " + anElement);
    CPLog.debug(@"raphaelElementDidEndHover");
}
*/


@end
