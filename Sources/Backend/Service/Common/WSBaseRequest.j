@import <Foundation/CPObject.j>
@import "./EDRequest.j"

@import "./WSUtils.j"

InfoGatewayKey           =  @"WS Gateway";
InfoTargetKey            =  @"Vetup Target Platform";
InfoVersionKey           =  @"Vetup Bundle Version";
ExportOnErrorKey         =  @"Export On Error";

GlobalIncrementalRequestId = 0;

@implementation WSBaseRequest : EDRequest
{
    CPString _host;
    CPString _path;
    CPString _subpath;
    CPString _protocol;

//  CPString _id @accessors(readonly, property=id);
}


#pragma mark -
#pragma mark Init / Dealloc

- (id)init
{
   // CPLog.info(@">>>> Entering WSBaseRequest::INIT");

    if (self = [super init])
    {
        _host            = [[CPBundle mainBundle] objectForInfoDictionaryKey:InfoGatewayKey];

        CPLog.info(@">>>>>>>> WSBaseRequest::INIT    host value: %@", self.host);

    //    self.host = [[UIApplication sharedApplication] VWSGateway];
        _path     = WSPath;
        _protocol = WSProtocol;
    }
    return self;
}


#pragma mark -
#pragma mark Start


- (void)setSecuredProtocol:(BOOL)value
{
    if (YES == value)
        _protocol = WSSecuredProtocol;
    else
        _protocol = WSProtocol;
}

+ (CPDictionary)_securityComponents
{
//#ifdef DEBUG_WS_PHP
    return [CPDictionary dictionaryWithObjectsAndKeys:
//          @"1",  WSKeyDBGSESSID]; //allow PHPEd debug
            @"-1", WSKeyDBGSESSID]; //disable PHPEd debug

//#endif
//    return nil;
}


- (void)start
{
//    CPLog.info(@">>>> Entering WSBaseRequest::start");

    //id global passé dans la requête
    GlobalIncrementalRequestId++;

    [self setSecuredProtocol:NO];

    var bundle  = [CPBundle mainBundle],
        target  = [bundle objectForInfoDictionaryKey:InfoTargetKey];

    if (0 != [_path length])
    {
        _URL = [CPURL URLWithString:[CPString stringWithFormat:@"%@://%@/%@/%@", _protocol, _host, _path, _subpath ]];
    } else
    {
        _URL = [CPURL URLWithString:[CPString stringWithFormat:@"%@://%@/%@", _protocol, _host, _subpath ]];
    }

//    CPLog.info(@">>>>>>>> WSBaseRequest::start   URL: %@   _queryInfo: %@", _URL, _queryInfo);

    var dic;

    if (_queryInfo != nil)
    {
        dic = [CPMutableDictionary dictionaryWithDictionary:_queryInfo];
    }
    {
        dic = [[CPMutableDictionary alloc] init];
    }

    [dic setObject:target forKey:WSKeyTarget];

    //PF VCC
    var version = [bundle objectForInfoDictionaryKey:InfoVersionKey];
    [dic setObject:version forKey:WSKeyVersion];


//    [dic addEntriesFromDictionary:[WSBaseRequest _securityComponents]];

    _queryInfo = dic;


    [super start];

//    CPLog.info(@"<<<<< Leaving WSBaseRequest::start:   queryInfo: %@", _queryInfo);

}

/*
Appelé par EDRequest lors d'un retour serveur, permet d'alimenter correctement le champ error pour un traitement ultérieur (cf WSRequestJob::jobTerminated pour pré traitement)
*/

- (void)parseJSONResponse:(id)iResult
{
    CPLog.info(@">>>> Entering WSBaseRequest::parseJSONResponse: %@", iResult);

    var code = iResult.code;

//pas d'affichage ici toute façon, trop tôt, on créée le champ error correctement
    self.error = [self _errorWithCode:code];

    CPLog.info(@"<<<< Leaving WSBaseRequest::parseJSONResponse");
}

- (WSError)_errorWithCode:(CPString)code
{
    var error = [[ErrorManager sharedManager] errorWithCodeAndDomain:code domain:WSVetupErrorDomain];
    return error;
}

- (void)_showaAlert:(CPString)iMsg
{
    var alertMessage = @"WS Error";
    var alertInformative =  [CPString stringWithFormat:@"Problème lors de la communication avec le serveur: \n%@",iMsg];

    var alert = [[CPAlert alloc] init];
//                [alert setDelegate:self];
    [alert setDelegate:nil];
    [alert setAlertStyle:CPCriticalAlertStyle];
    [alert addButtonWithTitle:@"Ok"];
//                [alert addButtonWithTitle:@"Report..."];
    [alert setMessageText:alertMessage];
    [alert setInformativeText:alertInformative];
    [alert runModal];
}

