@import <Foundation/Foundation.j>
//@import <AppKit/CPButton.j>
@import <AppKit/CPTextField.j>
@import <AppKit/CPCursor.j>

//@import "LPViewAnimation.j"
@import <LPKit/LPViewAnimation.j>
@import "EDHandCursorView.j"


/**
Créé un bouton avec un effet de fade sur le over de la souris
Utilise les animation de la lib LPViewAnimation

LPViewAnimation dérive de CPAnimation, comme CPViewAnimation, mais surcharge startAnimation pour utilser les animations CSS3 si dispo, au lieu d'un timer

En effet, CPAnimation utilise un timer à priori, donc moins bien que la lib LPAnimation qui utilise CSS3 si dispo
http://www.cappuccino-project.org/learn/documentation/_c_p_animation_8j_source.html

*/
@implementation EDButtonWithEffect : CPView
//@implementation EDFlatButton : CPControl
{
    CPTextField         _title;
    CPView              _mouseoverView;
    EDHandCursorView    _handCursorView;
    CPView              _hightlightView;

    double              _duration;

//    LPViewAnimation _inAnimation;
//    LPViewAnimation _outAnimation;

    boolean _moveText;
}

#pragma mark -
#pragma mark Initialization

- (id)initWithFrame:(CGRect)iFrame fadeDuration:(double)iDuration moveText:(boolean)iMoveText
{
    if (self = [super initWithFrame:iFrame])
    {
        _duration = iDuration;
        _moveText = iMoveText
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


    if (_moveText)
    {
        _inAnimation    = [self _fadeAndTransXAnimation:_mouseoverView
                                targetTransX:_title
                                startFade:0.0
                                endFade:1.0
                                startTransX:0.0
                                endTransX:5.0
                                duration:_duration
                                ];

        _outAnimation   = [self _fadeAndTransXAnimation:_mouseoverView
                                targetTransX:_title
                                startFade:1.0
                                endFade:0.0
                                startTransX:5.0
                                endTransX:0.0
                                duration:_duration
                                ];

    }
    else
    {
        _inAnimation    = [self _fadeAnimation:_mouseoverView start:0.0 end:1.0 duration:_duration];
        _outAnimation   = [self _fadeAnimation:_mouseoverView start:1.0 end:0.0 duration:_duration];
    }

//    [_inAnimation setDelegate:self];
//    [_outAnimation setDelegate:self];



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


/*
        _inAnimation    = [self _fadeAndTransXAnimation:_mouseoverView
                                targetTransX:_title
                                startFade:0.0
                                endFade:1.0
                                startTransX:0.0
                                endTransX:5.0
                                duration:_duration
                                ];

        _outAnimation   = [self _fadeAndTransXAnimation:_mouseoverView
                                targetTransX:_title
                                startFade:1.0
                                endFade:0.0
                                startTransX:5.0
                                endTransX:0.0
                                duration:_duration
                                ];
*/

- (void)mouseEntered:(CPEvent)anEvent
{
  //  CPLog.info(@"EDFlatButton::mouseEntered");

    if ([anEvent type] == CPMouseEntered)
    {
        [[CPCursor pointingHandCursor] set];
    }

    var startX      = 0.0,
        startFade   = 0.0;

    if ([_outAnimation isAnimating])
    {
        [_outAnimation stopAnimation];
         //CPLog.info(@"_outAnimation STOPPED ");
        startX      = [_title frame].origin.x;
        startFade   = [_mouseoverView alphaValue];

    }

    //[_inAnimation startAnimation];
    if (_moveText)
    {
        _inAnimation    = [self _fadeAndTransXAnimation:_mouseoverView
                            targetTransX:_title
                            startFade:startFade
                            endFade:1.0
                            startTransX:startX
                            endTransX:5.0
                            duration:_duration
                            ];
    }
    else
    {
        _inAnimation    = [self _fadeAnimation:_mouseoverView start:startFade end:1.0 duration:_duration];
    }


    [_inAnimation startAnimation];


  //  self._DOMElement.style.webkitTransform = "scale(0.75)";
}

- (void)mouseExited:(CPEvent)anEvent
{
    //CPLog.info(@"EDFlatButton::mouseExited");

    if ([anEvent type] == CPMouseExited)
    {
        [[CPCursor arrowCursor] set];
    }

    var  startX      = 5.0,
         startFade   = 1.0;

    if ([_inAnimation isAnimating])
    {
        [_inAnimation stopAnimation];
        startX      = [_title frame].origin.x;
        startFade   = [_mouseoverView alphaValue];
//         CPLog.info(@"_inAnimation STOPPED :" + [_title frame].origin.x);
    }

   // [_outAnimation startAnimation];
    if (_moveText)
    {
        _outAnimation    = [self _fadeAndTransXAnimation:_mouseoverView
                            targetTransX:_title
                            startFade:startFade
                            endFade:0.0
                            startTransX:startX
                            endTransX:0.0
                            duration:_duration
                            ];

    }
    else
    {
       _outAnimation    = [self _fadeAnimation:_mouseoverView start:startFade end:0.0 duration:_duration];
    }

    [_outAnimation startAnimation];

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
             //   [LPOriginAnimationKey, CGPointMake(iStart,0), CGPointMake(iEnd,0)] // Can also have multiple animations on a single view


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


- (LPViewAnimation)_fadeAndTransXAnimation:(CPView)iTargetFade
                        targetTransX:(CPView)iTargetTransX
                        startFade:(double)iStartFade
                        endFade:(double)iEndFade
                        startTransX:(double)iStartTransX
                        endTransX:(double)iEndTransX
                        duration:(double)iDuration
{

    animation = [[LPViewAnimation alloc] initWithViewAnimations:[
        {
            @"target": iTargetFade,
            @"animations": [
                [LPFadeAnimationKey, iStartFade, iEndFade], // Can also have multiple animations on a single view
            ]
        },
        {
            @"target": iTargetTransX,
            @"animations": [
                [LPOriginAnimationKey, CGPointMake(iStartTransX,0), CGPointMake(iEndTransX,0)]
            ]
        }
    ]];

    [animation setDelegate:self];
    [animation setAnimationCurve:CPAnimationEaseOut]; //CPAnimationLinear, CPAnimationEaseOut
    [animation setDuration:iDuration];

    //PF: 24/09/2014 - si j'utulise les css animations, je ne peux pas récupérer le x actuel du title au moment ou je stop l'anim..
    //=> pour la gestion des tremblement quand on over la souris trop vite
    [animation setShouldUseCSSAnimations:NO];


/*
    if (LPCSSAnimationsAreAvailable)
    {
        [animation setShouldUseCSSAnimations:YES];
    }
    else
    {
        [animation setShouldUseCSSAnimations:NO];
    }
*/


    return animation;
}




//MARk: Notifications - animation
/*
- (void)animationDidEnd:(CPAnimation)animation
{
   // CPLog.info(@"animationDidEnd: " + animation);
}
*/


@end
