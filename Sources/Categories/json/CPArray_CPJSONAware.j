/*
 * CPArray_CPJSONAware.j
 *
 * Created by Jerome Denanot on January,24,2009.
 * Copyright 2009 Jerome Denanot.
 * Based on Cappuccino framework (http://www.cappuccino.org) available under LGPL license (GNU Lesser General Public License).
 *
 * CP2JavaWS Objective-J classes and Java servlet are provided under LGPL License from Free software foundation (a copy is included in this
 * distribution).
 * This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 */

@import <Foundation/CPObject.j>
@import <Foundation/CPArray.j>

@implementation CPArray (CPJSONAware)

// uses internal javascript array representation for better performance
// (avoids calls to objj_msgSend runtime). Not impacted by future evolutions
// as CPArray is equivalent to array (toll-free bridge).
- (JSObject)toJSObject
{
    var result = [];
//PF: 30/12/2014 - pas this mais self...
//	for(var i=0; i< this.length;i++)
	for(var i=0; i< self.length;i++)
    {
//		result[i] = [this[i] toJSObject];
		result[i] = [self[i] toJSObject];
	}
	return result;
}

@end
