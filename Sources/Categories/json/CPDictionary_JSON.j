
@import <Foundation/Foundation.j>
@import <Foundation/CPObject.j>
@import <Foundation/CPEnumerator.j>
//@import <Foundation/CPArray.j>

@implementation CPDictionary (JSON)


//PF: 13/05/2016: référence: http://beginnercappuccino.blogspot.co.uk/2014/06/cappuccino-data-serialization.html

// uses internal javascript CPDictionary representation for better performance
// (avoids calls to objj runtime), but would be impacted by its changes.
- (JSObject)toJSObject
{
    var keys = [self keyEnumerator],
        object = {},
        string = Nil,
        data = Nil,
        key = Nil;

    while (key = [keys nextObject])
    {
        string = key;
        data = [self objectForKey:key];
        object[ string ] = data;
    }
    return object;
}


@end
