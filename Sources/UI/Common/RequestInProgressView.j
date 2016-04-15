@import <Foundation/Foundation.j>
@import <AppKit/CPView.j>

//@import <EKSpinner/EKSpinner.j>
@import "EKActivityIndicatorView.j"


//#define KBackgroundColor     [UIColor colorWithRed:(CGFloat)117/0xFF green:(CGFloat)50/0xFF blue:(CGFloat)86/0xFF alpha:1.0]
//+ (CPColor)colorWithRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha
var KBackgroundColor  = @"Available";


@implementation RequestInProgressView : CPView
{

    EKActivityIndicatorView _loadingIndicator;
}


- (id)initWithFrame:(CGRect)frame
{

    if ((self = [super initWithFrame:frame]))
    {

        //[self setBackgroundColor:[CPColor redColor]];
        [self setBackgroundColor:[CPColor colorWithRed:117/0xFF green:50/0xFF blue:86/0xFF alpha:0.2]];
        //[self setAlphaValue:0.2];
        [self setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];


        var rect  = frame;

//        var spinningSize = 18;
        var spinningSize = 25;

        rect.origin.x = frame.size.width / 2 - (spinningSize/2);
        rect.origin.y = frame.size.height / 2 - (spinningSize/2);
        rect.size.width = spinningSize;
        rect.size.height = spinningSize;


        _loadingIndicator = [[EKActivityIndicatorView alloc] initWithFrame:rect];

        //PF: 06/03/2014 - repositonnement auto de l'indicator pour qu'il reste au centre
        [_loadingIndicator setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin];

        [_loadingIndicator setColor:[CPColor colorWithHexString:@"404040"]];
        [_loadingIndicator startAnimating];
        [self addSubview:_loadingIndicator];

/*        _loadingIndicator = [[EKSpinner alloc] initWithFrame:rect andStyle:@"medium_black"];
        [_loadingIndicator setIsSpinning:YES];
        [self addSubview:_loadingIndicator];
*/
        [self hide];

        //[self setUserInteractionEnabled:false];


    }

    return self;
}

- (id)show
{
    [self setHidden:false];
}


- (id)hide
{
    [self setHidden:true];
}

- (void)setSpinnerPos:(float)x y:(float)y
{
    var frame = [_loadingIndicator frame];

//    CPLog.info(@">>>> Entering RequestInProgressView::setSpinnerPos:  %@" , [_loadingIndicator frame]);

    frame.origin.x = x;
    frame.origin.y = y;

    [_loadingIndicator setFrame:frame];
}

@end
