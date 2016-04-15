@import <Foundation/Foundation.j>
@import <AppKit/CPView.j>


@implementation EDHandCursorView : CPView
{
    id _delegate  @accessors(property=delegate);
}

- (void)mouseEntered:(CPEvent)anEvent
{
//    CPLog.debug(@"EDHandCursorView::mouseEntered");
    [[CPCursor pointingHandCursor] set];
  //  [super mouseEntered:anEvent];
     [_delegate handCursorViewMouseEntered:anEvent];
}

- (void)mouseExited:(CPEvent)anEvent
{
//    CPLog.debug(@"EDHandCursorView::mouseExited");
    [[CPCursor arrowCursor] set];
   // [super mouseExited:anEvent];
     [_delegate handCursorViewMouseExited:anEvent];
}

- (void)mouseUp:(CPEvent)anEvent
{
//     CPLog.debug(@"EDHandCursorView::mouseUp");
     [_delegate handCursorViewMouseUp:anEvent];
}


@end