/*
- (void) parseXMLResponse:(GDataXMLDocument *)xml
{
//    NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);


//    NSString *xmlStr = [xml.XMLData dataUsingEncoding:NSUTF8StringEncoding];
    NSString *xmlStr = [[NSString alloc] initWithData:xml.XMLData encoding:NSUTF8StringEncoding];

//  NSLog( @"WSBaseRequest::parseXMLResponse: \n%@", xmlStr  );

    [xmlStr release];

    //on check si la base "code" est incluse dans la réponse
    GDataXMLElement *codeNode = [xml.rootElement childForName:NLWSKeyErrorCode];
    NL_CHECK_AND_SET_FORMAT_ERROR( codeNode );

    //on check si la base "code" est incluse dans la réponse
    GDataXMLElement *descNode = [xml.rootElement childForName:NLWSKeyErrorDesc];

    //Pas obligatoire
    //NL_CHECK_AND_SET_FORMAT_ERROR( descNode );

    NSString *codeWS = codeNode.stringValue;

    NSString *descWS = nil;

    if (descNode != nil)
        descWS = descNode.stringValue;


    [self _parseError:codeWS withDesc:descWS];


//    NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}



// MARK: protected



// MARK: private

//- (void) _parseError:(NSString *) codeWS;
- (void) _parseError:(NSString *) codeWS withDesc:(NSString *) descWS
{

    if ( [codeWS isEqualToString:NLWSValueNoError] )
    {
        return;
    }

    if ( [codeWS isEqualToString:NLWSValueAuthenticationError] )
    {
        NSString * authenticationErrorMsg = NSLocalizedString( @"Authentication error", @"Authentication error" );

        self.error = [NSError webServicesErrorWithCode:WS_AUTHENTICATION_ERROR
                                           description:authenticationErrorMsg];
        return;
    }

    if ( [codeWS isEqualToString:NLWSValueDataFileNotFoundError] )
    {
        NSString * contentErrorMsg = [NSString stringWithFormat:@"%@ desc: %@",
                                      NSLocalizedString( @"Data file error", @"Data file error" ),
                                      descWS];

        self.error = [NSError webServicesErrorWithCode:WS_CONTENT_LIST_ERROR
                                           description:contentErrorMsg];

        return;
    }

    if ( [codeWS isEqualToString:NLWSValueUnknownError] )
    {
        //NSString * unknownErrorMsg = NSLocalizedString( @"Unknown server error", @"Unknown server error" );

        NSString * unknownErrorMsg = [NSString stringWithFormat:@"%@ desc: %@",
                                      NSLocalizedString( @"Unknown server error", @"Unknown server error" ),
                                      descWS];


        self.error = [NSError webServicesErrorWithCode:WS_UNKNOWN_SERVER_ERROR
                                           description:unknownErrorMsg];
        return;
    }

    if ( [codeWS isEqualToString:NLWSValueEmailNotValid] )
    {
        //NSString * unknownErrorMsg = NSLocalizedString( @"Unknown server error", @"Unknown server error" );

        NSString * unknownErrorMsg = [NSString stringWithFormat:@"%@ desc: %@",
                                      NSLocalizedString( @"EMAIL_NOT_VALID", @"" ),
                                      descWS];


        self.error = [NSError webServicesErrorWithCode:WS_DATA_EMAIL_NOT_VALID
                                           description:unknownErrorMsg];
        return;
    }

    if ( [codeWS isEqualToString:NLWSValueNoValidOrder] )
    {
        //NSString * unknownErrorMsg = NSLocalizedString( @"Unknown server error", @"Unknown server error" );

        NSString * errorMsg = [NSString stringWithFormat:@"%@ desc: %@",
                                      NSLocalizedString( @"USER_NO_ORDER", @"" ),
                                      descWS];


        self.error = [NSError webServicesErrorWithCode:WS_USER_NO_VALID_ORDER
                                           description:errorMsg];
        return;
    }

    if ( [codeWS isEqualToString:NLWSSessionExpiredError] )
    {

        NSString * unknownErrorMsg = @"";

        self.error = [NSError webServicesErrorWithCode:WS_EXPIRED_SESSION_ERROR
                                           description:unknownErrorMsg];
        return;
    }

    if ( [codeWS isEqualToString:NLWSEmailExist] )
    {

        NSString * unknownErrorMsg = @"";

        self.error = [NSError webServicesErrorWithCode:WS_EMAIL_EXIST
                                           description:unknownErrorMsg];
        return;
    }

    if ( [codeWS isEqualToString:NLWSUDIDExist] )
    {

        NSString * unknownErrorMsg = @"";

        self.error = [NSError webServicesErrorWithCode:WS_UDID_EXIST
                                           description:unknownErrorMsg];
        return;
    }

    if ( [codeWS isEqualToString:NLWSUserAlreadyLoggedOnAnotherIPad] )
    {

        NSString * unknownErrorMsg = @"";

        self.error = [NSError webServicesErrorWithCode:WS_USER_ALREADY_LOGGED_ON_ANOTHER_IPAD
                                           description:unknownErrorMsg];
        return;
    }



    //On bloque l'app ! => force une mise à jour (pas de bouton de sortie de l'alert box modale)
    if ( [codeWS isEqualToString:NLWSObsoleteVersionError] )
    {
        NSString * versionErrorMsg = NSLocalizedString( @"GLOBAL_OBSOLETE_VERSION", @"" );


        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:versionErrorMsg
                              message:nil delegate:nil
                              cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        [alert release];

        return;
    }

    //PF VCC
    NSString * unknownErrorFmtMsg = NSLocalizedString( @"%@", @"Unkown error" );
    NSString * unknownErrorMsg = [NSString stringWithFormat:unknownErrorFmtMsg, codeWS];

    self.error = [NSError webServicesErrorWithCode:WS_UNKNOWN_ERROR description:unknownErrorMsg];

    return;
}
*/


@end
