@import <Foundation/Foundation.j>

@import "./Job.j";

JobConcurrentQueueEmptyQueueNotification      =   @"JobConcurrentQueueEmptyQueueNotification";
JobConcurrentQueueJobTerminatedNotification   =   @"JobConcurrentQueueJobTerminatedNotification";

/**
Gestion d'une queue de job concurrent, qui s'exécutent en même temps.
*/

@implementation JobConcurrentQueue : CPObject
{
    CPMutableArray         _jobQueue;
}


#pragma mark -
#pragma mark Init / Dealloc

- (id)init
{
    self = [super init];
    _jobQueue = [[CPMutableArray alloc] init];
    return self;
}


//Le job est démarré tout de suite après l'ajout
- (void)addJobToQueue:(Job)job
{
    [_jobQueue addObject:job];
    [job setDelegate:self];
    [job start];
}

- (void)removeJobFromQueue:(Job)job
{
    [self _cancelJob:job];
    [self _removeJobFromQueue:job];
}

- (void)removeAllJobsFromQueue
{
    for (var i = 0;  i < [_jobQueue count]; i++)
    {
        var job = [_jobQueue objectAtIndex:i];

       [self _cancelJob:job];
    }

    if ([_jobQueue count] == 0)
    {
        [[CPNotificationCenter defaultCenter] postNotificationName:JobConcurrentQueueEmptyQueueNotification object:self];
    }

    while ([_jobQueue count] > 0)
    {
        [self _removeJobFromQueue:[_jobQueue lastObject]];
    }
}

- (BOOL)isJobInQueue:(Job)job
{
    return [_jobQueue containsObject:job];
}

- (void)_cancelJob:(Job)job
{
    if ([job isStarted])
    {
        [job cancel];
    }
}

- (void)_removeJobFromQueue:(Job)job
{
    [_jobQueue removeObject:job];
 //    CPLog.info(@">>>> Entering JobQueue::_removeJobFromQueue: %d", [_jobQueue count] );
}

#pragma mark JobDelegate

- (void)JobDelegate_jobDidFinish:(Job) job
{
    [[CPNotificationCenter defaultCenter] postNotificationName:JobConcurrentQueueJobTerminatedNotification object:job];
    [self _removeJobFromQueue:job];
}




@end
