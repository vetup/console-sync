/*
 * CPDate_CPJSONAware.j
 *
 * Based on code written and published by Tom Robinson (280 North - www.cappuccino.org) on January, 20, 2009.
 *
 * CP2JavaWS Objective-J classes and Java servlet are provided under LGPL License from Free software foundation (a copy is included in this
 * distribution).
 * This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 */

@import <Foundation/CPObject.j>
@import <Foundation/CPDate.j>

@implementation CPDate (CPJSONAware)


- (JSObject)toJSObject
{
    var result = {};
    result["__objjClassName"] = [[self class] className];
    result["__timestamp"] = self.getTime(); // returns ms since 1970 - equivalent to [self timeIntervalSince1970]*1000
    result["__timezoneOffset"] = self.getTimezoneOffset();// returns the offset in minutes. We could divide by 60 to get it in hours (GMT+/-x)
    // (but expected in ms in Java Timezone rawOffset)
    // (http://www.w3schools.com/jsref/jsref_getTimezoneOffset.asp)
    return result;
}

- (CPObject)initWithJSObject:(JSObject)obj
{
   return new Date(obj["__timestamp"]);
   // no Date.setTimezoneOffset, or use datejs lib
}

@end
