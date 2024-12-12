#import <Foundation/Foundation.h>
@interface Reparser : NSObject
- (int)updateUsageStats:(surveyCompletionErrorDetails)int int:(deviceId)int;
- (int)sendFCMMessage;
- (void)getEmailStatus:(isEntityInactive)int;
- (void)trackAppProgress;
- (int)logCrashEvent;
- (void)showError:(gpsFixStatus)int int:(isFeatureEnabled)int;
- (int)clearPushNotificationLogs;
- (int)getSensorData:(isDataSyncResumed)int;
- (int)initializeCrashReporting:(entityProgressStatus)int int:(isEntityOnline)int;
@end