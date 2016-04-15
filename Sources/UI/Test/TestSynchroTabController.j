//
// TestSynchroTabController.j
//
// Created by Philippe Fuentes.
//
@import <Foundation/Foundation.j>
@import <Foundation/CPObject.j>
@import "../../Backend/Managers/RequestManager.j"

@class RequestManager;

@implementation TestSynchroTabController : CPObject
{
    @outlet CPView _tabView;
    @outlet CPView _containerView;
}

- (id)init
{
    CPLog.info(@">>>> Entering TestSynchroTabController::init");

    CPLog.info(@"<<<< Leaving TestSynchroTabController::init");

    return self;
}


- (void)awakeFromCib
{
 //   CPLog.debug(@">>>> Entering TestSynchroTabController::awakeFromCib");

    [_tabView setBackgroundColor:[CPColor whiteColor]];


//    CPLog.debug(@"<<<< Leaving TestSynchroTabController::awakeFromCib");
}


- (void)refresh
{

}


//----o PUBLIC
#pragma mark -
#pragma mark Action



#pragma mark -
#pragma mark IB Action
- (@action)testGetChangesList:(id)sender
{
    CPLog.info(@">>>> Entering TestSynchroTabController::testGetChangesList");

    [[CPNotificationCenter defaultCenter] addObserver:self
                                        selector:@selector(_testWSNotification:)
                                        name:WSTestWSNotification object:nil];

    [[RequestManager sharedManager] performTestWS:"getChangesList"];


    CPLog.info(@"<<<< Leaving TestSynchroTabController::testGetChangesList");
}

- (@action)testGetObject:(id)sender
{
    CPLog.info(@">>>> Entering TestSynchroTabController::testGetObject");

    [[CPNotificationCenter defaultCenter] addObserver:self
                                        selector:@selector(_testWSNotification:)
                                        name:WSTestWSNotification object:nil];

    [[RequestManager sharedManager] performTestWS:"getObject"];


    CPLog.info(@"<<<< Leaving TestSynchroTabController::testGetObject");
}

- (@action)testSetObject:(id)sender
{
    CPLog.info(@">>>> Entering TestSynchroTabController::testSetObject");

    [[CPNotificationCenter defaultCenter] addObserver:self
                                        selector:@selector(_testWSNotification:)
                                        name:WSTestWSNotification object:nil];

    [[RequestManager sharedManager] performTestWS:"setObject"];


    CPLog.info(@"<<<< Leaving TestSynchroTabController::testSetObject");
}


#pragma mark -
#pragma mark Private



#pragma mark -
#pragma mark WS Notification

- (void)_testWSNotification:(CPNotification)notification;
{
     CPLog.info(@">>>> Entering _testWSNotification");

    [[CPNotificationCenter defaultCenter] removeObserver:self name:WSTestWSNotification object:nil];

    //[[AppController appDelegate] stopProgress];

    var userInfo = [notification userInfo];

    var error = [userInfo objectForKey:ServicesErrorKey];

   // [[AppController appDelegate] stopProgress];

    if (nil == error)
    {
        var job = [userInfo objectForKey:ServicesJobKey];
        var request = [job request];
    }

    CPLog.info(@"<<<< Leaving _testWSNotification");
}

@end





