@import <Foundation/Foundation.j>
@import <AppKit/CPView.j>

@implementation EDVideoPlayer : CPView
{
    id          _DOMVideoElement;
}

- (id)initWithFrame:(CGRect)iFrame
{
    if (self = [super initWithFrame:iFrame])
    {
        // Send notification anytime there is a frame resize.
        [self setPostsFrameChangedNotifications:YES];

        [[CPNotificationCenter defaultCenter]
            addObserver: self
            selector: @selector(_updateVideoSize:)
            name: @"CPViewFrameDidChangeNotification"
            object: self];

         [self setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

        [self _init:iFrame];
    }

    return self;
}

- (void)_init:(CGRect)iFrame
{

    CPLog.debug(@">>>> Entering EDVideoPlayer::_init:  width:%@  height:%@", iFrame.size.width, iFrame.size.height);

    //[self setBackgroundColor:[CPColor greenColor]];

//    _DOMVideoElement
    _DOMVideoElement = document.createElement("video");

    if (_DOMVideoElement == nil)
    {
        [CPException raise:@"Error" reason:@"La balise video n'existe pas"];
    }
    else
    {
        /*
<video width="320" height="240" controls>
  <source src="movie.mp4" type="video/mp4">
  <source src="movie.ogg" type="video/ogg">
  Your browser does not support the video tag.
</video>
        */
       // _DOMVideoElement.width  = "100";
       // _DOMVideoElement.height = "100";

        _DOMVideoElement.width    = iFrame.size.width;
        _DOMVideoElement.height   = iFrame.size.height;

        _DOMVideoElement.src = "test.mp4";
        _DOMVideoElement.type = "video/mp4";


        _DOMVideoElement.controls = true;


        // _DOMVideoElement.source.src  = "test.mp4";
        //_DOMVideoElement.source.type = "video/mp4";

        self._DOMElement.appendChild(_DOMVideoElement);

        //test
       // _DOMVideoElement.play();

    }
}

//---o Public
- (void)play
{
    _DOMVideoElement.play();
}

- (void)stop
{
    _DOMVideoElement.pause();
//    _DOMVideoElement.controls = false;
}


//---o Private
//Ajuster la taille de la balise vidéo en fonction du resize de la vue container
- (void)_updateVideoSize: (id) aNotification
{
    var frame = [self frame];

    _DOMVideoElement.width      = frame.size.width;
    _DOMVideoElement.height     = frame.size.height;

//    CPLog.debug(@">>>> EDVideoPlayer::_updateVideoSize - frame width: " + [self frame].size.width);
}





@end
