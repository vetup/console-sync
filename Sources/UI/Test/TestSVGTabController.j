//
// TestSVGTabController.j
//
// Created by Philippe Fuentes.
//
@import <Foundation/Foundation.j>
@import <Foundation/CPObject.j>

@import <Raphuccino/Raphuccino.j>

@implementation TestSVGTabController : CPObject
{
    @outlet CPView _tabView;
    @outlet CPView _containerView;

    RCRaphaelView raphaelView;

    CPImage cappIcon;
}

- (id)init
{
    CPLog.info(@">>>> Entering TestSVGTabController::init");

    CPLog.info(@"<<<< Leaving TestSVGTabController::init");

    return self;
}


- (void)awakeFromCib
{
    CPLog.debug(@">>>> Entering TestSVGTabController::awakeFromCib");

    [_tabView setBackgroundColor:[CPColor whiteColor]];

   // [_containerView setBackgroundColor:[CPColor redColor]];

    //raphaelView = [RCRaphaelView new];

    var frame = [_containerView frame];

    raphaelView = [[RCRaphaelView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [raphaelView setDelegate:self];
    [_containerView addSubview:raphaelView];

    [raphaelView setBackgroundColor:[CPColor colorWithWhite:0 alpha:0.1]];

    CPLog.debug(@"<<<< Leaving TestSVGTabController::awakeFromCib");
}




- (void)refresh
{

}


//----o PUBLIC
#pragma mark -
#pragma mark Action


#pragma mark -
#pragma mark Raphael delegate

- (void)raphaelViewDidFinishLoading:(RCRaphaelView)aRaphaelView
{
    cappIcon    = [[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] resourceURL] + "cappuccino-icon.png"];
//   trololoMan  = [[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] resourceURL] + "trololo.jpg"];



    CPLog.debug(@">> TestSVGTabController:raphaelViewDidFinishLoading");
    return;
}


/* delegate methods */
- (void)raphaelElementDidFinishAnimating:(RCElement)anElement
{
    console.log("raphaelElementDidFinishAnimating: " + anElement);
}

- (void)raphaelElementWasClicked:(RCElement)anElement
{
    console.log("raphaelElementWasClicked: " + anElement);
}

- (void)raphaelElementWasDoubleClicked:(RCElement)anElement
{
    console.log("raphaelElementWasDoubleClicked: " + anElement);
}

- (void)raphaelElementMouseDown:(RCElement)anElement atPoint:(CPPoint)aPoint
{
    console.log("raphaelElementMouseDown: " + anElement + " atPoint:" + aPoint.x + ", " + aPoint.y);
}

- (void)raphaelElementMouseUp:(RCElement)anElement atPoint:(CPPoint)aPoint
{
    console.log("raphaelElementMouseUp: " + anElement + " atPoint:" + aPoint.x + ", " + aPoint.y);
}

- (void)raphaelElementMouseDidMove:(RCElement)anElement toPoint:(CPPoint)aPoint
{
    console.log("raphaelElementMouseDidMove: " + anElement + " toPoint:" + aPoint.x + ", " + aPoint.y);
}

- (void)raphaelElementMouseOut:(RCElement)anElement
{
    console.log("raphaelElementMouseOut: " + anElement);
}

- (void)raphaelElementMouseOver:(RCElement)anElement
{
    console.log("raphaelElementMouseOver: " + anElement);
}

- (void)raphaelElementDidBeginHover:(RCElement)anElement
{
    console.log("raphaelElementDidBeginHover: " + anElement);
}

- (void)raphaelElementDidEndHover:(RCElement)anElement
{
    console.log("raphaelElementDidEndHover: " + anElement);
}


#pragma mark -
#pragma mark IB Action
- (@action)play:(id)sender
{
//    [self _launchDemo];

    [self _testButton];
}


#pragma mark -
#pragma mark Private

- (void)_testButton
{
    var rect = [RCRect rectWithRaphaelView:raphaelView rect:CPMakeRect(120, 50, 100, 50)];
    [rect setAttr:{
        'fill': '#c9433d',
        'stroke-width': 0,
        r: 2
    }];

    [rect setHoverStartFunction:function (event) {
        [rect setAttr:{cursor:"pointer"}];
        [rect animateWithDuration:100 toNewAttributes:{'fill': '#A43633',  animationCurve:RCAnimationLinear}];
        ;

        //[[CPCursor pointingHandCursor] set];
    } endFunction:function (event) {
        [rect animateWithDuration:100 toNewAttributes:{'fill': '#c9433d',  animationCurve:RCAnimationLinear}];
    }];




}

- (void)_launchDemo
{
    [raphaelView clear];


    //DEMO 1
    var circle = [RCCircle circleWithRaphaelView:raphaelView atPoint:CPMakePoint(250, 100) radius:80];
    [circle setAttr:{'fill': 'green'}];
    [circle animateWithDuration:2000 toNewAttributes:{'fill': 'red', 'cy': [raphaelView bounds].size.height - 20, 'r': 10} animationCurve:RCAnimationBounce];


    //DEMO 2
    var path = [RCPath pathWithRaphaelView:raphaelView SVGString:@"M100,100c0,50 100-50 100,0c0,50 -100-50 -100,0z"];
    var ellipse = [RCEllipse ellipseWithRaphaelView:raphaelView atPoint:CPMakePoint(100, 100) xRadius:3 yRadius:6];
    [ellipse animateAlongPath:path duration:5000 rotate:YES];


    //DEMO 3
    var circle = [RCCircle circleWithRaphaelView:raphaelView atPoint:CPMakePoint(400, 100) radius:80];
    [circle setAttr:{'fill': 'yellow'}];
    var dragging = NO;

    [circle setMouseDownFunction:function() {dragging = YES; [circle setAttr:{'fill': 'red'}];}];
    [circle setMouseUpFunction:function() {dragging = NO; [circle setAttr:{'fill': 'yellow'}];}];
    [circle setMouseMoveFunction:function(event) {
        if (dragging === YES)
        {
            [circle setAttr:{cx: event.clientX, cy: event.clientY}];
        }
    }];


    // stolen from http://net.tutsplus.com/tutorials/javascript-ajax/an-introduction-to-the-raphael-js-library/
    var path = [RCPath pathWithRaphaelView:raphaelView SVGString:@"M 250 250 l 0 -50 l -50 0 l 0 -50 l -50 0 l 0 50 l -50 0 l 0 50 z"];
    [path setAttr:{
        gradient: '90-#526c7a-#64a0c1',
        stroke: '#3b4449',
        'stroke-width': 10,
        'stroke-linejoin': 'round',
        rotation: -90
    }];
    [path setDelegate:self];

/*
    //DEMO 4
    var circle = [RCCircle circleWithRaphaelView:raphaelView atPoint:CPMakePoint(100, 200) radius:80];
    [circle setAttr:{'fill': 'lightblue'}];
    var text = [RCText textWithRaphaelView:raphaelView atPoint:CPMakePoint(100, 200) text:@"Raphaël\nis\nawesome!"];
    [text setAttr:{'font-size': 14}];
    var recursiveRotationFunc = function() {[text rotate:0]; [text animateWithDuration:1500 toNewAttributes:{'rotation': 360} callbackFunction:recursiveRotationFunc]};
    recursiveRotationFunc();

    var text2 = [RCText textWithRaphaelView:raphaelView atPoint:CPMakePoint(150, 200) text:@"...but so is Cappuccino!"];
    [text2 setAttr:{'font-size': 24}];
    var recursiveElasticFunc = function() {[text2 animateWithDuration:1500 toNewAttributes:{'x': [text2 attr]['x'] < 350 ? 350 : 150} animationCurve:RCAnimationElastic callbackFunction:recursiveElasticFunc]};
    recursiveElasticFunc();
    */

/*
    //[raphaelView clear];
    var image = [RCImage imageWithRaphaelView:raphaelView atPoint:CPMakePoint(50, 50) image:cappIcon];
    var startAngle = 5;

    [image setHoverStartFunction:function (event) {
        [image scaleByX:1.2 y:1.2];
    } endFunction:function (event) {
        [image scaleByX:1.0 y:1.0];
        [image animateWithDuration:1500 toNewAttributes:{'rotation': 0} animationCurve:RCAnimationEaseInOut];
        startAngle = 5;
    }];

    [image setClickFunction:function() {[image rotate:startAngle+=5];}];
*/


    //[circle animateWithDuration:2000 toNewAttributes:{'fill': 'red', 'cy': [raphaelView bounds].size.height - 20, 'r': 10} animationCurve:RCAnimationBounce];
}

#pragma mark -
#pragma mark WS Notification



@end





