//
// ModuleVetoDataListTabController.j
//
// Created by Philippe Fuentes.
//
@import <Foundation/Foundation.j>
@import <Foundation/CPObject.j>

//Permet de pouvoir utiliser les objets suivant lies aux tabs
@import "VetoDataList/ModuleColorDataListController.j"
@import "SpecieAndBreed/ModuleSpecieAndBreedDataListController.j"


@implementation ModuleDataListTabController : CPObject
{
    @outlet CPView _tabView;
  //  @outlet CPView _containerView;


    //@outlet ModuleColorDataListController     _colorDataListController;
}

- (id)init
{
    CPLog.info(@">>>> Entering ModuleDataListTabController::init");

    CPLog.info(@"<<<< Leaving ModuleDataListTabController::init");

    return self;
}


- (void)awakeFromCib
{
 //   CPLog.debug(@">>>> Entering TestTemplateTabController::awakeFromCib");

    [_tabView setBackgroundColor:[CPColor whiteColor]];


//    CPLog.debug(@"<<<< Leaving TestTemplateTabController::awakeFromCib");
}


- (void)refresh
{

}


//----o PUBLIC
#pragma mark -
#pragma mark Action



#pragma mark -
#pragma mark IB Action

/*
- (@action)testWS:(id)sender
{
    CPLog.info(@">>>> Entering ModuleDataListTabController::testGetChangesList");

    [[CPNotificationCenter defaultCenter] addObserver:self
                                        selector:@selector(_testWSNotification:)
                                        name:WSTestWSNotification object:nil];

    [[RequestManager sharedManager] performTestWS:"getSpeciesList"];


    CPLog.info(@"<<<< Leaving ModuleVetoDataListTabController::testGetChangesList");
}
*/


/*
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
}*/


@end





