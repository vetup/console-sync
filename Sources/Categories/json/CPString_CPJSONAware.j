/*
 * CPString_CPJSONAware.j
 *
 * Written and published by Tom Robinson (280 North - www.cappuccino.org) on January, 20, 2009.
 *
 * CP2JavaWS Objective-J classes and Java servlet are provided under LGPL License from Free software foundation (a copy is included in this
 * distribution).
 * This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 */

@import <Foundation/CPObject.j>
@import <Foundation/CPString.j>

@implementation CPString (CPJSONAware)



- (JSObject)toJSObject
{
    return self;
}

@end
