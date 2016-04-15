
@import <Foundation/Foundation.j>

@import <AppKit/CPTextField.j>
@import <AppKit/CPCursor.j>
@import <LPKit/LPViewAnimation.j>

@import "EDFlatFadeButton.j"

/**
Créé un bouton avec un effet de fade sur le over de la souris

*/
@implementation EDFlatFadeAndTextEffectButton : EDFlatFadeButton
{
    LPViewAnimation _moveInAnimation;
    LPViewAnimation _moveOutAnimation;
}

#pragma mark -
#pragma mark Initialization

- (id)initWithFrame:(CGRect)iFrame fadeDuration:(double)iDuration
{
    if (self = [super initWithFrame:iFrame fadeDuration:iDuration])
    {
        _moveInAnimation    = [self _translateXAnimation:_title start:0  end:5 duration:_duration];
        _moveOutAnimation   = [self _translateXAnimation:_title start:5 end:0 duration:_duration];
    }

    return self;
}


- (void)mouseEntered:(CPEvent)anEvent
{
    CPLog.info(@"EDFlatFadeAndTextEffectButton::mouseEntered");
        [super mouseEntered:anEvent];
    [_moveInAnimation startAnimation];

}

- (void)mouseExited:(CPEvent)anEvent
{
    CPLog.info(@"EDFlatFadeAndTextEffectButton::mouseExited");
    [super mouseExited:anEvent];
    [_moveOutAnimation startAnimation];
}

//----o PRIVATE

#pragma mark Privates

- (LPViewAnimation)_translateXAnimation:(CPView)iTarget start:(int)iStart end:(int)iEnd duration:(double)iDuration
{
    animation = [[LPViewAnimation alloc] initWithViewAnimations:[
    {
        @"target": iTarget,
        @"animations": [
            [LPOriginAnimationKey, CGPointMake(iStart,0), CGPointMake(iEnd,0)] // Can also have multiple animations on a single view
        ]
    }
    ]];

/*
     @"target": _imageView,
                @"animations": [
                    [LPOriginAnimationKey, CGPointMake(0,0), CGPointMake(-510,0)]
                ]
*/

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


@end
