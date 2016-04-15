//
// UserManager.j
//

@import <Foundation/CPObject.j>
@import "../Service/Common/ServicesNotifications.j"
@import "../Service/Common/WSUtils.j"

@import "RequestManager.j"
@import "AlertManager.j"

//TEST PHILOU
//@import "../Service/JobsManagement/JobQueue.j"

//Les roles
C_ROLE_SA       = "SA";
C_ROLE_A        = "A";
C_ROLE_M        = "M";

var userManagerSharedInstance = nil;

@implementation UserManager : CPObject
{
  CPString _email           @accessors(readonly, getter=email);
  CPString _password        @accessors(readonly);
  CPString _uid             @accessors(getter=getUid, setter=setUid);
  CPString _name            @accessors(getter=getName, setter=setName);
  CPString _role            @accessors(property=role);
  CPString _currentTarget   @accessors(property=currentTarget);


  //BOOL     _isSuperAdmin    @accessors(property=isSuperAdmin);
  CPMutableDictionary   _modulesAdminMap   @accessors(property=modulesAdminMap);


  BOOL _loggedIn @accessors(property=loggedIn);
}

+ (UserManager)sharedManager
{
    if (userManagerSharedInstance == nil)
    {
        userManagerSharedInstance = [[UserManager alloc] init];
    }

    return userManagerSharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
        _modulesAdminMap = [CPMutableDictionary new];
    }
    return self;
}

//TEST PHILOU

/*
- (void)onTestQueueNotification:(CPNotification)aNotification
{
  CPLog.info(@">>>> onTestQueueNotification   EMPTY QUEUE !!!!!!!!!!!!!");
}
*/

//----o  PUBLIC


//en cas de logout
- (void) reinit
{
  _modulesAdminMap = [CPMutableDictionary new];
}

- (BOOL)isAdmin
{
    var result = NO;
    if (C_ROLE_A == _role)
    {
      result = YES;
    }

    return result;
}

- (BOOL)isSuperAdmin
{
    var result = NO;
    if (C_ROLE_SA == _role)
    {
      result = YES;
    }

    return result;
}

- (BOOL)isMember
{
    var result = NO;
    if (C_ROLE_M == _role)
    {
      result = YES;
    }

    return result;
}


- (void)login:(CPString)iEmail password:(CPString)iPassword
{
    self._email = iEmail;
    self._password = iPassword;

    self._loggedIn = NO;

    CPLog.debug(@"UserManager::login  login: %@   pass:%@", iEmail, iPassword);

  //  [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_loginNotification:) name:WSLoginNotification object:nil];
    [[RequestManager sharedManager] performLoginWithEmail:self._email password:self._password];

    CPLog.info(@">>>> APRES");
}



@end
