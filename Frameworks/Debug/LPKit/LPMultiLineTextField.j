/*
 * LPMultiLineTextField.j
 *
 * Created by Ludwig Pettersson on January 22, 2010.
 *
 * The MIT License
 *
 * Copyright (c) 2010 Ludwig Pettersson
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */
@import <AppKit/CPTextField.j>

var CPTextFieldInputOwner = nil,
    CPTextFieldInputResigning = NO,
    CPTextFieldInputDidBlur = NO,
    CPTextFieldInputIsActive = NO,
    CPTextFieldBlurFunction;

@implementation LPMultiLineTextField : CPTextField
{
    id          _DOMTextareaElement;
    BOOL        _hideOverflow;
}

- (DOMElement)_DOMTextareaElement
{
    if (!_DOMTextareaElement)
    {
        _DOMTextareaElement = document.createElement("textarea");
        _DOMTextareaElement.style.position = @"absolute";
        _DOMTextareaElement.style.background = @"none";
        _DOMTextareaElement.style.border = @"0";
        _DOMTextareaElement.style.outline = @"0";
        _DOMTextareaElement.style.zIndex = @"100";
        _DOMTextareaElement.style.resize = @"none";
        _DOMTextareaElement.style.padding = @"0";
        _DOMTextareaElement.style.margin = @"0";
        _DOMTextareaElement.style.overflow = @"auto";
        _hideOverflow = NO;

        CPTextFieldBlurFunction = function()
        {
            if (!CPTextFieldInputResigning)
            {
                // The input element can easily lose focus while we still want it to be focused for various browser reasons.
                // As long as we're first responder in the key window, the input element should be focused.
                window.setTimeout(function()
                    {
                        if (!CPTextFieldInputOwner || CPTextFieldInputOwner !== self)
                            return;
                        var theWindow = [CPTextFieldInputOwner window];
                        if ([CPApp keyWindow] === theWindow && [theWindow firstResponder] === CPTextFieldInputOwner)
                            _DOMTextareaElement.focus();
                    }, 0.0);

                return;
            }

            CPTextFieldInputOwner = nil;

            [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];

            CPTextFieldInputDidBlur = YES;
        };

        CPTextFieldInputFunction = function()
        {
            [CPTextFieldInputOwner _setValueFromElement];
        };

        _DOMTextareaElement.onblur = CPTextFieldBlurFunction;

        _DOMTextareaElement.oninput = CPTextFieldInputFunction;

        self._DOMElement.appendChild(_DOMTextareaElement);
    }

    return _DOMTextareaElement;
}

- (BOOL)isScrollable
{
   return !_hideOverflow;
}

- (void)setScrollable:(BOOL)shouldScroll
{
    _hideOverflow = !shouldScroll;

    [self _DOMTextareaElement].style.overflow = shouldScroll ? @"auto" : @"hidden";
}

- (void)setEditable:(BOOL)shouldBeEditable
{
    [self _DOMTextareaElement].style.cursor = shouldBeEditable ? @"cursor" : @"default";
    // Prevent the textarea from accepting input when it should be disabled
    [self _DOMTextareaElement].disabled = !shouldBeEditable;
    [super setEditable:shouldBeEditable];
}

- (void)selectText:(id)sender
{
    [self _DOMTextareaElement].select();
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    var contentView = [self layoutEphemeralSubviewNamed:@"content-view"
                                             positioned:CPWindowAbove
                        relativeToEphemeralSubviewNamed:@"bezel-view"];
    [contentView setHidden:YES];

    var DOMElement = [self _DOMTextareaElement],
        contentInset = [self currentValueForThemeAttribute:@"content-inset"],
        bounds = [self bounds];

    DOMElement.style.top = contentInset.top + @"px";
    DOMElement.style.bottom = contentInset.bottom + @"px";
    DOMElement.style.left = contentInset.left + @"px";
    DOMElement.style.right = contentInset.right + @"px";

    DOMElement.style.width = MAX(0.0, (CGRectGetWidth(bounds) - contentInset.left - contentInset.right)) + @"px";
    DOMElement.style.height = MAX(0.0, (CGRectGetHeight(bounds) - contentInset.top - contentInset.bottom)) + @"px";

    DOMElement.style.color = [[self currentValueForThemeAttribute:@"text-color"] cssString];
    DOMElement.style.font = [[self currentValueForThemeAttribute:@"font"] cssString];

    switch ([self currentValueForThemeAttribute:@"alignment"])
    {
        case CPLeftTextAlignment:
            DOMElement.style.textAlign = "left";
            break;
        case CPJustifiedTextAlignment:
            DOMElement.style.textAlign = "justify"; //not supported
            break;
        case CPCenterTextAlignment:
            DOMElement.style.textAlign = "center";
            break;
        case CPRightTextAlignment:
            DOMElement.style.textAlign = "right";
            break;
        default:
            DOMElement.style.textAlign = "left";
    }

    //  We explicitly want a placeholder when the value is an empty string.
    if ([self hasThemeState:CPTextFieldStatePlaceholder])
    {
        DOMElement.value = [self placeholderString];
    }
    else if (DOMElement.value != [self stringValue])
    {
        // Due to a bug in WebKit we can't change the text area value when the field is focused and
        // the cursor is placed within the current value. If we do, the text area stops showing its
        // cursor and stops accepting text (although it still thinks it's focused).
        DOMElement.blur();
        DOMElement.value = [self stringValue];
        DOMElement.focus();
    }

    if (_hideOverflow)
        DOMElement.style.overflow = @"hidden";
}

