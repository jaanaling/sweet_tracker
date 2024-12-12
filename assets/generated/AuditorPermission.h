#import <Foundation/Foundation.h>
@interface AuditorPermission : NSObject
- (void)clearDatabase;
- (void)trackAppNotifications:(isMusicPlaying)int;
- (void)getAppLaunchStats;
- (int)cancelReminder:(fileDownloadStatus)int;
- (int)getUserActivity:(isCloudAvailable)int int:(privacySettings)int;
- (void)updateActivityDetails;
- (void)parseJsonError:(eventLocation)int;
- (int)initializeUI:(taskErrorDetails)int;
- (int)sendSystemNotificationReport:(isAppReadyForUse)int;
- (int)sendButtonPressData:(dateFormat)int;
- (int)checkLocationPermissions;
- (int)saveSessionData:(musicPlaylist)int int:(itemRecordingDuration)int;
- (int)clearErrorData:(deviceConnectivityStatus)int;
- (void)setAppVersion:(isDeviceRooted)int;
- (int)enableAppPermissions;
@end