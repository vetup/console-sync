@import <Foundation/CPObject.j>
@import "../Common/ServicesNotifications.j"
@import "./WSRequestJob.j"
@import "../Requests/WSGetVetupUsers.j"

@class DataManager;


@implementation WSGetVetupUsersJob : WSRequestJob
{
    CPNumber _pageSize;
    CPNumber _currentPage;
}

//- (id)initWithFilter:(CPString)filter
- (id)initWithData:(CPNumber)pageSize currentPage:(CPNumber)currentPage
{
//    CPLog.info(@">>>> Entering WSGetCRVUsersJob::INIT");

    if (self = [super initWithServiceNotification:WSGetVetupUsersNotification])
    {
        _pageSize = pageSize;
        _currentPage = currentPage;
    }
    return self;
}



// MARK: Job implementation

- (void)start
{
//    CPLog.info(@">>>> Entering WSGetCRVUsersJob::start ");

    var request = [[WSGetVetupUsers alloc] init];

    [request setPageSize:_pageSize];
    [request setCurrentPage:_currentPage];

    _request = request;

    [super start];
}

- (void)jobTerminated
{
//    CPLog.debug(@">>>> Entering WSGetReferenceDataJob::jobTerminated ");

/*
    var data                = [_request getData],
        vetupUsers          = [data objectForKey:"vetupUsers"];


    [[DataManager sharedManager] setVetupUsers:vetupUsers];
*/
    [super jobTerminated];

//    CPLog.info(@"<<<<< Leaving WSGetCRVUsersJob::jobTerminated ");
}

@end