- (void)scrollWheel:(CPEvent)anEvent
{
    var DOMElement = [self _DOMTextareaElement];
    DOMElement.scrollLeft += anEvent._deltaX;
    DOMElement.scrollTop += anEvent._deltaY;
}

- (void)mouseDown:(CPEvent)anEvent
{
    if ([self isEditable] && [self isEnabled])
        [[[self window] platformWindow] _propagateCurrentDOMEvent:YES];
    else
        [super mouseDown:anEvent];
}

- (void)mouseDragged:(CPEvent)anEvent
{
    return [[[anEvent window] platformWindow] _propagateCurrentDOMEvent:YES];
}

- (void)keyDown:(CPEvent)anEvent
{
    if ([anEvent keyCode] === CPTabKeyCode)
    {
        if ([anEvent modifierFlags] & CPShiftKeyMask)
            [[self window] selectPreviousKeyView:self];
        else
            [[self window] selectNextKeyView:self];

        if ([[[self window] firstResponder] respondsToSelector:@selector(selectText:)])
            [[[self window] firstResponder] selectText:self];

        [[[self window] platformWindow] _propagateCurrentDOMEvent:NO];
    }
    else
        [[[self window] platformWindow] _propagateCurrentDOMEvent:YES];

    [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];
}

- (void)keyUp:(CPEvent)anEvent
{
    [self _setValueFromElement];

    [[[self window] platformWindow] _propagateCurrentDOMEvent:YES];
}

- (void)_setValueFromElement
{
    var oldStringValue = [self stringValue];
    [self _setStringValue:[self _DOMTextareaElement].value];

    if (oldStringValue !== [self stringValue])
    {
        if (!_isEditing)
        {
            _isEditing = YES;
            [self textDidBeginEditing:[CPNotification notificationWithName:CPControlTextDidBeginEditingNotification object:self userInfo:nil]];
        }

        [self textDidChange:[CPNotification notificationWithName:CPControlTextDidChangeNotification object:self userInfo:nil]];
    }
}

- (BOOL)becomeFirstResponder
{
    [self setThemeState:CPThemeStateEditing];
    [self _updatePlaceholderState];

    setTimeout(function() {
        [self _DOMTextareaElement].focus();
        CPTextFieldInputOwner = self;
    }, 0.0);

    [self textDidFocus:[CPNotification notificationWithName:CPTextFieldDidFocusNotification object:self userInfo:nil]];

    CPTextFieldInputIsActive = YES;

    return YES;
}

- (BOOL)resignFirstResponder
{
    [self unsetThemeState:CPThemeStateEditing];
    [self _updatePlaceholderState];
    [self setStringValue:[self stringValue]];

    CPTextFieldInputResigning = YES;

    if (CPTextFieldInputIsActive)
        [self _DOMTextareaElement].blur();

    if (!CPTextFieldInputDidBlur)
        CPTextFieldBlurFunction();

    CPTextFieldInputDidBlur = NO;
    CPTextFieldInputResigning = NO;
    CPTextFieldInputIsActive = NO;

    //post CPControlTextDidEndEditingNotification
    if (_isEditing)
    {
        _isEditing = NO;
        [self textDidEndEditing:[CPNotification notificationWithName:CPControlTextDidEndEditingNotification object:self userInfo:nil]];

        if ([self sendsActionOnEndEditing])
            [self sendAction:[self action] to:[self target]];
    }

    [self textDidBlur:[CPNotification notificationWithName:CPTextFieldDidBlurNotification object:self userInfo:nil]];

    return YES;
}

- (void)_setStringValue:(id)aValue
{
    [self willChangeValueForKey:@"objectValue"];
    [super setObjectValue:String(aValue)];
    [self _updatePlaceholderState];
    [self didChangeValueForKey:@"objectValue"];
}

- (void)setObjectValue:(id)aValue
{
    [super setObjectValue:aValue];

    if (CPTextFieldInputOwner === self || [[self window] firstResponder] === self)
        [self _DOMTextareaElement].value = aValue;

    [self _updatePlaceholderState];
}

- (void)_setCurrentValueIsPlaceholder:(BOOL)isPlaceholder
{
    //  Under certain circumstances, _originalPlaceholderString is empty.
    if (!_originalPlaceholderString)
        _originalPlaceholderString = [self placeholderString];

    [super _setCurrentValueIsPlaceholder:isPlaceholder];
}

@end


var LPMultiLineTextFieldScrollableKey = "LPMultiLineTextFieldScrollableKey";

@implementation LPMultiLineTextField (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    if (self = [super initWithCoder:aCoder])
    {
        var scrollable = [aCoder decodeBoolForKey:LPMultiLineTextFieldScrollableKey];

        // Make sure the textarea scrollbars no inadvertantly disabled with a
        // nil value
        if (scrollable === NO)
            [self setScrollable:NO];
    }
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeBool:[self isScrollable] forKey:LPMultiLineTextFieldScrollableKey];
}

@end
