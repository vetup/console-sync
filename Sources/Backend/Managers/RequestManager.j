//
// UserManager.j
//

@import <Foundation/CPObject.j>

@import "../Service/Jobs/WSLoginJob.j"
@import "../Service/Jobs/WSTestWSJob.j"
@import "../Service/Jobs/WSGetReferenceDataJob.j"
@import "../Service/Jobs/WSUpdateReferenceDataJob.j"
@import "../Service/Jobs/WSAddReferenceDataJob.j"
@import "../Service/Jobs/WSDeleteReferenceDataJob.j"
@import "../Service/Jobs/WSAnalyseReferenceDataJob.j"
@import "../Service/Jobs/WSSynchronizeReferenceDataJob.j"

@import "../Service/Jobs/WSGetCRVUsersJob.j"
@import "../Service/Jobs/WSDeleteCRVUsersJob.j"
@import "../Service/Jobs/WSDeleteCRVUserWithInvalidClinicIdJob.j"
@import "../Service/Jobs/WSMergeCRVUsersJob.j"
@import "../Service/Jobs/WSGetCRVUniqueUsersJob.j"



@import "../Service/JobsManagement/JobQueue.j";
@import "../Service/JobsManagement/JobConcurrentQueue.j";

var requestManagerSharedInstance = nil;

@implementation RequestManager : CPObject
{
    JobQueue            _jobQueue;
    JobConcurrentQueue  _jobConcurrentQueue;
}

+ (RequestManager)sharedManager
{
    if (requestManagerSharedInstance == nil)
    {
        requestManagerSharedInstance = [[RequestManager alloc] init];
    }

    return requestManagerSharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
        _jobQueue               = [[JobQueue alloc] init];
        _jobConcurrentQueue     = [[JobConcurrentQueue alloc] init];
    }
    return self;
}


#pragma mark -
#pragma mark Public

- (void)performLoginWithEmail:(CPString)email password:(CPString)password
{
//    CPLog.info(@">>>> Entering RequestManager::performLoginWithEmail");

    var loginJob = [[WSLoginJob alloc] initWithEmail:email password:password];
    [_jobQueue addJobToQueue:loginJob];

//    CPLog.info(@"<<<< Leaving RequestManager::performLoginWithEmail");
}

- (void)performGetReferenceData:(CPString)objectType
{
    CPLog.info(@">>>> Entering RequestManager::performGetReferenceData");

    var getReferenceDataJob = [[WSGetReferenceDataJob alloc] initWithObjectType:objectType];
    [_jobQueue addJobToQueue:getReferenceDataJob];
    CPLog.info(@"<<<< Leaving RequestManager::performGetReferenceData");
}

- (void)performUpdateReferenceData:(CPString)object
{
    CPLog.info(@">>>> Entering RequestManager::performUpdateReferenceData");

//_jobQueue = [[JobQueue alloc] init];

    var updateReferenceDataJob = [[WSUpdateReferenceDataJob alloc] initWithObject:object];
    [_jobQueue addJobToQueue:updateReferenceDataJob];

    CPLog.info(@"<<<< Leaving RequestManager::performUpdateReferenceData");
}

- (void)performAddReferenceData:(CPString)object
{
    CPLog.info(@">>>> Entering RequestManager::performAddReferenceData");

    var addReferenceDataJob = [[WSAddReferenceDataJob alloc] initWithObject:object];
    [_jobQueue addJobToQueue:addReferenceDataJob];

    CPLog.info(@"<<<< Leaving RequestManager::performAddReferenceData");
}

- (void)performDeleteReferenceData:(CPString)object
{
    CPLog.info(@">>>> Entering RequestManager::performDeleteReferenceData");

//_jobQueue = [[JobQueue alloc] init];

    var deleteReferenceDataJob = [[WSDeleteReferenceDataJob alloc] initWithObject:object];
    [_jobQueue addJobToQueue:deleteReferenceDataJob];

    CPLog.info(@"<<<< Leaving RequestManager::performDeleteReferenceData");
}

- (void)performSynchronizeReferenceData:(CPString)objectType
{
    CPLog.info(@">>>> Entering RequestManager::performSynchronizeReferenceData");
    var syncReferenceDataJob = [[WSSynchronizeReferenceDataJob alloc] initWithObjectType:objectType];
    [_jobQueue addJobToQueue:syncReferenceDataJob];
    CPLog.info(@"<<<< Leaving RequestManager::performSynchronizeReferenceData");
}

- (void)performAnalyseReferenceData:(CPString)objectType
{
    CPLog.info(@">>>> Entering RequestManager::performAnalyseReferenceData");
    var analyseReferenceDataJob = [[WSAnalyseReferenceDataJob alloc] initWithObjectType:objectType];
    [_jobConcurrentQueue addJobToQueue:analyseReferenceDataJob];
    CPLog.info(@"<<<< Leaving RequestManager::performAnalyseReferenceData");
}

//Utililisateurs CRV
- (void)performGetCRVUsers
{
    CPLog.info(@">>>> Entering RequestManager::performGetCRVUsers");
    var  getCRVUsersJob = [[WSGetCRVUsersJob alloc] init];
    [_jobConcurrentQueue addJobToQueue:getCRVUsersJob];
    CPLog.info(@"<<<< Leaving RequestManager::performGetCRVUsers");
}

- (void)performDeleteCRVUsers:(CPArray)emails
{
    CPLog.info(@">>>> Entering RequestManager::performDeleteCRVUsers");
    var  deletetCRVUsersJob = [[WSDeleteCRVUsersJob alloc] initWithEmails:emails];
    [_jobConcurrentQueue addJobToQueue:deletetCRVUsersJob];
    CPLog.info(@"<<<< Leaving RequestManager::performDeleteCRVUsers");
}

- (void)performDeleteCRVUserWithInvalidClinicId
{
    CPLog.info(@">>>> Entering RequestManager::performDeleteCRVUserWithInvalidClinicId");
    var  deletetCRVUserWithInvalidClinicIdJob = [[WSDeleteCRVUserWithInvalidClinicIdJob alloc] init];
    [_jobConcurrentQueue addJobToQueue:deletetCRVUserWithInvalidClinicIdJob];
    CPLog.info(@"<<<< Leaving RequestManager::performDeleteCRVUserWithInvalidClinicId");
}

- (void)performMergeCRVUsers:(CPArray)emails
{
    CPLog.info(@">>>> Entering RequestManager::performMergeCRVUsers");
    var  mergeCRVUsersJob = [[WSMergeCRVUsersJob alloc] initWithEmails:emails];
    [_jobConcurrentQueue addJobToQueue:mergeCRVUsersJob];
    CPLog.info(@"<<<< Leaving RequestManager::performMergeCRVUsers");
}

- (void)performGetCRVUniqueUsers
{
    CPLog.info(@">>>> Entering RequestManager::performGetCRVUniqueUsers");
    var  getCRVUniqueUsersJob = [[WSGetCRVUniqueUsersJob alloc] init];
    [_jobConcurrentQueue addJobToQueue:getCRVUniqueUsersJob];
    CPLog.info(@"<<<< Leaving RequestManager::performGetCRVUniqueUsers");
}


@end
