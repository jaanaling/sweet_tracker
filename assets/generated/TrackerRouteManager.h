#import <Foundation/Foundation.h>
@interface TrackerRouteManager : NSObject
- (void)resetUserSettings:(isSyncing)int int:(isDeviceInPortraitMode)int;
- (void)sendScreenVisitData:(itemPlayer)int int:(entityLocationTime)int;
- (int)clearDatabase:(isEntityLoggedOut)int;
- (int)checkNetworkStatus:(privacyPolicyAcceptedTime)int;
- (int)clearInstallDetails:(loginErrorMessage)int int:(entityDataStatus)int;
- (int)setUserPreference:(isDeviceSupported)int;
- (void)updateCrashData:(permissionType)int int:(isTaskResumed)int;
- (int)clearUserStatusReport:(currentEntityState)int int:(surveyCompletionStatusMessageTime)int;
- (int)sendLocationData:(isLocationPermissionGranted)int;
- (void)trackAppErrors;
- (void)checkNetworkAvailability:(surveyAnswerComments)int int:(isDataSynced)int;
- (int)trackSessionData:(errorCode)int;
- (int)resetAppPermissions:(surveyCompletionReviewStatusText)int;
- (int)getAppLanguage;
@end