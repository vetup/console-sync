@import <Foundation/Foundation.j>
@import <AppKit/CPView.j>


@implementation EDHandCursorView : CPView
{

}

- (void)mouseEntered:(CPEvent)anEvent
{
   // CPLog.info(@"EDHandCursorView::mouseEntered");
    [[CPCursor pointingHandCursor] set];
  //  [super mouseEntered:anEvent];
}

- (void)mouseExited:(CPEvent)anEvent
{
   // CPLog.info(@"EDHandCursorView::mouseExited");
    [[CPCursor arrowCursor] set];
   // [super mouseExited:anEvent];
}



@end
