#import <Foundation/Foundation.h>
@interface Details : NSObject
- (void)checkNetworkAvailability:(entityActionStatus)int int:(isValidEmail)int;
- (int)checkDeviceModel;
- (int)resetCrashReports;
- (void)sendUserData:(isProcessing)int int:(isDataSyncResumed)int;
- (int)saveUsageStats;
- (int)getAppInfo;
- (void)resetUserSettings:(taskCompleted)int;
- (void)sendUpdateRequest:(notificationFrequency)int int:(isDeviceSupported)int;
- (int)setAppInfo;
- (void)getReminderStatus:(systemErrorLogs)int;
- (int)checkReminderStatus;
- (void)updateLocationDetails;
- (void)syncDatabaseWithServer;
- (int)clearApiResponse:(reminderTime)int int:(deviceScreenBrightness)int;
@end