//
// ModuleTemplateTabController.j
//
// Created by Philippe Fuentes.
//
@import <Foundation/Foundation.j>
@import <Foundation/CPObject.j>


@implementation ModuleTemplateTabController : CPObject
{
    @outlet CPView _tabView;
    @outlet CPView _containerView;
}

- (id)init
{
    CPLog.info(@">>>> Entering ModuleTemplateTabController::init");

    CPLog.info(@"<<<< Leaving ModuleTemplateTabController::init");

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


#pragma mark -
#pragma mark Private



#pragma mark -
#pragma mark WS Notification



@end





