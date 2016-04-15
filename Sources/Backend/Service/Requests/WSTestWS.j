@import <Foundation/CPObject.j>
@import "../Common/WSBaseRequest.j"

//WSTestSubPath    = @"jsonvetoonline/sync"
WSTestSubPath    = @"jsonconsole/sync"

//ne pas faire d'include de UserManager car import cyclique ! (UserManager import WSLoginJob->WSLogin)
@class UserManager;



@implementation WSTestWS : WSBaseRequest
{
    /*
    //Input request parameter
    CPString        _email       @accessors(setter=setEmail);
    CPString        _password    @accessors(setter=setPassword);

    //Output request parameter
    CPString        _uid        @accessors(getter=getUid);
    CPString        _name       @accessors(getter=getName);
    CPString        _role       @accessors(getter=getRole);
    */

    CPString        _function       @accessors(setter=setFunction);

}

// MARK: Init/dealloc

- (id) init
{
    CPLog.info(@">>>> Entering WSTestWS::INIT");

    if (self = [super init])
    {
        _subpath = WSTestSubPath;
    }
    return self;
}


- (void) start
{
    //  urlAddress = @"DUMMYhttp://eussam.hd.free.fr:8080/vcc/bin-debug/restmessagebroker/rest/?method=getUserByEmailAndPass&arg1=Toto&arg2=Tata";

    CPLog.info(@">>>> Entering WSTestWS::start");

    switch(_function)
    {
        case "getSpeciesList":
            _jsonObjectToPost =
                    {
                        "jsonrpc": "2.0",
                        "method"                : "getSpeciesList",
//                        "params"                : { "date" : null, "types":["Client"], "beforeDate":null},
                        "params"                : {},
                        "id"                    : "102345112"
                    };

        break;

        break;

    }

/*
                                \"date\":\"2015-11-21T00:00:00+0100\",          \
                                \"motive\":null,
                                \"detail\":null,
                                \"isWaitingRoom\":null,
                                \"isHospitalized\":null,
                                \"isPaid\":0,
                                \"animalGuid\":\"1000014371469490872\",
                                \"ownerGuid\":\"13581589486013\",
                                \"visitType\":\"Vente\",
                                \"detailExt\":null,
                                \"objType\":\"Visit\""
*/

    /*
        "object": "\"vetupGuid\": \"1000013596413176956\",
            \"lastUpdate\": \"2013-01-31T15:08:54+0100\",
            \"date\": \"2013-01-31T15:07:00+0100\",
            \"motive\": null,
            \"detail\": null,
            \"isWaitingRoom\": null,
            \"isHospitalized\": null,
            \"isPaid\": 0,
            \"animalGuid\": \"1000014371469490872\",
            \"ownerGuid\": \"13581589486013\",
            \"visitType\": \"Vente\",
            \"detailExt\": null,
            \"objType\": \"Visit\"",
    */

    //"object": "{\"objType\":\"Visit\",\"lastUpdate\":\"2013-01-31 15:08:54\"}",
//"object": "{\"objType\":\"Visit\",\"lastUpdate\":\"2013-01-31 15:08:54\",\"date\":\"2015-11-21 00:00:00\"    }",

    [super start];
}

- (void) parseJSONResponse:(id)iResult
{
    CPLog.info(@">>>> Entering WSTestWS::parseJSONResponse: %@", iResult);

    [super parseJSONResponse:iResult];

/*
    if (WSNoError == self.error.code)
    {
        var data = iResult.data;
        _uid = data.uid;
        _name = data.name;
  //      _role = data.role;

        CPLog.debug(@" WSLogin: Role: %@  Name: %@", self._role, self._name);
    }
    else
    {
        CPLog.debug(@"<<<< TESTON !! PAS OK");

    }

    //TODO: parser les data, cf ci dessous en ios
*/

    CPLog.info(@"<<<< Leaving  WSTestWS::parseJSONResponse");
}


@end
