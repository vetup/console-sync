@import <Foundation/Foundation.j>
//@import <Foundation/CPObject.j>


@implementation Job : CPObject
{
    id              _delegate   @accessors(setter=setDelegate);
    Boolean         _started    @accessors(getter=isStarted, setter=setStarted);
    Boolean         _ready      @accessors(getter=isReady, setter=setReady);
}


- (id) init
{
 //   CPLog.info(@">>>> Entering Job::INIT");
    self = [super init];
    [self setReady:YES];

    return self;
}

// Must be overridden else the job will never end
- (void) start
{
 //   CPLog.info(@">>>> Entering Job::start TO BE OVERRIDEN !!!!");

    [self setStarted:YES];
}


- (void) cancel
{
    [self cleanRunningJobState];
}


- (void) cleanRunningJobState
{
    [self setStarted:NO];
}


- (void) jobTerminated
{
 //   CPLog.info(@">>>> Entering Job::jobTerminated");

    [self cleanRunningJobState];

    if ([_delegate respondsToSelector:@selector(JobDelegate_jobDidFinish:)])
    {
        CPLog.info(@">>>> Entering Job::respondsToSelector  !!!!!!!!!!!!!!!!!");
        [_delegate JobDelegate_jobDidFinish:self];
    }

 //   CPLog.info(@"<<<< Leaving Job::jobTerminated");
}



@end
