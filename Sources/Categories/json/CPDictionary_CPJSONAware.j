/*
 * CPArray_CPJSONAware.j
 *
 * Created by Jerome Denanot on January, 24,2009.
 * Copyright 2009 Jerome Denanot.
 * Based on Cappuccino framework (http://www.cappuccino.org) available under LGPL license (GNU Lesser General Public License).
 *
 * CP2JavaWS Objective-J classes and Java servlet are provided under LGPL License from Free software foundation (a copy is included in this
 * distribution).
 * This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 */

@import <Foundation/Foundation.j>
@import <Foundation/CPObject.j>
@import <Foundation/CPEnumerator.j>
@import <Foundation/CPArray.j>

@implementation CPDictionary (CPJSONAware)


// uses internal javascript CPDictionary representation for better performance
// (avoids calls to objj runtime), but would be impacted by its changes.
-(JSObject)toJSObject
{
	var result = {};
	result["__objjClassName"] = [[self class] className]; // a dictionary cannot be represented using a javascript/json array,
	// ["key1":{}, "key2":{}] isn't valid. So we have to use a regular javascript/json representation : {"key1":{}, "key2":{}}
	// Then we have to pass the __objjClassName to identify the collection from other objects on the server-side (not required for CPArray
	// as we can test for the presence of []).
	for(var keyIndex in this._keys) {
		if(keyIndex!="isa") {
			var keyName = this._keys[keyIndex];
			result[keyName] = [this._buckets[keyName] toJSObject];
		}
	}
	/*var keysEnum = [self keyEnumerator];
	//var keysArray = [keysEnum allObjects]; // actual implementation returns an empty array
	for(var key in keysEnum._array) { // _array is the internal keys array
		result[key] = [[self objectForKey:key] toJSObject];
	}*/
	return result;
}

@end
