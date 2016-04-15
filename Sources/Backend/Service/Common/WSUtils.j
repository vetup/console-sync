@import <Foundation/Foundation.j>


WSProtocol				=  @"http";
WSSecuredProtocol		=  @"https";

WSKeyDBGSESSID			=  @"DBGSESSID";
WSPath					=  @"";
WSKeyMethod				=  @"method";
WSKeyTarget				=  @"target";
WSKeyVersion			=  @"version";
WSKeyErrorCode			=  @"code";
WSKeyErrorDesc			=  @"desc";


//WS Error Code
WSNoError           = @"WS_OK";
WSUnknownError      = @"WS_UNKNOW_ERROR";

//Pb de connexion au serveur / à internet
WSInternetError     = @"WS_INTERNET_ERROR";


//object type
KObjectTypeColor              = @"C_OBJECT_TYPE_COLOR";
KObjectTypeSpecieAndBreed     = @"C_OBJECT_TYPE_SPECIE_AND_BREED";
KObjectTypeSpecie             = @"C_OBJECT_TYPE_SPECIE";
KObjectTypeBreed              = @"C_OBJECT_TYPE_BREED";



/*
#define NLWSValueNoError                @"WS_OK"
#define NLWSValueUnknownError           @"WS_UNKNOWN_ERROR"
#define NLWSValueAuthenticationError    @"WS_USER_NOT_FOUND"
#define NLWSValueEmailNotValid          @"WS_DATA_EMAIL_NOT_VALID"
#define NLWSValueDataFileNotFoundError  @"WS_DATA_FILE_NOT_FOUND"
#define NLWSObsoleteVersionError        @"WS_OBSOLETE_VERSION_ERROR"
#define NLWSSessionExpiredError         @"WS_SESSION_EXPIRED_ERROR"
#define NLWSValueNoValidOrder           @"WS_USER_NO_ORDER"
//Achats inApp / gestion des abonnements
#define NLWSEmailExist                  @"WS_USER_EMAIL_EXIST"
#define NLWSUDIDExist                  @"WS_USER_UDID_EXIST"
//contrôle du multilogging sur ipad
#define NLWSUserAlreadyLoggedOnAnotherIPad @"WS_USER_ALREADY_LOGGED_ON_ANOTHER_IPAD"
*/


/*

// all
#define NLServicesErrorKey   @"error"
#define NLServicesJobKey	 @"job"

#define WSNoInternetNotification @"WSNoInternetNotification"

// account
#define WSLoginNotification			@"WSLoginNotification"
#define WSLogoutNotification		@"WSLogoutNotification"

// data
#define WSContentListNotification	@"WSContentListNotification"
#define WSSendEmailNotification     @"WSSendEmailNotification"
#define WSAddReadingStatRecordNotification     @"WSAddReadingStatRecordNotification"
#define WSGetUpdatedDataXMLNotification	@"WSGetUpdatedDataXMLNotification"



//Non Renewing Subscription Notifications
#define WSCreateRestoreAccountNotification		@"WSCreateRestoreAccountNotification"
#define WSSaveSubscriptionNotification          @"WSSaveSubscriptionNotification"
#define WSRestoreSubscriptionNotification		@"WSRestoreSubscriptionNotification"
#define WSRestoreAccountPasswordNotification	@"WSRestoreAccountPasswordNotification"


*/

