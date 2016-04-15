@import <Foundation/CPObject.j>




@implementation Tools : CPObject
{


}

+(BOOL)checkEmailFormat:(CPString)iEmail
{
    var email = iEmail;
    if ([email length] > 0)
    {
        var re_email = /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*$/ ;

        return re_email.test(email);
    }

    return NO;
}


+(BOOL)checkStringLength:(CPString)iStr length:(int)iLength
{
    return ([iStr length] >= iLength);
}


+(Object)dictionaryToJSObject:(CPDictionary)iDict
{
    var allKeys = [iDict allKeys];
    var obj = new Object();

    var key = nil;
    var value = nil;
    for (var i=0; i < [allKeys count]; i++)
    {
        key = allKeys[i];
        obj[key] = [iDict objectForKey:key];
    }

    return obj;
}

@end

/*

Tools = function()
{

}

Tools.prototype.checkEmailFormat = function(iEmail)
{
//    var email = [iEmail stringValue];
    var email = iEmail;
    if ([email length] > 0)
    {
        var re_email = /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*$/ ;

        return re_email.test(email);
    }

    return NO;
}

*/
