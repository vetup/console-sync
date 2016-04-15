@import <Foundation/Foundation.j>

@import "./Job.j";

JobQueueEmptyQueueNotification      =   @"JobQueueEmptyQueueNotification";
JobQueueJobTerminatedNotification   =   @"JobQueueJobTerminatedNotification";


/**
Gestion d'une queue de job, qui s'exécutent l'un après l'autre.
*/

@implementation JobQueue : CPObject
{
    CPMutableArray         _jobQueue;
    Job                    _currentJob;
}


#pragma mark -
#pragma mark Init / Dealloc

- (id)init
{

//     CPLog.info(@">>>> Entering JobQueue::INIT");

    self = [super init];
    _jobQueue = [[CPMutableArray alloc] init];
    return self;
}

- (void)addJobToQueue:(Job)job
{

 //   CPLog.info(@">>>> Entering JobQueue::addJobToQueue: %d", [_jobQueue count] );

    // Add the job to the queue : (but we must detect if the queue was empty before)
    if ([_jobQueue count] == 0)
    {
        // Make sure we always have one call to process next job pending

//PF: 03/12/2013 = n'existe pas en cappuccino
//PF: 22/06/2015 : Crash après jake deploy
        [CPObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_processNextJobInQueue) object:nil];
        [self performSelector:@selector(_processNextJobInQueue) withObject:nil afterDelay:0];
    }
    [_jobQueue addObject:job];

}


- (void) removeJobFromQueue:(Job)job
{
//  VSASSERT( [self isJobInQueue:job] );

    [self _cancelJob:job];
    [self _removeJobFromQueue:job];
}


- (void) removeAllJobsFromQueue
{
    // This will interrupt immediately the jobs, job's delegate (us) will not be called.

    for (var i = 0;  i < [_jobQueue count]; i++)
    {
        var job = [_jobQueue objectAtIndex:i];

       [self _cancelJob:job];
    }

    if ([_jobQueue count] == 0)
    {
        [[CPNotificationCenter defaultCenter] postNotificationName:JobQueueEmptyQueueNotification object:self];
    }

    while ([_jobQueue count] > 0)
    {
        [self _removeJobFromQueue:[_jobQueue lastObject]];
    }
}

- (BOOL) isJobInQueue:(Job)job
{
    return [_jobQueue containsObject:job];
}

- (Job) _getNextJobToStartInQueue
{
    // find the next job not started in the queue :

  //  CPLog.info(@">>>> Entering JobQueue::_getNextJobToStartInQueue");


    for (var i = 0;  i < [_jobQueue count]; i++)
    {
        var job = [_jobQueue objectAtIndex:i];

        if ( [job isReady] && ![job isStarted] )
        {
            return job;
        }

    }

  //  CPLog.info(@"<<<< Leaving JobQueue::_getNextJobToStartInQueue");

    return nil;
}


- (void) _processNextJobInQueue
{

  //  CPLog.info(@">>>> Entering JobQueue::_processNextJobInQueue");

    var job = [self _getNextJobToStartInQueue];

    if ( nil == job )
    {
        // Queue is empty
        [[CPNotificationCenter defaultCenter] postNotificationName:JobQueueEmptyQueueNotification object:self];
    }
    else
    {
        [self setCurrentJob:job];
        [job start];
    }

  //  CPLog.info(@"<<<< Leaving JobQueue::_processNextJobInQueue");
}


- (void) setCurrentJob:(Job) job
{
    if (job != _currentJob)
    {
        [_currentJob setDelegate:nil];
        [_currentJob release];
        _currentJob = [job retain];
        [_currentJob setDelegate:self];
    }
}

- (Job) currentJob
{
    return _currentJob;
}

- (void) _cancelJob:(Job)job
{
    if ([job isStarted])
    {
        [job cancel];
        [self setCurrentJob:nil];

        // do that after, in case we are in a global cancellation process.
        // Do it only if the job was started
        [CPObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_processNextJobInQueue) object:nil];
        [self performSelector:@selector(_processNextJobInQueue) withObject:nil afterDelay:0];
    }
}

- (void) _removeJobFromQueue:(Job)job
{
    [_jobQueue removeObject:job];

 //    CPLog.info(@">>>> Entering JobQueue::_removeJobFromQueue: %d", [_jobQueue count] );
}

#pragma mark JobDelegate

- (void) JobDelegate_jobDidFinish:(Job) job
{

//    CPLog.info(@">>>> Entering JobQueue::JobDelegate_jobDidFinish !!");

    [[CPNotificationCenter defaultCenter] postNotificationName:JobQueueJobTerminatedNotification object:job];

    [self setCurrentJob:nil];

    [self _removeJobFromQueue:job];

    [CPObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_processNextJobInQueue) object:nil];
    [self performSelector:@selector(_processNextJobInQueue) withObject:nil afterDelay:0];


    CPLog.info(@"<<<<< Leaving JobQueue::JobDelegate_jobDidFinish !!");
}




@end
