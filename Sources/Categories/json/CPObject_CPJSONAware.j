/*
 * CPObject_CPJSONAware.j
 *
 * Written and published by Tom Robinson (280 North - www.cappuccino.org) on January, 20, 2009.
 *
 * CP2JavaWS Objective-J classes and Java servlet are provided under LGPL License from Free software foundation (a copy is included in this
 * distribution).
 * This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 */

@import <Foundation/CPObject.j>

@implementation CPObject (CPJSONAware)


//PF: 30/12/2014 - je fais des ajustements sinon j'ai plein de merde en trop dans la sérialization, ça m'interesse pas
//
-(JSObject)toJSObject
{
    var result = {};

    //PF: je ne veux pas que ça se retrouve dans l'objet
    //result["__objjClassName"] = [[self class] className];

    for(var name in self)
    {
       //je contrôle $KVOPROXY sinon je pars en récursion cyclique...
       //je ne prend pas _UID c'est une truc interne a cappucino
        if(self.hasOwnProperty(name) && name != "isa" && name != "__address" && name != "$KVOPROXY" && name != "_UID")
        //if(self.hasOwnProperty(name) && name != "isa" && name != "__address")
        {
            //CPLog.debug(@"TEST name: %@  isa: %@  value: %@", name,  self[name].isa, self[name]);

            //PF: je check le type du isa, ça déconne complet sur les boolean...
        //if (self[name] && self[name].isa)
            if (self[name] && self[name].isa &&
                self[name].isa != "CPNumber" && self[name].isa != "CPString")
            {
                result[name] = [self[name] toJSObject];
            }
            else
            {
               result[name] = self[name];
            }
        }
        }

    return result;
}

+(CPObject)objectWithJSObject:(JSObject)obj
{
   if (!obj || obj["__objjClassName"] == undefined) // not an Objective-J object (or toll free bridged), just return itself
       return obj;

   var className = obj["__objjClassName"], // get the class name
       classObject = objj_lookUpClass(className); // lookup the class object by name

   return [[classObject alloc] initWithJSObject:obj]; // alloc a new instance, initialize it using obj
}

-(CPObject)initWithJSObject:(JSObject)obj
{
   for (var name in obj)
       if (name != "__objjClassName")
           self[name] = [CPObject objectWithJSObject:obj[name]]; // recursively copy the properties in

   return self;
}

@end
