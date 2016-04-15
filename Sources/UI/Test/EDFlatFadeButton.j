@import <Foundation/Foundation.j>
//@import <AppKit/CPButton.j>
@import <AppKit/CPTextField.j>
@import <AppKit/CPCursor.j>

//@import "LPViewAnimation.j"
@import <LPKit/LPViewAnimation.j>
@import "EDHandCursorView.j"


/**
Créé un bouton avec un effet de fade sur le over de la souris

*/
@implementation EDFlatFadeButton : CPView
//@implementation EDFlatButton : CPControl
{
    CPTextField         _title;
    CPView              _mouseoverView;
    EDHandCursorView    _handCursorView;
    CPView              _hightlightView;

    double              _duration;

    LPViewAnimation _fadeInAnimation;
    LPViewAnimation _fadeOutAnimation;
}

#pragma mark -
#pragma mark Initialization

- (id)initWithFrame:(CGRect)iFrame fadeDuration:(double)iDuration
{
    if (self = [super initWithFrame:iFrame])
    {
        _duration = iDuration;
        [self _init:iFrame];
    }

    return self;
}

- (void)_init:(CGRect)iFrame
{
    //[self setBackgroundColor:[CPColor backColor]];
   // [self setBackgroundColor:[self valueForThemeAttribute:@"background-color"]];

   [self setBackgroundColor:[CPColor redColor]];

   var fullFrame = CGRectMake(0, 0, iFrame.size.width, iFrame.size.height);

    //Over color
    _mouseoverView = [[CPView alloc] initWithFrame:fullFrame];
   // [_mouseoverView setBackgroundColor:[CPColor greenColor]];
    [self addSubview:_mouseoverView];
    [_mouseoverView setAlphaValue:0];

    _hightlightView = [[CPView alloc] initWithFrame:fullFrame];
    [self addSubview:_hightlightView];
    [_hightlightView setHidden:YES];

    //Title
//  _title  = [[CPTextField alloc] initWithFrame:CGRectMake(44, 5, aFrame.size.width - 44, 20)];
    _title  = [[CPTextField alloc] initWithFrame:fullFrame];

    [_title setCenter:CGPointMake(iFrame.size.width / 2.0 , iFrame.size.height / 2.0)];
//    [_title setCenter:CGPointMake(centerX , centerY)];

    [_title setValue:CPCenterTextAlignment forThemeAttribute:@"vertical-alignment"];
    [_title setValue:CPCenterTextAlignment forThemeAttribute:@"alignment"];

    var inset = CGInsetMake(10, 10, 10, 10);
    [_title setValue:inset forThemeAttribute:@"content-inset"];

 //   [_title setTextColor:[CPColor whiteColor]];
 //   [_title setTextColor:[self valueForThemeAttribute:@"text-color"]];
    [_title setTextColor:[CPColor whiteColor]];
    [_title setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [_title setLineBreakMode:CPLineBreakByWordWrapping];

    [_title setStringValue:@"TEST"];
    [_title setEditable:NO];

    [self addSubview:_title];


    _fadeInAnimation    = [self _fadeAnimation:_mouseoverView start:0.0 end:1.0 duration:_duration];
    _fadeOutAnimation   = [self _fadeAnimation:_mouseoverView start:1.0 end:0.0 duration:_duration];
    [_fadeInAnimation setDelegate:self];
    [_fadeOutAnimation setDelegate:self];


    //Une vue par dessus qui affiche juste le cursor main
    _handCursorView = [[EDHandCursorView alloc] initWithFrame:fullFrame];
    [self addSubview:_handCursorView];


//TEST
  //  [self setValue:3.0 forThemeAttribute:@"corner-radius"];

//- (LPViewAnimation)_fadeAnimation:(CPView)iTarget start:(double)iStart end:(double)iEnd duration:(double)iDuration
}

- (void)setTitle:(CPString)iTitle
{
    [_title setStringValue:iTitle];
}


/*

        _title  = [[CPTextField alloc] initWithFrame:CGRectMake(44, 5, aFrame.size.width - 44, 20)];
        [_title setStringValue:aTitle];
        [_title setFont:[CPFont boldSystemFontOfSize:12]];
        [_title setTextColor:[CPColor whiteColor]];
        [_title setAutoresizingMask:CPViewWidthSizable];
        [self addSubview:_title];

        // message
        _message = [[CPTextField alloc] initWithFrame:CGRectMake(44, 20, aFrame.size.width - 50, aFrame.size.height - 25)];
        [_message setStringValue:aMessage];
        [_message setLineBreakMode:CPLineBreakByWordWrapping];
        [_message setAutoresizingMask:CPViewHeightSizable | CPViewWidthSizable];
        [_message setTextColor:[self valueForThemeAttribute:@"text-color"]];
        [self addSubview:_message];

        // background
        [self setBackgroundColor:[self valueForThemeAttribute:@"background-color"]];
        [self setAlphaValue:[self valueForThemeAttribute:@"alpha-value"]];

*/

- (void)setTextFont:(CPFont)aFont
{
    [_title setFont:aFont];
}

- (void)setColor:(CPColor)aColor
{
    [self setBackgroundColor:aColor];
}

- (void)setTextColor:(CPColor)aColor
{
    [_title setTextColor:aColor];
}

- (void)setMouseHoverColor:(CPColor)aColor
{
    [_mouseoverView setBackgroundColor:aColor];
}

- (void)setHighlightColor:(CPColor)aColor
{
    [_hightlightView setBackgroundColor:aColor];
}

- (void)mouseEntered:(CPEvent)anEvent
{
    CPLog.info(@"EDFlatButton::mouseEntered");
 //   [self setThemeState:CPThemeStateHighlighted];

  //  [super mouseEntered:anEvent];

    if ([anEvent type] == CPMouseEntered)
    {
        [[CPCursor pointingHandCursor] set];
    }


    [_fadeInAnimation startAnimation];



  //  self._DOMElement.style.webkitTransform = "scale(0.75)";
}

- (void)mouseExited:(CPEvent)anEvent
{
    CPLog.info(@"EDFlatButton::mouseExited");
//    [super mouseExited:anEvent];

    if ([anEvent type] == CPMouseExited)
    {
        [[CPCursor arrowCursor] set];
    }
  //  [self unsetThemeState:CPThemeStateHighlighted];

    [_fadeOutAnimation startAnimation];



  //  self._DOMElement.style.webkitTransform = "scale(1)";
}

- (void)mouseDown:(CPEvent)anEvent
{
    CPLog.info(@"EDFlatButton::mouseDown");

    if ([anEvent type] == CPLeftMouseDown)
    {
        [_hightlightView setHidden:NO];
    }

    [super mouseDown:anEvent];
}

- (void)mouseUp:(CPEvent)anEvent
{
    CPLog.info(@"EDFlatButton::mouseUp");

    if ([anEvent type] == CPLeftMouseUp)
    {
        [_hightlightView setHidden:YES];
    }

    [super mouseUp:anEvent];
}



/*
- (void)mouseEntered:(CPEvent)anEvent
{
    if ([anEvent type] == CPMouseEntered)
    {
        [_timer invalidate];
        [self setAlphaValue:1.0];
    }

    [super mouseEntered:anEvent];
}

*/


//----o PRIVATE

#pragma mark Privates

- (LPViewAnimation)_fadeAnimation:(CPView)iTarget start:(double)iStart end:(double)iEnd duration:(double)iDuration
{
    animation = [[LPViewAnimation alloc] initWithViewAnimations:[
    {
        @"target": iTarget,
        @"animations": [
            [LPFadeAnimationKey, iStart, iEnd] // Can also have multiple animations on a single view
        ]
    }
    ]];
    [animation setDelegate:self];
    [animation setAnimationCurve:CPAnimationLinear]; //CPAnimationLinear
    [animation setDuration:iDuration];
    if (LPCSSAnimationsAreAvailable)
    {
        [animation setShouldUseCSSAnimations:YES];
    }
    else
    {
        [animation setShouldUseCSSAnimations:NO];
    }

    return animation;
}



- (void)_transitionFadeOut:(double)iDuration
{
    animation = [[LPViewAnimation alloc] initWithViewAnimations:[
    {
        @"target": self,
        @"animations": [
            [LPFadeAnimationKey, 1.0, 0.0] // Can also have multiple animations on a single view
        ]
    }
    ]];

   // [animation setDelegate:self];
    [animation setAnimationCurve:CPAnimationEaseInOut];
    [animation setDuration:0.2];
    if (LPCSSAnimationsAreAvailable)
    {
        [animation setShouldUseCSSAnimations:YES];
    }
    else
    {
        [animation setShouldUseCSSAnimations:NO];
    }
    [animation startAnimation];
}

//MARk: Notifications - animation
- (void)animationDidEnd:(CPAnimation)animation
{
    CPLog.info(@"animationDidEnd: " + animation);
}
/*

-(void)animationDidEnd:(CPAnimation)animation
{
    [_imageView setImage:[_secondView image]];
    if (_isFading)
    {
        [self transitionFadeIn:[_secondView image] withLength:[animation duration]];
    }
    else
    {
        [_imageView setFrameOrigin:CGPointMake(0,0)];
        [_imageView setAlphaValue:1.0];
        [_secondView setAlphaValue:0.0];
        [_secondView setFrameOrigin:CGPointMake(0,0)];
        if (LPCSSAnimationsAreAvailable)
        {
            [animation _clearCSS];
            _imageView._DOMElement.style["-webkit-transform"] = "translate(0px, 0px)";
            _secondView._DOMElement.style["-webkit-transform"] = "translate(0px, 0px)";
        }
        _transitionIsRunning = NO;
        if (_captionIndexOfRunningTransition >= 0)
        {
            [self showCaption:_captionIndexOfRunningTransition];
            _captionIndexOfRunningTransition = -1;
        }
    }
}
*/

/*
- (void)transitionFadeOut:(CPView)iView withLength:(double)aLength
{
    _isFading = YES;
    [_imageView setAlphaValue:1.0];
    [_secondView setAlphaValue:0.0];
    [_secondView setImage:newImage];
    animation = [[LPViewAnimation alloc] initWithViewAnimations:[
    {
        @"target": _imageView,
        @"animations": [
            [LPFadeAnimationKey, 1.0, 0.0] // Can also have multiple animations on a single view
        ]
    }
    ]];
    [animation setDelegate:self];
    [animation setAnimationCurve:CPAnimationEaseInOut];
    [animation setDuration:aLength];
    if (LPCSSAnimationsAreAvailable)
    {
        [animation setShouldUseCSSAnimations:YES];
    }
    else
    {
        [animation setShouldUseCSSAnimations:NO];
    }
    [animation startAnimation];
}
*/

@end
