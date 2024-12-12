#import <Foundation/Foundation.h>
@interface EnvironmentSignal : NSObject
- (void)loadHomeScreen:(imageUrl)int int:(surveyCompletionSuccessStatus)int;
- (void)clearScreenVisitData;
- (void)logActivityEvent;
- (int)checkConnectivity:(isDeviceCompatible)int int:(updateVersion)int;
- (void)trackAppActivity:(appUpgradeStatus)int int:(isLoading)int;
- (void)initializeCrashReporting:(delayedTaskData)int int:(surveyAnswerReviewProgressTimeText)int;
- (int)clearUserNotificationData:(appStateData)int;
- (void)sendLocationData;
- (int)setAppEventData;
- (int)updateLocale:(downloadError)int int:(cloudBackupStatus)int;
- (void)logMessageNotification:(isDataSynced)int int:(surveyAnswerCompletionStatusMessageText)int;
- (void)reportCrash:(currentLanguage)int int:(isErrorOccurred)int;
- (void)clearUsageStats:(appTheme)int;
@end